from django.shortcuts import render, redirect
from django.http import JsonResponse
import json
from django.utils import timezone
from django.contrib.auth.models import User, Group
from django.contrib import messages
from django.db import connection, transaction
from django.http import JsonResponse, HttpResponseNotFound
from django.http import JsonResponse, HttpResponse, HttpResponseNotFound
from django.core.serializers.json import DjangoJSONEncoder
from .models import (
    presentacion, venta_online, detalle_venta_online, pre_alm, 
    metodo_pago, pago, moneda, historico_moneda, tienda, 
    inventario, venta_fisica, detalle_venta_fisica, cliente, proveedor, empleado, emp_car, usuario, lugar
)
from django.db import connection
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from decimal import Decimal
from datetime import datetime, date
from .forms import ClienteForm, EmpleadoForm, ProveedorForm
from .utils import crear_usuario_sql

def validate_expiration_date(exp_date_str):
    """Valida que la fecha de vencimiento no sea anterior a la actual"""
    try:
        exp_date = datetime.strptime(exp_date_str, '%Y-%m-%d').date()
        today = date.today()
        
        # Comparar año y mes (ignorar el día)
        if exp_date.year < today.year:
            return False
        if exp_date.year == today.year and exp_date.month < today.month:
            return False
        
        return True
    except (ValueError, TypeError):
        return False

def validate_payment_data(tipo_pago, data):
    """Valida los datos del método de pago"""
    errors = []
    
    if tipo_pago == 'efectivo':
        denominacion = data.get('denominacion')
        if not denominacion:
            errors.append('Denominación requerida para efectivo')
        else:
            try:
                denom_int = int(denominacion)
                if denom_int <= 0:
                    errors.append('La denominación debe ser mayor a 0')
            except (ValueError, TypeError):
                errors.append('Denominación inválida')
                
    elif tipo_pago == 'cheque':
        num_cheque = data.get('num_cheque')
        if not num_cheque:
            errors.append('Número de cheque requerido')
        else:
            try:
                cheque_int = int(num_cheque)
                if cheque_int <= 0:
                    errors.append('El número de cheque debe ser mayor a 0')
            except (ValueError, TypeError):
                errors.append('Número de cheque inválido')
                
    elif tipo_pago == 'tarjeta_debito':
        numero = data.get('numero', '').replace(' ', '')
        vencimiento = data.get('vencimiento')
        banco = data.get('banco', '').strip()
        
        if not numero:
            errors.append('Número de tarjeta de débito requerido')

            
        if not vencimiento:
            errors.append('Fecha de vencimiento requerida para tarjeta de débito')
        elif not validate_expiration_date(vencimiento):
            errors.append('La fecha de vencimiento de la tarjeta de débito no puede ser anterior a la fecha actual')
            
        if not banco or len(banco) < 2:
            errors.append('Nombre del banco requerido para tarjeta de débito')
            
    elif tipo_pago == 'tarjeta_credito':
        numero = data.get('numero', '').replace(' ', '')
        vencimiento = data.get('vencimiento')
        
        if not numero:
            errors.append('Número de tarjeta de crédito requerido')
            
        if not vencimiento:
            errors.append('Fecha de vencimiento requerida para tarjeta de crédito')
        elif not validate_expiration_date(vencimiento):
            errors.append('La fecha de vencimiento de la tarjeta de crédito no puede ser anterior a la fecha actual')
    
    return errors

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

# FUNCIÓN AUXILIAR PARA DATOS DEL CARRITO (VERSIÓN ORIGINAL)
def cartData(request):
    """Función original para carrito básico"""
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

# FUNCIÓN AUXILIAR GENERALIZADA PARA CARRITO (NUEVA VERSIÓN)
def cart_data(request, tipo='fisica'):
    """Función generalizada para carrito físico y online"""
    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})
    items, total_usd, total_items = [], 0, 0
    dollar_rate = get_dollar_exchange_rate()

    for product_id, quantity in cart.items():
        try:
            producto = presentacion.objects.get(pk=int(product_id))
            
            if tipo == 'fisica':
                # Para tienda física: usar tabla inventario
                inventario_item = inventario.objects.filter(fk_presentacion=producto).first()
                if not inventario_item:
                    continue
                precio_usd = inventario_item.inv_precio_unitario
                source_item = inventario_item
            else:
                # Para tienda online: usar tabla pre_alm
                prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
                if not prealm:
                    continue
                precio_usd = prealm.pre_alm_precio
                source_item = prealm
            
            precio_bs = convert_price_to_bolivars(precio_usd)
            subtotal_usd = precio_usd * quantity
            subtotal_bs = precio_bs * quantity

            item_data = {
                'product': producto,
                'quantity': quantity,
                'get_total': subtotal_usd,
                'get_total_bs': subtotal_bs,
                'precio_unitario': precio_usd,
                'precio_unitario_bs': precio_bs,
                'precio_unitario_usd': precio_usd,
            }
            
            # Agregar la referencia correcta según el tipo
            if tipo == 'fisica':
                item_data['inventario'] = source_item
            else:
                item_data['prealm'] = source_item
            
            items.append(item_data)
            total_usd += subtotal_usd
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
        'cartItems': total_items
    }

