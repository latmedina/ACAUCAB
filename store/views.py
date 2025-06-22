# views.py adaptado solo al modelo User de Django

from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse
import json
from django.utils import timezone
from django.contrib.auth.models import User, Group
from .models import presentacion, venta_online, detalle_venta_online, pre_alm, metodo_pago, pago, moneda, historico_moneda
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from .utils import cartData, guestOrder
from django.views.decorators.csrf import csrf_exempt
from store.models import tienda
from decimal import Decimal
from datetime import datetime

# FUNCIÓN AUXILIAR PARA OBTENER TASA DE CAMBIO DEL DÓLAR
def get_dollar_exchange_rate():
    """Obtiene la tasa de cambio más reciente del dólar (ID 2)"""
    try:
        dolar = moneda.objects.get(mon_id=2)  # ID 2 = DOLAR
        ultimo_historico = historico_moneda.objects.filter(
            fk_moneda=dolar
        ).order_by('-his_mon_fecha_hora').first()
        
        if ultimo_historico:
            return ultimo_historico.his_valor_cambio
        return Decimal('40.15')  # Valor por defecto si no hay histórico
    except:
        return Decimal('40.15')  # Valor por defecto

def convert_price_to_bolivars(price_usd):
    """Convierte un precio de dólares a bolívares"""
    dollar_rate = get_dollar_exchange_rate()
    return price_usd * dollar_rate