# VISTAS DE TIENDA
def redirect_store(request):
    """Redirecciona a la tienda física por defecto"""
    return redirect('store_view', tipo='fisica')

def store(request):
    """Vista de tienda básica (original)"""
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

def store_view(request, tipo='fisica', extra_context=None):
    """Vista general de tienda (física/online)"""
    data = cart_data(request, tipo)
    productos = presentacion.objects.all()
    
    for p in productos:
        if tipo == 'fisica':
            # Para tienda física: usar tabla inventario
            inventario_item = inventario.objects.filter(fk_presentacion=p).first()
            if inventario_item:
                p.precio_usd = inventario_item.inv_precio_unitario
                p.precio_bs = convert_price_to_bolivars(inventario_item.inv_precio_unitario)
                p.disponible = inventario_item.inv_cantidad > 0
                p.cantidad_disponible = inventario_item.inv_cantidad  # Mostrar cantidad exacta
                p.stock_info = f"En stock: {inventario_item.inv_cantidad} unidades"
            else:
                p.precio_usd = 0
                p.precio_bs = 0
                p.disponible = False
                p.cantidad_disponible = 0
                p.stock_info = "No disponible en tienda física"
        else:
            # Para tienda online: usar tabla pre_alm
            prealm = pre_alm.objects.filter(fk_presentacion=p).first()
            if prealm:
                p.precio_usd = prealm.pre_alm_precio
                p.precio_bs = convert_price_to_bolivars(prealm.pre_alm_precio)
                p.disponible = prealm.pre_alm_cantidad > 0
                p.cantidad_disponible = prealm.pre_alm_cantidad  # Mostrar cantidad exacta
                p.stock_info = f"En stock: {prealm.pre_alm_cantidad} unidades"
            else:
                p.precio_usd = 0
                p.precio_bs = 0
                p.disponible = False
                p.cantidad_disponible = 0
                p.stock_info = "No disponible en tienda online"

    # Contexto base
    context = {
        'products': productos,
        'cartItems': data['cartItems'],
        'tipo': tipo,
        'dollar_rate': get_dollar_exchange_rate()
    }
    
    # Añadir contexto extra si se proporciona (para autopago)
    if extra_context:
        context.update(extra_context)

    template = 'tienda_fisica.html' if tipo == 'fisica' else 'store.html'
    return render(request, template, context)

# ACTUALIZAR CARRITO
@csrf_exempt
def update_cart(request):
    """Actualizar carrito básico"""
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

@csrf_exempt
def update_cart_view(request, tipo):
    """Actualizar carrito generalizado (física/online) con validación de inventario"""
    data = json.loads(request.body)
    product_id = str(data.get('productId', '')).strip()
    action = data.get('action')

    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})

    # Validar inventario antes de añadir al carrito
    if action == 'add':
        try:
            producto = presentacion.objects.get(prese_id=int(product_id))
            nueva_cantidad = cart.get(product_id, 0) + 1
            
            # Verificar disponibilidad según el tipo de tienda
            if tipo == 'fisica':
                # Para tienda física: verificar tabla inventario
                inventario_item = inventario.objects.filter(fk_presentacion=producto).first()
                if not inventario_item:
                    return JsonResponse({
                        'status': 'error', 
                        'message': f'Producto "{producto.prese_nombre}" no disponible en tienda física'
                    }, status=400)
                
                if inventario_item.inv_cantidad < nueva_cantidad:
                    return JsonResponse({
                        'status': 'error', 
                        'message': f'Inventario insuficiente para "{producto.prese_nombre}". Disponible: {inventario_item.inv_cantidad}, Solicitado: {nueva_cantidad}'
                    }, status=400)
                    
            else:
                # Para tienda online: verificar tabla pre_alm
                prealm_item = pre_alm.objects.filter(fk_presentacion=producto).first()
                if not prealm_item:
                    return JsonResponse({
                        'status': 'error', 
                        'message': f'Producto "{producto.prese_nombre}" no disponible en tienda online'
                    }, status=400)
                
                if prealm_item.pre_alm_cantidad < nueva_cantidad:
                    return JsonResponse({
                        'status': 'error', 
                        'message': f'Stock insuficiente para "{producto.prese_nombre}". Disponible: {prealm_item.pre_alm_cantidad}, Solicitado: {nueva_cantidad}'
                    }, status=400)
            
            # Si pasa las validaciones, añadir al carrito
            cart[product_id] = nueva_cantidad
            
        except presentacion.DoesNotExist:
            return JsonResponse({
                'status': 'error', 
                'message': 'Producto no encontrado'
            }, status=404)
        except ValueError:
            return JsonResponse({
                'status': 'error', 
                'message': 'ID de producto inválido'
            }, status=400)
            
    elif action == 'remove' and cart.get(product_id):
        cart[product_id] -= 1
        if cart[product_id] <= 0:
            del cart[product_id]

    request.session[cart_key] = cart
    total_items = sum(q for _, q in cart.items() if str(q).isdigit())
    return JsonResponse({'status': 'ok', 'cartItems': total_items})

# VISTAS DE CARRITO
@csrf_exempt
def cart_dropdown_data(request):
    """Vista AJAX para obtener datos del carrito para el dropdown"""
    try:
        # Usar carrito físico por defecto
        data = cart_data(request, tipo='fisica')
        
        cart_items = []
        for item in data['items']:
            cart_items.append({
                'product_id': item['product'].prese_id,
                'name': item['product'].prese_nombre,
                'quantity': item['quantity'],
                'price_usd': float(item['precio_unitario_usd']),
                'price_bs': float(item['precio_unitario_bs']),
                'subtotal_usd': float(item['get_total']),
                'subtotal_bs': float(item['get_total_bs']),
                'image': item['product'].get_imagen_url() if item['product'].prese_imagen else None,
            })
        
        response_data = {
            'items': cart_items,
            'total_items': data['cartItems'],
            'total_usd': float(data['order']['get_cart_total_usd']),
            'total_bs': float(data['order']['get_cart_total_bs']),
            'dollar_rate': float(data['order']['dollar_rate']),
            'empty': len(cart_items) == 0
        }
        
        return JsonResponse(response_data)
        
    except Exception as e:
        return JsonResponse({
            'error': True,
            'message': str(e),
            'items': [],
            'total_items': 0,
            'total_usd': 0,
            'total_bs': 0,
            'empty': True
        })

# VISTAS DE AUTOPAGO
def autopago_inicio(request):
    """Vista de inicio del sistema de autopago"""
    return render(request, 'autopago_inicio.html')

def autopago_login(request):
    """Vista de login para autopago con documento"""
    tipo_cliente = request.GET.get('tipo', 'NATURAL')
    
    if request.method == 'POST':
        tipo_cliente = request.POST.get('tipo_cliente', 'NATURAL')
        documento = request.POST.get('documento', '').strip().upper()
        
        if not documento:
            messages.error(request, 'Por favor, ingrese su documento de identificación.')
            return render(request, 'autopago_login.html', {'tipo_cliente': tipo_cliente})
        
        try:
            # Buscar cliente según el tipo
            if tipo_cliente == 'NATURAL':
                # Buscar por cédula (cli_nat_ci)
                cliente_obj = cliente.objects.get(
                    cli_tipo_cliente='NATURAL',
                    cli_nat_ci=documento
                )
            else:
                # Buscar por RIF (cli_rif)
                cliente_obj = cliente.objects.get(
                    cli_tipo_cliente='JURIDICO',
                    cli_rif=documento
                )
            
            # Buscar usuario asociado al cliente
            try:
                usuario_obj = usuario.objects.filter(fk_cliente=cliente_obj).first()
                if not usuario_obj:
                    raise usuario.DoesNotExist
                
                # Autenticar automáticamente al usuario
                login(request, usuario_obj)
                
                # Guardar información de la sesión de autopago
                request.session['autopago_mode'] = True
                request.session['autopago_cliente_id'] = cliente_obj.cli_id
                request.session['autopago_tipo'] = tipo_cliente
                
                # Mensaje de bienvenida personalizado
                if tipo_cliente == 'NATURAL':
                    nombre = f"{cliente_obj.cli_nat_pnombre} {cliente_obj.cli_nat_papellido}"
                else:
                    nombre = cliente_obj.cli_jur_razon_social or cliente_obj.cli_jur_denom_comercial
                
                messages.success(request, f'¡Bienvenido(a) {nombre}! Puede comenzar a seleccionar productos.')
                
                # Redirigir a la tienda física
                return redirect('autopago_tienda')
                
            except usuario.DoesNotExist:
                messages.error(request, 
                    f'No se encontró un usuario asociado al cliente con documento {documento}. '
                    'Contacte al personal para activar su cuenta.'
                )
        
        except cliente.DoesNotExist:
            if tipo_cliente == 'NATURAL':
                messages.error(request, f'No se encontró un cliente natural con cédula {documento}.')
            else:
                messages.error(request, f'No se encontró un cliente jurídico con RIF {documento}.')
        
        except Exception as e:
            messages.error(request, f'Error al buscar cliente: {str(e)}')
    
    return render(request, 'autopago_login.html', {'tipo_cliente': tipo_cliente})

def autopago_tienda(request):
    """Vista de tienda para modo autopago"""
    # Verificar que el usuario esté en modo autopago
    if not request.session.get('autopago_mode', False):
        messages.warning(request, 'Debe iniciar sesión en el sistema de autopago.')
        return redirect('autopago_inicio')
    
    if not request.user.is_authenticated:
        messages.error(request, 'Sesión expirada. Inicie sesión nuevamente.')
        return redirect('autopago_inicio')
    
    # Obtener información del cliente
    cliente_id = request.session.get('autopago_cliente_id')
    tipo_cliente = request.session.get('autopago_tipo')
    
    try:
        cliente_obj = cliente.objects.get(cli_id=cliente_id)
        
        # Información personalizada para el template
        context = {
            'autopago_mode': True,
            'cliente_info': cliente_obj,
            'tipo_cliente': tipo_cliente,
        }
        
        # Usar la vista de tienda existente pero con contexto de autopago
        return store_view(request, tipo='fisica', extra_context=context)
        
    except cliente.DoesNotExist:
        messages.error(request, 'Error: Cliente no encontrado.')
        return redirect('autopago_inicio')