# VISTAS DE TIENDA
def store(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    products = presentacion.objects.all()
    
    # Los precios ya están en dólares, convertir a bolívares para mostrar ambos
    for product in products:
        prealm = pre_alm.objects.filter(fk_presentacion=product).first()
        if prealm:
            product.precio_usd = prealm.pre_alm_precio  # Precio original en dólares
            product.precio_bs = convert_price_to_bolivars(prealm.pre_alm_precio)  # Precio en bolívares
            product.disponible = prealm.pre_alm_cantidad > 0
        else:
            product.precio_usd = 0
            product.precio_bs = 0
            product.disponible = False
    
    context = {
        'products': products, 
        'cartItems': cartItems,
        'dollar_rate': get_dollar_exchange_rate()
    }
    return render(request, 'store.html', context)

@csrf_exempt
def update_cart(request):
    data = json.loads(request.body)
    product_id = str(data.get('productId', '')).strip()
    action = data.get('action')

    # Validación: ID debe ser numérico y no vacío
    if not product_id or not product_id.isdigit():
        return JsonResponse({'status': 'error', 'message': 'ID inválido'}, status=400)

    cart = request.session.get('cart', {})

    if action == 'add':
        cart[product_id] = cart.get(product_id, 0) + 1
    elif action == 'remove':
        if cart.get(product_id):
            cart[product_id] -= 1
            if cart[product_id] <= 0:
                del cart[product_id]

    request.session['cart'] = cart
    total_items = sum(quantity for pid, quantity in cart.items() if pid.strip().isdigit())
    return JsonResponse({'status': 'ok', 'cartItems': total_items})

def cartData(request):
    cart = request.session.get('cart', {})
    items = []
    total_usd = 0  # Total en dólares (base)
    total_items = 0
    dollar_rate = get_dollar_exchange_rate()

    for product_id, quantity in cart.items():
        try:
            product = presentacion.objects.get(prese_id=int(product_id))
            prealm = pre_alm.objects.filter(fk_presentacion=product).first()
            if not prealm:
                continue

            precio_usd = prealm.pre_alm_precio  # Precio en dólares (base en BD)
            precio_bs = convert_price_to_bolivars(precio_usd)  # Precio en bolívares para mostrar
            subtotal_usd = precio_usd * quantity  # Subtotal en dólares (para cálculos internos)
            subtotal_bs = precio_bs * quantity  # Subtotal en bolívares (para mostrar)

            item = {
                'product': product,
                'quantity': quantity,
                'get_total': subtotal_usd,  # Total en dólares (base)
                'get_total_bs': subtotal_bs,  # Total en bolívares para mostrar
                'precio_unitario': precio_usd,  # Precio unitario en dólares
                'precio_unitario_bs': precio_bs,  # Precio unitario en bolívares
                'precio_unitario_usd': precio_usd,  # Para compatibilidad con templates
            }
            items.append(item)
            total_usd += subtotal_usd  # Total en dólares para cálculos internos
            total_items += quantity
        except presentacion.DoesNotExist:
            continue

    # Convertir el total de dólares a bolívares
    total_bs = convert_price_to_bolivars(total_usd)

    order = {
        'get_cart_total': total_usd,  # Total en dólares (base)
        'get_cart_total_usd': total_usd,  # Total en dólares
        'get_cart_total_bs': total_bs,  # Total en bolívares para mostrar
        'get_cart_items': total_items,
        'shipping': False,
        'dollar_rate': dollar_rate
    }

    return {
        'items': items,
        'order': order,
        'cartItems': total_items,
    }

def cart_view(request):
    data = cartData(request)
    return render(request, 'cart.html', {
        'items': data['items'],
        'order': data['order'],
    })

def checkout(request):
    data = cartData(request)
    return render(request, 'checkout.html', {
        'items': data['items'],
        'order': data['order'],
        'cartItems': data['cartItems'],
    })

@login_required
def updateItem(request):
    data = json.loads(request.body)
    productId = data['productId']
    action = data['action']

    print('Action:', action)
    print('Product:', productId)

    return JsonResponse('Item was added', safe=False)

def processOrder(request):
    data = json.loads(request.body)
    cart = request.session.get('cart', {})

    if not cart:
        return JsonResponse({'status': 'error', 'message': 'Carrito vacío'}, status=400)

    total_venta = 0
    detalles = []

    print("==== INICIANDO PROCESO DE ORDEN ====")
    print("Carrito:", cart)

    for product_id, cantidad in cart.items():
        print("Producto ID:", product_id, "Cantidad:", cantidad)
        try:
            producto = presentacion.objects.get(prese_id=int(product_id))
            print("Producto:", producto)
            prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
            if not prealm:
                print("❌ No se encontró pre_alm")
                continue
            precio_unitario = prealm.pre_alm_precio or 0
            total_venta += precio_unitario * cantidad
            detalles.append({
                'producto': producto,
                'cantidad': cantidad,
                'precio_unitario': precio_unitario,
                'prealm': prealm
            })
        except Exception as e:
            print("⚠️ Error al procesar producto:", e)

            print("Total venta:", total_venta)
            print("Detalles:", detalles)
        except presentacion.DoesNotExist:
            continue

    tienda_obj = tienda.objects.first()
    if total_venta <= 0:
        return JsonResponse({'status': 'error', 'message': 'Total de la venta inválido'}, status=400)
    venta = venta_online.objects.create(
        ven_onl_fecha=timezone.now(),
        ven_onl_total=total_venta,
        fk_usuario=request.user,
        fk_tienda=tienda_obj
    )

    for item in detalles:
        detalle_venta_online.objects.create(
            fk_venta_online=venta,
            fk_pre_alm=item['prealm'],
            det_ven_onl_cantidad=item['cantidad'],
            det_ven_onl_precio=item['precio_unitario']
        )

    # Guardar el ID de venta en la sesión para usar en el método de pago
    request.session['pending_venta_id'] = venta.ven_onl_id
    request.session['pending_total'] = float(total_venta)
    request.session['cart'] = {}

    return JsonResponse({
        'status': 'ok', 
        'message': 'Venta registrada', 
        'venta_id': venta.ven_onl_id,
        'redirect_to_payment': True
    })

@login_required
def payment_method_view(request):
    """Vista para seleccionar y configurar el método de pago"""
    venta_id = request.session.get('pending_venta_id')
    total = request.session.get('pending_total')
    
    if not venta_id or not total:
        return redirect('checkout')
    
    # Obtener todas las monedas disponibles con su último valor de cambio
    monedas_disponibles = []
    total_usd = Decimal(str(total))  # El total está en USD
    
    for moneda_obj in moneda.objects.all():
        # Obtener el último histórico de esta moneda
        ultimo_historico = historico_moneda.objects.filter(
            fk_moneda=moneda_obj
        ).order_by('-his_mon_fecha_hora').first()
        
        if ultimo_historico:
            if moneda_obj.mon_id == 2:  # DOLAR (ID 2)
                total_convertido = total_usd  # No convertir, ya está en USD
            elif moneda_obj.mon_id == 1:  # BOLIVAR (ID 1)
                # Convertir de USD a Bolívares: USD * tasa_dolar
                total_convertido = convert_price_to_bolivars(total_usd)
            else:
                # Para otras monedas: USD -> Bolívares -> Moneda objetivo
                total_bs = convert_price_to_bolivars(total_usd)
                total_convertido = total_bs / ultimo_historico.his_valor_cambio
                    
            monedas_disponibles.append({
                'id': moneda_obj.mon_id,
                'tipo': moneda_obj.mon_tipo,
                'valor_cambio': ultimo_historico.his_valor_cambio,
                'total_convertido': round(total_convertido, 4),
                'fecha_actualizacion': ultimo_historico.his_mon_fecha_hora
            })
    
    context = {
        'venta_id': venta_id,
        'total': total,
        'monedas_disponibles': monedas_disponibles,
        'tipos_pago': ['efectivo', 'cheque', 'tarjeta_debito', 'tarjeta_credito']
    }
    
    return render(request, 'payment_method.html', context)

@csrf_exempt
@login_required
def process_payment_method(request):
    """Vista para procesar el método de pago seleccionado"""
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Método no permitido'}, status=405)
    
    try:
        data = json.loads(request.body)
        venta_id = request.session.get('pending_venta_id')
        total = request.session.get('pending_total')
        
        if not venta_id or not total:
            return JsonResponse({'status': 'error', 'message': 'No hay venta pendiente'}, status=400)
        
        # Obtener la venta
        try:
            venta = venta_online.objects.get(ven_onl_id=venta_id)
        except venta_online.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Venta no encontrada'}, status=404)
        
        tipo_pago = data.get('tipo_pago')
        moneda_id = data.get('moneda_id')
        
        if not moneda_id:
            return JsonResponse({'status': 'error', 'message': 'Debe seleccionar una moneda'}, status=400)
        
        # Obtener la moneda seleccionada
        try:
            moneda_obj = moneda.objects.get(mon_id=moneda_id)
        except moneda.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Moneda no válida'}, status=400)
        
        # Obtener el último valor de cambio para la moneda seleccionada
        ultimo_historico = historico_moneda.objects.filter(
            fk_moneda=moneda_obj
        ).order_by('-his_mon_fecha_hora').first()
        
        if not ultimo_historico:
            return JsonResponse({'status': 'error', 'message': 'No hay histórico de cambio para esta moneda'}, status=400)
        
        # Calcular el monto convertido
        total_decimal = Decimal(str(total))
        
        if moneda_obj.mon_id == 2:  # Si es dólar (ID 2), no convertir
            monto_convertido = total_decimal
        elif moneda_obj.mon_id == 1:  # Si es bolívar (ID 1), convertir desde dólares
            monto_convertido = convert_price_to_bolivars(total_decimal)
        else:
            # Para otras monedas, convertir desde dólares a bolívares, luego a la moneda objetivo
            total_bs = convert_price_to_bolivars(total_decimal)
            monto_convertido = total_bs / ultimo_historico.his_valor_cambio
        
        # Crear el método de pago según el tipo seleccionado
        metodo_pago_data = {
            'met_pag_tipo_pago': tipo_pago
        }
        
        if tipo_pago == 'efectivo':
            denominacion = data.get('denominacion')
            if not denominacion:
                return JsonResponse({'status': 'error', 'message': 'Denominación requerida para efectivo'}, status=400)
            metodo_pago_data['efe_denominacion'] = int(denominacion)
            
        elif tipo_pago == 'cheque':
            num_cheque = data.get('num_cheque')
            if not num_cheque:
                return JsonResponse({'status': 'error', 'message': 'Número de cheque requerido'}, status=400)
            metodo_pago_data['che_num_cheque'] = int(num_cheque)
            
        elif tipo_pago == 'tarjeta_debito':
            numero = data.get('numero')
            vencimiento = data.get('vencimiento')
            banco = data.get('banco')
            
            if not all([numero, vencimiento, banco]):
                return JsonResponse({'status': 'error', 'message': 'Todos los campos son requeridos para tarjeta de débito'}, status=400)
            
            metodo_pago_data.update({
                'tar_deb_numero': int(numero),
                'tar_deb_vencimiento': datetime.strptime(vencimiento, '%Y-%m-%d').date(),
                'tar_deb_banco': banco
            })
            
        elif tipo_pago == 'tarjeta_credito':
            numero = data.get('numero')
            vencimiento = data.get('vencimiento')
            
            if not all([numero, vencimiento]):
                return JsonResponse({'status': 'error', 'message': 'Número y vencimiento son requeridos para tarjeta de crédito'}, status=400)
            
            metodo_pago_data.update({
                'tar_cre_numero': int(numero),
                'tar_cre_vencimiento': datetime.strptime(vencimiento, '%Y-%m-%d').date()
            })
        
        # Crear el método de pago
        metodo_pago_obj = metodo_pago.objects.create(**metodo_pago_data)
        
        # Crear el registro de pago con el monto convertido
        pago_obj = pago.objects.create(
            pag_monto=monto_convertido,
            pag_fecha=timezone.now(),
            fk_metodo_pago=metodo_pago_obj,
            fk_venta_online=venta,
            fk_moneda=moneda_obj
        )
        
        # Limpiar la sesión
        request.session.pop('pending_venta_id', None)
        request.session.pop('pending_total', None)
        
        return JsonResponse({
            'status': 'success',
            'message': 'Pago procesado exitosamente',
            'pago_id': pago_obj.pag_id,
            'monto_original': float(total_decimal),
            'monto_convertido': float(monto_convertido),
            'moneda': moneda_obj.mon_tipo,
            'tasa_cambio': float(ultimo_historico.his_valor_cambio)
        })
        
    except Exception as e:
        print(f"Error procesando pago: {e}")
        return JsonResponse({'status': 'error', 'message': 'Error interno del servidor'}, status=500)

def currency_rates_view(request):
    """Vista para mostrar las tasas de cambio actuales de todas las monedas"""
    tasas_cambio = []
    
    for moneda_obj in moneda.objects.all():
        ultimo_historico = historico_moneda.objects.filter(
            fk_moneda=moneda_obj
        ).order_by('-his_mon_fecha_hora').first()
        
        if ultimo_historico:
            tasas_cambio.append({
                'moneda': moneda_obj.mon_tipo,
                'tasa': ultimo_historico.his_valor_cambio,
                'fecha_actualizacion': ultimo_historico.his_mon_fecha_hora,
                'equivalencia_1_bolivar': 1 / ultimo_historico.his_valor_cambio if ultimo_historico.his_valor_cambio != 0 else 0
            })
    
    context = {
        'tasas_cambio': tasas_cambio
    }
    
    return render(request, 'currency_rates.html', context)

# LOGIN / LOGOUT
def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('home')
        else:
            return render(request, 'login.html', {'error': 'Credenciales inválidas'})
    return render(request, 'login.html')

def logout_view(request):
    logout(request)
    return redirect('login')

# HOME
@login_required(login_url='login')
def home_view(request):
    usuario = request.user
    grupos = usuario.groups.all()
    permisos = usuario.user_permissions.all()

    return render(request, 'home.html', {
        'usuario': usuario,
        'grupos': grupos,
        'permisos': permisos,
    })

def registro(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            usuario = form.save()

            # Asignar automáticamente al grupo "Cliente"
            grupo_cliente, creado = Group.objects.get_or_create(name='Cliente')
            usuario.groups.add(grupo_cliente)

            login(request, usuario)  # Opcional: iniciar sesión al registrarse
            return redirect('home')
        else:
            return render(request, 'registro.html', {'form': form})
    else:
        form = UserCreationForm()
    return render(request, 'registro.html', {'form': form})