def autopago_logout(request):
    """Cerrar sesión del autopago"""
    # Limpiar variables de sesión de autopago
    request.session.pop('autopago_mode', None)
    request.session.pop('autopago_cliente_id', None)
    request.session.pop('autopago_tipo', None)
    
    # Limpiar carrito de autopago
    request.session.pop('cart_fisica', None)
    
    # Cerrar sesión del usuario
    logout(request)
    
    messages.success(request, 'Sesión de autopago cerrada correctamente.')
    return redirect('autopago_inicio')

def cart_view(request, tipo='fisica'):
    """Vista de carrito generalizada"""
    data = cart_data(request, tipo)
    return render(request, 'cart.html', {
        'items': data['items'],
        'order': data['order'],
        'cartItems': data['cartItems'],
        'tipo': tipo,
    })

# CHECKOUT
def checkout(request):
    """Vista de checkout básica"""
    data = cartData(request)
    return render(request, 'checkout.html', {
        'items': data['items'],
        'order': data['order'],
        'cartItems': data['cartItems'],
    })

def checkout_view(request, tipo='fisica'):
    """Vista de checkout generalizada"""
    data = cart_data(request, tipo)
    return render(request, 'checkout.html', {
        'items': data['items'],
        'order': data['order'],
        'cartItems': data['cartItems'],
        'tipo': tipo,
    })

# PROCESAR ÓRDENES
def validate_inventory_availability(cart, tipo='fisica'):
    """
    Validar disponibilidad de inventario para el carrito
    Args:
        cart: diccionario con product_id: cantidad
        tipo: 'fisica' o 'online'
    Returns:
        tuple: (es_valido, lista_errores, detalles_validos)
    """
    errores = []
    detalles_validos = []

    for product_id, cantidad in cart.items():
        try:
            producto = presentacion.objects.get(prese_id=int(product_id))
            
            if tipo == 'fisica':
                # Verificar inventario físico
                item = inventario.objects.filter(fk_presentacion=producto).first()
                if not item:
                    errores.append(f'Producto "{producto.prese_nombre}" no disponible en inventario físico')
                continue
                    
                if item.inv_cantidad < cantidad:
                    errores.append(
                        f'Inventario insuficiente para "{producto.prese_nombre}". '
                        f'Disponible: {item.inv_cantidad}, Solicitado: {cantidad}'
                    )
                    continue
                    
                detalles_validos.append({
                'producto': producto,
                'cantidad': cantidad,
                    'item': item,
                    'precio_unitario': item.inv_precio_unitario
                })
            else:
                # Verificar stock online
                item = pre_alm.objects.filter(fk_presentacion=producto).first()
                if not item:
                    errores.append(f'Producto "{producto.prese_nombre}" no disponible en tienda online')
                    continue
                    
                if item.pre_alm_cantidad < cantidad:
                    errores.append(
                        f'Stock insuficiente para "{producto.prese_nombre}". '
                        f'Disponible: {item.pre_alm_cantidad}, Solicitado: {cantidad}'
                    )
                    continue
                    
                detalles_validos.append({
                    'producto': producto,
                    'cantidad': cantidad,
                    'item': item,
                    'precio_unitario': item.pre_alm_precio
                })
                
        except presentacion.DoesNotExist:
            errores.append(f'Producto con ID {product_id} no encontrado')
            continue

    return len(errores) == 0, errores, detalles_validos

def processOrder(request):
    """Procesar orden básica (original) con validaciones de stock"""
    cart = request.session.get('cart', {})

    if not cart:
        return JsonResponse({'status': 'error', 'message': 'Carrito vacío'}, status=400)

    # Validar stock antes de procesar (ahora para tienda física)
    es_valido, errores, detalles = validate_inventory_availability(cart, tipo='fisica')
    
    if not es_valido:
        return JsonResponse({
            'status': 'error', 
            'message': 'Errores de inventario encontrados:', 
            'errores': errores
        }, status=400)

    if not detalles:
        return JsonResponse({'status': 'error', 'message': 'No hay productos válidos en el carrito'}, status=400)

    # Calcular total
    total_venta = sum(d['precio_unitario'] * d['cantidad'] for d in detalles)
    
    tienda_obj = tienda.objects.first()
    if total_venta <= 0:
        return JsonResponse({'status': 'error', 'message': 'Total de la venta inválido'}, status=400)
        
    # Verificar si el usuario tiene un cliente asociado
    if not request.user.fk_cliente:
        return JsonResponse({'status': 'error', 'message': 'Usuario debe tener un cliente asociado para ventas físicas'}, status=400)

    # Crear venta física (no online)
    venta_id = ejecutar_registro_venta_fisica(
        cliente_id=request.user.fk_cliente.cli_id,
        tienda_id=tienda_obj.tie_id,
        total=total_venta
    )

    venta = venta_fisica.objects.get(ven_fis_id=venta_id)
    
    # Crear detalles de venta física (no online)
    for item in detalles:
        detalle_venta_fisica.objects.create(
            fk_venta_fisica=venta,
            fk_inventario=item['item'],  # item contiene el objeto inventario
            det_ven_fis_cantidad=item['cantidad'],
            det_ven_fis_precio_unitario=item['precio_unitario']
        )

    # Guardar el ID de venta en la sesión para usar en el método de pago
    request.session['pending_venta_id'] = venta.ven_fis_id
    request.session['pending_total'] = float(total_venta)
    request.session['pending_tipo'] = 'fisica'
    # NO limpiar el carrito aquí - se limpiará después del pago exitoso

    return JsonResponse({
        'status': 'ok', 
        'message': 'Venta registrada', 
        'venta_id': venta.ven_fis_id,
        'redirect_to_payment': True
    })

def ejecutar_registro_venta_fisica(cliente_id, tienda_id, total):
            with connection.cursor() as cursor:
                cursor.execute("SELECT registrar_venta_fisica(%s, %s, %s);", [cliente_id, tienda_id, total])
                nueva_venta_id = cursor.fetchone()[0]
            return nueva_venta_id

@csrf_exempt
def process_order_view(request, tipo):
    """Procesar orden generalizada (física/online) - Ahora diferencia entre ambos tipos"""
    if request.method != 'POST':
        return JsonResponse({'status': 'error'}, status=400)

    data = json.loads(request.body)
    tipo = data.get('tipo', tipo)
    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})

    tienda_obj = tienda.objects.first()

    if tipo == 'fisica':
        # Lógica para venta física - USA SOLO TABLA INVENTARIO
        detalles, total_venta = [], 0
        errores_inventario = []
        
        for pid, cantidad in cart.items():
            try:
                producto = presentacion.objects.get(pk=int(pid))
                # Para venta física, usar SOLO tabla inventario (precio y cantidad)
                inventario_item = inventario.objects.filter(fk_presentacion=producto).first()
                
                if not inventario_item:
                    errores_inventario.append(f'Producto "{producto.prese_nombre}" no disponible en inventario físico')
                    continue
                    
                if inventario_item.inv_cantidad < cantidad:
                    errores_inventario.append(
                        f'Inventario insuficiente para "{producto.prese_nombre}". '
                        f'Disponible: {inventario_item.inv_cantidad}, Solicitado: {cantidad}'
                    )
                    continue
                
                detalles.append({
                    'producto': producto, 
                    'inventario': inventario_item,
                    'cantidad': cantidad
                })
                
                # Precio viene del inventario, NO de pre_alm
                subtotal = inventario_item.inv_precio_unitario * cantidad
                total_venta += subtotal
            except presentacion.DoesNotExist:
                errores_inventario.append(f'Producto con ID {pid} no encontrado')
                continue

        # Si hay errores de inventario, retornar todos los errores
        if errores_inventario:
            return JsonResponse({
                'status': 'error', 
                'message': 'Errores de inventario encontrados:', 
                'errores': errores_inventario
            }, status=400)

        if total_venta <= 0:
            return JsonResponse({'status': 'error', 'message': 'Venta inválida - no hay productos válidos en el carrito'}, status=400)

        # Verificar si el usuario tiene un cliente asociado
        if not request.user.fk_cliente:
            return JsonResponse({'status': 'error', 'message': 'Usuario debe tener un cliente asociado para ventas físicas'}, status=400)

        # Crear venta física
        venta_id = ejecutar_registro_venta_fisica(
            cliente_id=request.user.fk_cliente.cli_id,
            tienda_id=tienda_obj.tie_id,
            total=total_venta
        )

        venta = venta_fisica.objects.get(ven_fis_id=venta_id)
        
        # Crear detalles de venta física
        for d in detalles:
            detalle_venta_fisica.objects.create(
                fk_venta_fisica=venta,
                fk_inventario=d['inventario'],
                det_ven_fis_cantidad=d['cantidad'],
                det_ven_fis_precio_unitario=d['inventario'].inv_precio_unitario
            )

        # Guardar el ID de venta en la sesión para usar en el método de pago
        request.session['pending_venta_id'] = venta.ven_fis_id
        venta_id = venta.ven_fis_id
        
    else:
        # Lógica para venta online con validaciones de stock
        detalles, total_venta = [], 0
        errores_stock = []
        
        for pid, cantidad in cart.items():
            try:
                producto = presentacion.objects.get(pk=int(pid))
                prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
                
                if not prealm:
                    errores_stock.append(f'Producto "{producto.prese_nombre}" no disponible en tienda online')
                    continue
                
                if prealm.pre_alm_cantidad < cantidad:
                    errores_stock.append(
                        f'Stock insuficiente para "{producto.prese_nombre}". '
                        f'Disponible: {prealm.pre_alm_cantidad}, Solicitado: {cantidad}'
                    )
                    continue
                
                detalles.append({
                    'producto': producto, 
                    'prealm': prealm,
                    'cantidad': cantidad
                })
                
                subtotal = prealm.pre_alm_precio * cantidad
                total_venta += subtotal
            except presentacion.DoesNotExist:
                errores_stock.append(f'Producto con ID {pid} no encontrado')
                continue

        # Si hay errores de stock, retornar todos los errores
        if errores_stock:
            return JsonResponse({
                'status': 'error', 
                'message': 'Errores de stock encontrados:', 
                'errores': errores_stock
            }, status=400)

        if total_venta <= 0:
            return JsonResponse({'status': 'error', 'message': 'Venta inválida - no hay productos válidos en el carrito'}, status=400)

        # Crear venta online
        venta = venta_online.objects.create(
            ven_onl_fecha=timezone.now(),
            ven_onl_total=total_venta,
            fk_usuario=request.user,
            fk_tienda=tienda_obj
        )
        
        # Crear detalles de venta online
        for d in detalles:
            detalle_venta_online.objects.create(
                fk_venta_online=venta,
                fk_pre_alm=d['prealm'],
                det_ven_onl_cantidad=d['cantidad'],
                det_ven_onl_precio=d['prealm'].pre_alm_precio
            )

        # Guardar el ID de venta en la sesión para usar en el método de pago
        request.session['pending_venta_id'] = venta.ven_onl_id
        venta_id = venta.ven_onl_id

    request.session['pending_total'] = float(total_venta)
    request.session['pending_tipo'] = tipo  # Guardar el tipo para referencia
    # NO limpiar el carrito aquí - se limpiará después del pago exitoso

    return JsonResponse({
        'status': 'ok', 
        'message': 'Venta registrada', 
        'venta_id': venta_id,
        'redirect_to_payment': True
    })

# MÉTODOS DE PAGO
@login_required
def payment_method_view(request):
    """Vista para seleccionar y configurar el método de pago"""
    venta_id = request.session.get('pending_venta_id')
    total = request.session.get('pending_total')
    pending_tipo = request.session.get('pending_tipo', 'fisica')
    
    if not venta_id or not total:
        # Redirigir al checkout del tipo correcto
        return redirect('checkout_view', tipo=pending_tipo)
    
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
        pending_tipo = request.session.get('pending_tipo', 'fisica')
        
        if not venta_id or not total:
            return JsonResponse({'status': 'error', 'message': 'No hay venta pendiente'}, status=400)
        
        # Obtener la venta según el tipo
        venta_fisica_obj = None
        venta_online_obj = None
        
        if pending_tipo == 'fisica':
            try:
                venta_fisica_obj = venta_fisica.objects.get(ven_fis_id=venta_id)
            except venta_fisica.DoesNotExist:
                return JsonResponse({'status': 'error', 'message': 'Venta física no encontrada'}, status=404)
        else:
            try:
                venta_online_obj = venta_online.objects.get(ven_onl_id=venta_id)
            except venta_online.DoesNotExist:
                return JsonResponse({'status': 'error', 'message': 'Venta online no encontrada'}, status=404)
        
        tipo_pago = data.get('tipo_pago')
        moneda_id = data.get('moneda_id')
        
        if not moneda_id:
            return JsonResponse({'status': 'error', 'message': 'Debe seleccionar una moneda'}, status=400)
        
        if not tipo_pago:
            return JsonResponse({'status': 'error', 'message': 'Debe seleccionar un tipo de pago'}, status=400)
        
        # Validar datos del método de pago
        validation_errors = validate_payment_data(tipo_pago, data)
        if validation_errors:
            return JsonResponse({'status': 'error', 'message': '; '.join(validation_errors)}, status=400)
        
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
        
        try:
            if tipo_pago == 'efectivo':
                metodo_pago_data['efe_denominacion'] = int(data.get('denominacion'))
                
            elif tipo_pago == 'cheque':
                metodo_pago_data['che_num_cheque'] = int(data.get('num_cheque'))
                
            elif tipo_pago == 'tarjeta_debito':
                numero = data.get('numero', '').replace(' ', '')
                vencimiento = data.get('vencimiento')
                banco = data.get('banco', '').strip()
                
                metodo_pago_data.update({
                    'tar_deb_numero': int(numero),
                    'tar_deb_vencimiento': datetime.strptime(vencimiento, '%Y-%m-%d').date(),
                    'tar_deb_banco': banco
                })
                
            elif tipo_pago == 'tarjeta_credito':
                numero = data.get('numero', '').replace(' ', '')
                vencimiento = data.get('vencimiento')
                
                metodo_pago_data.update({
                    'tar_cre_numero': int(numero),
                    'tar_cre_vencimiento': datetime.strptime(vencimiento, '%Y-%m-%d').date()
                })
        except (ValueError, TypeError) as e:
            return JsonResponse({'status': 'error', 'message': f'Error en los datos del método de pago: {str(e)}'}, status=400)
        
        # Crear el método de pago
        metodo_pago_obj = metodo_pago.objects.create(**metodo_pago_data)
        
        # Crear el registro de pago con el monto convertido
        # El modelo pago puede referenciar tanto venta_fisica como venta_online
        pago_obj = pago.objects.create(
            pag_monto=monto_convertido,
            pag_fecha=timezone.now(),
            fk_metodo_pago=metodo_pago_obj,
            fk_venta_fisica=venta_fisica_obj,
            fk_venta_online=venta_online_obj,
            fk_moneda=moneda_obj
        )
        
        # Limpiar la sesión - incluir el carrito ahora que el pago fue exitoso
        cart_key = 'cart_fisica' if pending_tipo == 'fisica' else 'cart'
        
        request.session.pop('pending_venta_id', None)
        request.session.pop('pending_total', None)
        request.session.pop('pending_tipo', None)
        request.session[cart_key] = {}  # Limpiar el carrito SOLO después del pago exitoso
        
        return JsonResponse({
            'status': 'success',
            'message': 'Pago procesado exitosamente',
            'pago_id': pago_obj.pag_id,
            'monto_original': float(total_decimal),
            'monto_convertido': float(monto_convertido),
            'moneda': moneda_obj.mon_tipo,
            'tasa_cambio': float(ultimo_historico.his_valor_cambio),
            'redirect_url': f'/store/{pending_tipo}/'  # Redirigir de vuelta al tipo de tienda correcto
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

# AUTENTICACIÓN
def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user:
            login(request, user)
            # Redirigir al checkout si viene desde el carrito
            next_url = request.GET.get('next')
            if next_url:
                return redirect(next_url)
            return redirect('home')
        else:
            return render(request, 'login.html', {'error': 'Credenciales inválidas'})
    return render(request, 'login.html')

def logout_view(request):
    logout(request)
    return redirect('login')


def crear_usuario_view(request, tipo, id_entidad):
    if request.method == 'POST':
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')

        # ✅ Obtener nombres automáticamente según el tipo
        first_name = ''
        last_name = ''
        emp_car_id = None

        if tipo == 'cliente':
            entidad = cliente.objects.get(pk=id_entidad)
            first_name = entidad.cli_nat_pnombre or ''
            last_name = entidad.cli_nat_papellido or ''
        
        elif tipo == 'proveedor':
            entidad = proveedor.objects.get(pk=id_entidad)
            first_name = entidad.prov_nombre or ''
            last_name = ''  # Si aplica
        
        elif tipo == 'empleado':
            entidad = empleado.objects.get(pk=id_entidad)
            first_name = entidad.emp_pnombre or ''
            last_name = entidad.emp_papellido or ''
            
            empcar = emp_car.objects.filter(fk_empleado_id=id_entidad).order_by('-emp_car_fecha_inicio').first()
            emp_car_id = empcar.id if empcar else None  # usa .id o emp_car_id según tu modelo

        # ✅ Llamar a la función con todo incluido
        crear_usuario_sql(username, email, password, tipo, id_entidad, emp_car_id, first_name, last_name)

        return redirect('login')

    return render(request, 'registro.html', {
        'tipo': tipo,
        'id_entidad': id_entidad
    })

# Vista para registrar un cliente
def registrar_cliente_view(request):
    if request.method == 'POST':
        form = ClienteForm(request.POST)
        # Inicializar los querysets de municipio y parroquia si vienen datos
        if 'estado' in request.POST and request.POST['estado']:
            try:
                estado_id = request.POST['estado']
                municipios = lugar.objects.filter(fk_lugar_id=estado_id, lug_tipo='municipio')
                form.fields['municipio'].queryset = municipios
                
                if 'municipio' in request.POST and request.POST['municipio']:
                    municipio_id = request.POST['municipio']
                    parroquias = lugar.objects.filter(fk_lugar_id=municipio_id, lug_tipo='parroquia')
                    form.fields['parroquia'].queryset = parroquias
            except (ValueError, lugar.DoesNotExist):
                pass
        
        if form.is_valid():
            cliente_obj = form.save()
            return redirect('crear_usuario', tipo='cliente', id_entidad=cliente_obj.cli_id)
        else:
            print("Errores del formulario:", form.errors)
    else:
        form = ClienteForm()
    return render(request, 'registro_cliente.html', {'form': form})

# Vista para registrar un empleado
def registrar_empleado_view(request):
    if request.method == 'POST':
        form = EmpleadoForm(request.POST)
        
        # Inicializar los querysets de municipio y parroquia si vienen datos
        if 'estado' in request.POST and request.POST['estado']:
            try:
                estado_id = request.POST['estado']
                municipios = lugar.objects.filter(fk_lugar_id=estado_id, lug_tipo='municipio')
                form.fields['municipio'].queryset = municipios
                
                if 'municipio' in request.POST and request.POST['municipio']:
                    municipio_id = request.POST['municipio']
                    parroquias = lugar.objects.filter(fk_lugar_id=municipio_id, lug_tipo='parroquia')
                    form.fields['parroquia'].queryset = parroquias
            except (ValueError, lugar.DoesNotExist):
                pass
        
        if form.is_valid():
            empleado_obj = form.save()

            # Crear emp_car (relación empleado-cargo) con valores por defecto (ajustar según tus reglas)
            from .models import emp_car  # Importar aquí para evitar problemas de carga circular
            emp_car.objects.create(
                fk_empleado=empleado_obj,
                fk_cargo_id=1,  # Asignar ID de cargo por defecto (ajusta esto)
                fk_departamento=1,  # ID por defecto para departamento
                fk_tienda=1,  # ID por defecto para tienda
                emp_car_fecha_inicio=date.today()
            )

            return redirect('crear_usuario', tipo='empleado', id_entidad=empleado_obj.emp_id)
        else:
            print("Errores del formulario EmpleadoForm:", form.errors)
    else:
        form = EmpleadoForm()
    return render(request, 'registro_empleado.html', {'form': form})

# Vista para registrar un proveedor
def registrar_proveedor_view(request):
    if request.method == 'POST':
        form = ProveedorForm(request.POST)
        
        # Inicializar los querysets de municipio y parroquia si vienen datos
        if 'estado' in request.POST and request.POST['estado']:
            try:
                estado_id = request.POST['estado']
                municipios = lugar.objects.filter(fk_lugar_id=estado_id, lug_tipo='municipio')
                form.fields['municipio'].queryset = municipios
                
                if 'municipio' in request.POST and request.POST['municipio']:
                    municipio_id = request.POST['municipio']
                    parroquias = lugar.objects.filter(fk_lugar_id=municipio_id, lug_tipo='parroquia')
                    form.fields['parroquia'].queryset = parroquias
            except (ValueError, lugar.DoesNotExist):
                pass
        
        if form.is_valid():
            proveedor_obj = form.save()
            return redirect('crear_usuario', tipo='proveedor', id_entidad=proveedor_obj.pro_id)
        else:
            print("Errores del formulario ProveedorForm:", form.errors)
    else:
        form = ProveedorForm()
    return render(request, 'registro_proveedor.html', {'form': form})

def modificar_usuario_view(request, id_usuario):
    usuario = usuario.objects.get(pk=id_usuario)

    if request.method == 'POST':
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')  # puede estar vacío si no se desea cambiar
        first_name = request.POST.get('first_name')
        last_name = request.POST.get('last_name')

        modificar_usuario_sql(id_usuario, username, email, password, first_name, last_name)
        return redirect('perfil')  # o donde desees redirigir

    return render(request, 'modificar_usuario.html', {
        'usuario': usuario
    })


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

# VISTAS AJAX PARA SELECTOR JERÁRQUICO DE LUGAR
@csrf_exempt
def load_municipios(request):
    """Vista AJAX para cargar municipios según el estado seleccionado"""
    estado_id = request.GET.get('estado_id')
    municipios = lugar.objects.filter(
        fk_lugar_id=estado_id,
        lug_tipo='municipio'
    ).order_by('lug_nombre')
    
    municipios_data = [
        {'id': municipio.lug_id, 'nombre': municipio.lug_nombre}
        for municipio in municipios
    ]
    
    return JsonResponse({'municipios': municipios_data})

@csrf_exempt
def load_parroquias(request):
    """Vista AJAX para cargar parroquias según el municipio seleccionado"""
    municipio_id = request.GET.get('municipio_id')
    parroquias = lugar.objects.filter(
        fk_lugar_id=municipio_id,
        lug_tipo='parroquia'
    ).order_by('lug_nombre')
    
    parroquias_data = [
        {'id': parroquia.lug_id, 'nombre': parroquia.lug_nombre}
        for parroquia in parroquias
    ]
    
    return JsonResponse({'parroquias': parroquias_data})

def vista_factura(request):
    # Asegúrate de que tu archivo 'factura_reporte.html' esté en tu carpeta de templates
        return render(request, 'factura_reporte.html')

def generar_reporte_venta_api(request, venta_id):
    """
    API endpoint que obtiene los datos para un reporte de venta específico.
    """
    if request.method != 'GET':
        return JsonResponse({'error': 'Método no permitido'}, status=405)

    try:
        with connection.cursor() as cursor:
            print(f"Ejecutando consulta para venta_id: {venta_id}")
            cursor.execute("SELECT obtener_datos_reporte_venta(%s);", [venta_id])
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print(f"No se encontró resultado en la BD para venta_id: {venta_id}")
                return HttpResponseNotFound(f'No se encontraron datos para la venta con ID {venta_id}')

            # El resultado es un diccionario de Python
            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Procediendo a serializar.")
            # print(f"Datos: {report_data}") # Descomenta esta línea si necesitas ver el diccionario completo

            # LA CORRECCIÓN: Convertimos manualmente a JSON
            # Esto nos da más control y nos ayuda a aislar el error.
            json_output = json.dumps(report_data, cls=DjangoJSONEncoder)
            
            print("Serialización a JSON exitosa. Enviando respuesta.")
            
            # Devolvemos una HttpResponse con el tipo de contenido correcto.
            return HttpResponse(json_output, content_type='application/json')

    except Exception as e:
        # Este bloque capturará cualquier error durante el proceso
        print(f"¡ERROR! Ocurrió una excepción en la vista: {e}")
        return JsonResponse({'success': False, 'error': str(e)}, status=500)