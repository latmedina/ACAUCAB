from django.shortcuts import render, redirect
from django.http import JsonResponse
import json
import math
from django.utils import timezone
from django.contrib.auth.models import User, Group
from django.contrib import messages
from django.db import connection, transaction
from django.http import JsonResponse, HttpResponseNotFound
from django.http import JsonResponse, HttpResponse, HttpResponseNotFound
from django.core.serializers.json import DjangoJSONEncoder
import traceback
from .models import (
    presentacion, venta_online, detalle_venta_online, pre_alm, 
    metodo_pago, pago, moneda, historico_moneda, historico_precio_punto, tienda, 
    inventario, venta_fisica, detalle_venta_fisica, cliente, proveedor, empleado, emp_car, usuario, lugar
)
from django.db import connection
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from decimal import Decimal
from datetime import datetime, date
from .forms import ClienteForm, EmpleadoForm, ProveedorForm
from .utils import crear_usuario_sql, modificar_usuario_sql, eliminar_usuario_sql

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
        num_cheque = data.get('num_cheque', '').strip()
        if not num_cheque:
            errors.append('Número de cheque requerido')
        elif len(num_cheque) < 1:
            errors.append('El número de cheque debe tener al menos 1 carácter')
        elif len(num_cheque) > 50:
            errors.append('El número de cheque no puede exceder 50 caracteres')
                
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

    # Calcular total en USD
    total_venta_usd = sum(d['precio_unitario'] * d['cantidad'] for d in detalles)
    
    # Convertir total a bolívares
    total_venta_bolivares = convert_price_to_bolivars(Decimal(str(total_venta_usd)))
    
    tienda_obj = tienda.objects.first()
    if total_venta_usd <= 0:
        return JsonResponse({'status': 'error', 'message': 'Total de la venta inválido'}, status=400)
        
    # Verificar si el usuario tiene un cliente asociado
    if not request.user.fk_cliente:
        return JsonResponse({'status': 'error', 'message': 'Usuario debe tener un cliente asociado para ventas físicas'}, status=400)

    # Crear venta física (no online) con total en bolívares
    venta_id = ejecutar_registro_venta_fisica(
        cliente_id=request.user.fk_cliente.cli_id,
        tienda_id=tienda_obj.tie_id,
        total_bolivares=float(total_venta_bolivares)
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
    request.session['pending_total'] = float(total_venta_usd)  # Mantener en USD para compatibilidad con métodos de pago
    request.session['pending_tipo'] = 'fisica'
    # NO limpiar el carrito aquí - se limpiará después del pago exitoso

    return JsonResponse({
        'status': 'ok', 
        'message': 'Venta registrada', 
        'venta_id': venta.ven_fis_id,
        'redirect_to_payment': True
    })

def ejecutar_registro_venta_fisica(cliente_id, tienda_id, total_bolivares):
            with connection.cursor() as cursor:
                cursor.execute("SELECT registrar_venta_fisica(%s, %s, %s);", [cliente_id, tienda_id, total_bolivares])
                nueva_venta_id = cursor.fetchone()[0]
            return nueva_venta_id

@csrf_exempt
def process_order_view(request, tipo):
    """Validar orden y preparar datos para pago - NO crear venta aún"""
    if request.method != 'POST':
        return JsonResponse({'status': 'error'}, status=400)

    data = json.loads(request.body)
    tipo = data.get('tipo', tipo)
    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})

    if not cart:
        return JsonResponse({'status': 'error', 'message': 'Carrito vacío'}, status=400)

    if tipo == 'fisica':
        # Validar inventario físico pero NO crear venta aún
        detalles_validados, total_venta = [], 0
        errores_inventario = []
        
        for pid, cantidad in cart.items():
            try:
                producto = presentacion.objects.get(pk=int(pid))
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
                
                detalles_validados.append({
                    'producto_id': producto.prese_id,
                    'inventario_id': inventario_item.inv_id,
                    'cantidad': cantidad,
                    'precio_unitario': float(inventario_item.inv_precio_unitario)
                })
                
                subtotal = inventario_item.inv_precio_unitario * cantidad
                total_venta += subtotal
                
            except presentacion.DoesNotExist:
                errores_inventario.append(f'Producto con ID {pid} no encontrado')
                continue

        if errores_inventario:
            return JsonResponse({
                'status': 'error', 
                'message': 'Errores de inventario encontrados:', 
                'errores': errores_inventario
            }, status=400)

        # Verificar cliente asociado
        if not request.user.fk_cliente:
            return JsonResponse({'status': 'error', 'message': 'Usuario debe tener un cliente asociado para ventas físicas'}, status=400)
        
    else:
        # Validar stock online pero NO crear venta aún
        detalles_validados, total_venta = [], 0
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
                
                detalles_validados.append({
                    'producto_id': producto.prese_id,
                    'prealm_id': prealm.pre_alm_id,
                    'cantidad': cantidad,
                    'precio_unitario': float(prealm.pre_alm_precio)
                })
                
                subtotal = prealm.pre_alm_precio * cantidad
                total_venta += subtotal
                
            except presentacion.DoesNotExist:
                errores_stock.append(f'Producto con ID {pid} no encontrado')
                continue

        if errores_stock:
            return JsonResponse({
                'status': 'error', 
                'message': 'Errores de stock encontrados:', 
                'errores': errores_stock
            }, status=400)

    if total_venta <= 0:
        return JsonResponse({'status': 'error', 'message': 'Orden inválida - no hay productos válidos en el carrito'}, status=400)

    # Guardar datos validados en sesión para crear venta después del pago
    request.session['pending_order_data'] = {
        'tipo': tipo,
        'detalles': detalles_validados,
        'total': float(total_venta),
        'cart_key': cart_key
    }
    
    # NO crear venta ni limpiar carrito - se hará después del pago exitoso

    return JsonResponse({
        'status': 'ok', 
        'message': 'Orden validada correctamente', 
        'total': float(total_venta),
        'redirect_to_payment': True
    })

# MÉTODOS DE PAGO MÚLTIPLES
@login_required
def payment_method_view(request):
    """Vista para seleccionar y configurar múltiples métodos de pago"""
    order_data = request.session.get('pending_order_data')
    
    if not order_data:
        # No hay orden pendiente, redirigir al inicio
        return redirect('store_view', tipo='fisica')
    
    # Extraer datos de la orden
    total = order_data['total']
    pending_tipo = order_data['tipo']
    
    # Calcular total en bolívares para usar como moneda base
    total_usd = Decimal(str(total))
    total_bs = convert_price_to_bolivars(total_usd)
    
    # Obtener todas las monedas disponibles
    monedas_disponibles = []
    
    for moneda_obj in moneda.objects.all():
        # Obtener el último histórico de esta moneda
        ultimo_historico = historico_moneda.objects.filter(
            fk_moneda=moneda_obj
        ).order_by('-his_mon_fecha_hora').first()
        
        if ultimo_historico:                    
            monedas_disponibles.append({
                'id': moneda_obj.mon_id,
                'tipo': moneda_obj.mon_tipo,
                'valor_cambio': ultimo_historico.his_valor_cambio,
                'fecha_actualizacion': ultimo_historico.his_mon_fecha_hora
            })
    
    # Obtener puntos disponibles del usuario usando función SQL
    puntos_disponibles = 0
    valor_punto = 0
    
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT * FROM public.obtener_info_puntos_usuario(%s) 
                AS (cliente_id INTEGER, puntos_disponibles INTEGER, valor_punto INTEGER)
            """, [request.user.id])
            result = cursor.fetchone()
            if result:
                puntos_disponibles = result[1] or 0
                valor_punto = result[2] or 0
            
    except Exception as e:
        print(f"Error obteniendo puntos del usuario: {e}")
    
    # Inicializar sesión de pagos parciales si no existe
    if 'partial_payments' not in request.session:
        request.session['partial_payments'] = []
    
    context = {
        'total': total,
        'total_bs': float(total_bs),
        'dollar_rate': get_dollar_exchange_rate(),
        'tipo': pending_tipo,
        'monedas_disponibles': monedas_disponibles,
        'tipos_pago': ['efectivo', 'cheque', 'tarjeta_debito', 'tarjeta_credito', 'puntos'],
        'puntos_disponibles': puntos_disponibles,
        'valor_punto': valor_punto
    }
    
    return render(request, 'payment_method.html', context)

@csrf_exempt
@login_required
def get_applied_payments(request):
    """Vista para obtener los pagos parciales ya aplicados"""
    if request.method != 'GET':
        return JsonResponse({'status': 'error', 'message': 'Método no permitido'}, status=405)
    
    try:
        partial_payments = request.session.get('partial_payments', [])
        total_paid = sum(float(payment['monto_bolivares']) for payment in partial_payments)
        
        return JsonResponse({
            'status': 'success',
            'payments': partial_payments,
            'total_paid': total_paid
        })
        
    except Exception as e:
        print(f"Error obteniendo pagos aplicados: {e}")
        return JsonResponse({'status': 'error', 'message': 'Error interno del servidor'}, status=500)

@csrf_exempt
@login_required
def add_partial_payment(request):
    """Vista para agregar un pago parcial a la sesión"""
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Método no permitido'}, status=405)
    
    try:
        data = json.loads(request.body)
        print(f"=== ADD_PARTIAL_PAYMENT - Datos recibidos del frontend: {data}")
        
        # Validaciones básicas
        amount = float(data.get('payment_amount', 0))
        currency_id = data.get('payment_currency')
        payment_method = data.get('selected_payment_method')
        amount_bolivares = float(data.get('amount_bolivares', 0))
        currency_type = data.get('currency_type')
        
        print(f"Método de pago: {payment_method}")
        
        if amount <= 0:
            return JsonResponse({'status': 'error', 'message': 'El monto debe ser mayor a 0'}, status=400)
        
        if not currency_id or not payment_method:
            return JsonResponse({'status': 'error', 'message': 'Debe seleccionar moneda y método de pago'}, status=400)
        
        # Verificar que no exceda el total restante
        order_data = request.session.get('pending_order_data')
        if not order_data:
            return JsonResponse({'status': 'error', 'message': 'No hay orden pendiente'}, status=400)
        
        total_bs = convert_price_to_bolivars(Decimal(str(order_data['total'])))
        partial_payments = request.session.get('partial_payments', [])
        total_paid = sum(float(payment['monto_bolivares']) for payment in partial_payments)
        total_remaining = float(total_bs) - total_paid
        
        if amount_bolivares > total_remaining + 0.01:
            return JsonResponse({'status': 'error', 'message': 'El monto excede lo que resta por pagar'}, status=400)
        
        # Preparar datos del pago parcial
        payment_data = {
            'monto_original': amount,
            'monto_bolivares': amount_bolivares,
            'moneda_id': currency_id,
            'moneda_tipo': currency_type,
            'tipo_pago': payment_method,
            'timestamp': timezone.now().isoformat()
        }
        
        # Verificar si se está usando método guardado
        use_saved_method = data.get('use_saved_method', False)
        saved_method_id = data.get('saved_method_id')
        
        if use_saved_method and saved_method_id:
            # Usar método guardado - obtener los datos del método guardado
            try:
                metodo_guardado = metodo_pago.objects.get(
                    met_pag_id=saved_method_id,
                    fk_usuario=request.user
                )
                
                # Agregar datos del método guardado según su tipo
                if metodo_guardado.met_pag_tipo_pago == 'tarjeta_debito':
                    payment_data.update({
                        'numero': str(metodo_guardado.tar_deb_numero),
                        'vencimiento': metodo_guardado.tar_deb_vencimiento.isoformat(),
                        'banco': metodo_guardado.tar_deb_banco,
                        'saved_method_id': saved_method_id
                    })
                elif metodo_guardado.met_pag_tipo_pago == 'tarjeta_credito':
                    payment_data.update({
                        'numero': str(metodo_guardado.tar_cre_numero),
                        'vencimiento': metodo_guardado.tar_cre_vencimiento.isoformat(),
                        'saved_method_id': saved_method_id
                    })
                elif metodo_guardado.met_pag_tipo_pago == 'cheque':
                    payment_data.update({
                        'num_cheque': metodo_guardado.che_num_cheque,
                        'saved_method_id': saved_method_id
                    })
                
            except metodo_pago.DoesNotExist:
                return JsonResponse({'status': 'error', 'message': 'Método de pago guardado no encontrado'}, status=404)
        else:
            # Nuevo método - validar y agregar campos específicos según el método de pago
            validation_errors = validate_payment_data(payment_method, data)
            if validation_errors:
                return JsonResponse({'status': 'error', 'message': '; '.join(validation_errors)}, status=400)
            
            # Agregar campos específicos según el método de pago
            if payment_method == 'efectivo':
                payment_data['denominacion'] = data.get('denominacion')
                
            elif payment_method == 'cheque':
                payment_data['num_cheque'] = data.get('num_cheque', '').strip()
                
            elif payment_method == 'tarjeta_debito':
                # El frontend envía con nombres genéricos: numero, vencimiento, banco
                numero = (data.get('numero', '') or data.get('numero_debito', '')).replace(' ', '')
                vencimiento = data.get('vencimiento') or data.get('vencimiento_debito')
                banco = data.get('banco', '').strip()
                
                print(f"  TARJETA DÉBITO - numero: '{numero}', vencimiento: '{vencimiento}', banco: '{banco}'")
                print(f"  Datos originales: numero='{data.get('numero')}', vencimiento='{data.get('vencimiento')}', banco='{data.get('banco')}'")
                
                payment_data.update({
                    'numero': numero,
                    'vencimiento': vencimiento,
                    'banco': banco
                })
                
            elif payment_method == 'tarjeta_credito':
                # El frontend envía con nombres genéricos: numero, vencimiento
                numero = (data.get('numero', '') or data.get('numero_credito', '')).replace(' ', '')
                vencimiento = data.get('vencimiento') or data.get('vencimiento_credito')
                
                print(f"  TARJETA CRÉDITO - numero: '{numero}', vencimiento: '{vencimiento}'")
                print(f"  Datos originales: numero='{data.get('numero')}', vencimiento='{data.get('vencimiento')}'")
                
                payment_data.update({
                    'numero': numero,
                    'vencimiento': vencimiento
                })
                
            elif payment_method == 'puntos':
                # Para puntos, calcular cuántos puntos se necesitan
                valor_punto = 0
                try:
                    with connection.cursor() as cursor:
                        cursor.execute("""
                            SELECT * FROM public.obtener_info_puntos_usuario(%s) 
                            AS (cliente_id INTEGER, puntos_disponibles INTEGER, valor_punto INTEGER)
                        """, [request.user.id])
                        result = cursor.fetchone()
                        if result:
                            valor_punto = result[2] or 0
                except Exception as e:
                    return JsonResponse({'status': 'error', 'message': f'Error obteniendo valor del punto: {str(e)}'}, status=500)
                
                if valor_punto <= 0:
                    return JsonResponse({'status': 'error', 'message': 'No hay precio de puntos configurado'}, status=400)
                
                puntos_necesarios = int(math.ceil(amount_bolivares / valor_punto))
                payment_data['puntos_utilizados'] = puntos_necesarios
                payment_data['valor_punto'] = valor_punto
        
        # Agregar el pago a la lista de pagos parciales
        if 'partial_payments' not in request.session:
            request.session['partial_payments'] = []
        
        print(f"Datos finales a guardar en sesión: {payment_data}")
        request.session['partial_payments'].append(payment_data)
        request.session.modified = True
        print(f"Lista de pagos en sesión: {request.session['partial_payments']}")
        
        return JsonResponse({
            'status': 'success',
            'message': 'Pago parcial agregado correctamente',
            'payment_data': payment_data
        })
        
    except Exception as e:
        print(f"Error agregando pago parcial: {e}")
        return JsonResponse({'status': 'error', 'message': f'Error interno del servidor: {str(e)}'}, status=500)

@csrf_exempt
@login_required
def remove_partial_payment(request):
    """Vista para eliminar un pago parcial de la sesión"""
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Método no permitido'}, status=405)
    
    try:
        data = json.loads(request.body)
        payment_index = data.get('payment_index')
        
        if payment_index is None:
            return JsonResponse({'status': 'error', 'message': 'Índice de pago requerido'}, status=400)
        
        partial_payments = request.session.get('partial_payments', [])
        
        if 0 <= payment_index < len(partial_payments):
            removed_payment = partial_payments.pop(payment_index)
            request.session['partial_payments'] = partial_payments
            request.session.modified = True
            
            return JsonResponse({
                'status': 'success',
                'message': 'Pago eliminado correctamente',
                'removed_payment': removed_payment
            })
        else:
            return JsonResponse({'status': 'error', 'message': 'Índice de pago inválido'}, status=400)
        
    except Exception as e:
        print(f"Error eliminando pago parcial: {e}")
        return JsonResponse({'status': 'error', 'message': 'Error interno del servidor'}, status=500)

@csrf_exempt
@login_required
def finalize_multiple_payment_purchase(request):
    """Vista para finalizar la compra con múltiples métodos de pago"""
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Método no permitido'}, status=405)
    
    try:
        print("=== INICIANDO FINALIZACIÓN DE COMPRA MÚLTIPLE ===")
        order_data = request.session.get('pending_order_data')
        partial_payments = request.session.get('partial_payments', [])
        
        print(f"Order data: {order_data}")
        print(f"Partial payments: {partial_payments}")
        
        if not order_data:
            print("ERROR: No hay orden pendiente")
            return JsonResponse({'status': 'error', 'message': 'No hay orden pendiente'}, status=400)
        
        if not partial_payments:
            print("ERROR: No hay pagos aplicados")
            return JsonResponse({'status': 'error', 'message': 'No hay pagos aplicados'}, status=400)
        
        # Verificar que el total esté completamente cubierto
        total_bs = convert_price_to_bolivars(Decimal(str(order_data['total'])))
        total_paid = sum(float(payment['monto_bolivares']) for payment in partial_payments)
        
        if total_paid < float(total_bs) - 0.01:
            return JsonResponse({'status': 'error', 'message': f'Faltan {float(total_bs) - total_paid:.2f} Bs por pagar'}, status=400)
        
        with transaction.atomic():
            print("Iniciando transacción...")
            
            # CREAR LA VENTA
            print("Creando venta...")
            venta_fisica_obj, venta_online_obj = create_sale_from_order_data(order_data, request.user)
            print(f"Venta creada - Física: {venta_fisica_obj}, Online: {venta_online_obj}")
            
            # CREAR CADA MÉTODO DE PAGO Y SU PAGO CORRESPONDIENTE
            created_payments = []
            
            for i, payment_data in enumerate(partial_payments):
                print(f"\n--- Procesando pago {i+1}/{len(partial_payments)} ---")
                print(f"Datos del pago: {payment_data}")
                
                # Crear método de pago usando la función existente
                print("Creando método de pago...")
                metodo_pago_obj = create_payment_method_from_partial_data(request.user, payment_data)
                
                if isinstance(metodo_pago_obj, JsonResponse):
                    print(f"ERROR: Fallo al crear método de pago para {payment_data['tipo_pago']}")
                    raise Exception(f'Error creando método de pago: {payment_data["tipo_pago"]}')
                
                print(f"Método de pago creado con ID: {metodo_pago_obj.met_pag_id}")
                
                # Preparar IDs para el registro de pago
                venta_fisica_id = venta_fisica_obj.ven_fis_id if venta_fisica_obj else None
                venta_online_id = venta_online_obj.ven_onl_id if venta_online_obj else None
                
                # Obtener moneda
                try:
                    moneda_obj = moneda.objects.get(mon_id=payment_data['moneda_id'])
                    print(f"Moneda encontrada: {moneda_obj.mon_tipo} (ID: {moneda_obj.mon_id})")
                except moneda.DoesNotExist:
                    print(f"ERROR: Moneda no encontrada con ID: {payment_data['moneda_id']}")
                    raise Exception(f'Moneda no encontrada: {payment_data["moneda_id"]}')
                
                # Registrar el pago usando la función SQL
                if payment_data['tipo_pago'] == 'puntos':
                    print("Procesando pago con puntos...")
                    # Pago con puntos - usar función especial
                    with connection.cursor() as cursor:
                        cursor.execute("""
                            SELECT * FROM public.procesar_pago_puntos(%s, %s, %s, %s)
                            AS (pago_id INTEGER, metodo_pago_id INTEGER, puntos_utilizados INTEGER, puntos_restantes INTEGER, monto_pago DECIMAL)
                        """, [request.user.id, payment_data['puntos_utilizados'], venta_fisica_id, venta_online_id])
                        
                        resultado = cursor.fetchone()
                        if not resultado:
                            print("ERROR: No se pudo procesar pago con puntos")
                            raise Exception('Error procesando pago con puntos')
                        
                        pago_id = resultado[0]
                        print(f"Pago con puntos creado con ID: {pago_id}")
                else:
                    print(f"Procesando pago normal. Monto: {payment_data['monto_original']}")
                    # Pago normal
                    with connection.cursor() as cursor:
                        cursor.execute("""
                            SELECT public.registrar_pago(%s, %s, %s, %s, %s)
                        """, [
                            float(payment_data['monto_original']), 
                            metodo_pago_obj.met_pag_id, 
                            venta_fisica_id, 
                            venta_online_id, 
                            moneda_obj.mon_id
                        ])
                        
                        result = cursor.fetchone()
                        if not result or not result[0]:
                            print("ERROR: No se pudo registrar el pago")
                            raise Exception('Error registrando pago')
                        
                        pago_id = result[0]
                        print(f"Pago normal creado con ID: {pago_id}")
                
                created_payments.append({
                    'pago_id': pago_id,
                    'metodo_pago_id': metodo_pago_obj.met_pag_id,
                    'monto_original': payment_data['monto_original'],
                    'monto_bolivares': payment_data['monto_bolivares'],
                    'moneda': payment_data['moneda_tipo'],
                    'tipo_pago': payment_data['tipo_pago']
                })
                print(f"Pago {i+1} procesado exitosamente")
            
            print(f"Todos los pagos procesados. Total: {len(created_payments)}")
        
        # Limpiar la sesión
        cart_key = order_data['cart_key']
        request.session.pop('pending_order_data', None)
        request.session.pop('partial_payments', None)
        request.session[cart_key] = {}  # Limpiar el carrito
        
        return JsonResponse({
            'status': 'success',
            'message': 'Compra finalizada exitosamente',
            'venta_id': venta_fisica_obj.ven_fis_id if venta_fisica_obj else venta_online_obj.ven_onl_id,
            'total_pagos': len(created_payments),
            'pagos_creados': created_payments,
            'redirect_url': f'/store/{order_data["tipo"]}/'
        })
        
    except Exception as e:
        print(f"Error finalizando compra múltiple: {e}")
        return JsonResponse({'status': 'error', 'message': f'Error finalizando compra: {str(e)}'}, status=500)

def create_payment_method_from_partial_data(user, payment_data):
    """Función para crear un método de pago desde los datos de un pago parcial"""
    try:
        print(f"create_payment_method_from_partial_data - Datos recibidos: {payment_data}")
        tipo_pago = payment_data['tipo_pago']
        print(f"Tipo de pago: {tipo_pago}")
        
        # Si hay saved_method_id, usar el método guardado existente
        if 'saved_method_id' in payment_data:
            print(f"Usando método guardado con ID: {payment_data['saved_method_id']}")
            try:
                metodo_guardado = metodo_pago.objects.get(
                    met_pag_id=payment_data['saved_method_id'],
                    fk_usuario=user
                )
                print(f"Método guardado encontrado: {metodo_guardado.met_pag_id}")
                # Retornar un objeto mock con el ID del método guardado
                class MockMetodoPago:
                    def __init__(self, met_pag_id):
                        self.met_pag_id = met_pag_id
                        
                return MockMetodoPago(metodo_guardado.met_pag_id)
                
            except metodo_pago.DoesNotExist:
                print(f"ERROR: Método guardado no encontrado: {payment_data['saved_method_id']}")
                return JsonResponse({'status': 'error', 'message': 'Método de pago guardado no encontrado'}, status=404)
        
        # Si no hay método guardado, crear uno nuevo
        print("Creando nuevo método de pago...")
        # Preparar parámetros para la función SQL
        usuario_id = user.id
        tar_deb_numero = None
        tar_deb_vencimiento = None
        tar_deb_banco = None
        tar_cre_numero = None
        tar_cre_vencimiento = None
        efe_denominacion = None
        che_num_cheque = None
        his_pre_pun_id = None
        
        if tipo_pago == 'efectivo':
            print(f"Procesando efectivo - denominación: {payment_data.get('denominacion')}")
            efe_denominacion = int(payment_data.get('denominacion'))
            
        elif tipo_pago == 'cheque':
            print(f"Procesando cheque - número: {payment_data.get('num_cheque')}")
            che_num_cheque = payment_data.get('num_cheque', '').strip()
            
        elif tipo_pago == 'tarjeta_debito':
            # Intentar obtener datos con ambos formatos (genérico y específico)
            numero = (payment_data.get('numero', '') or payment_data.get('numero_debito', '')).replace(' ', '')
            vencimiento = payment_data.get('vencimiento') or payment_data.get('vencimiento_debito')
            banco = (payment_data.get('banco', '') or payment_data.get('banco_debito', '')).strip()
            
            print(f"Procesando tarjeta débito - número: {numero}, vencimiento: {vencimiento}, banco: {banco}")
            print(f"Datos originales recibidos: numero='{payment_data.get('numero')}', numero_debito='{payment_data.get('numero_debito')}', vencimiento='{payment_data.get('vencimiento')}', vencimiento_debito='{payment_data.get('vencimiento_debito')}'")
            
            if not numero or not vencimiento or not banco:
                print(f"ERROR: Faltan datos para tarjeta de débito")
                print(f"  - numero: '{numero}'")
                print(f"  - vencimiento: '{vencimiento}'")
                print(f"  - banco: '{banco}'")
                print(f"  - datos completos: {payment_data}")
                return JsonResponse({'status': 'error', 'message': 'Faltan datos requeridos para tarjeta de débito'}, status=400)
            
            tar_deb_numero = int(numero)
            tar_deb_vencimiento = datetime.strptime(vencimiento, '%Y-%m-%d').date()
            tar_deb_banco = banco
            
        elif tipo_pago == 'tarjeta_credito':
            # Intentar obtener datos con ambos formatos (genérico y específico)
            numero = (payment_data.get('numero', '') or payment_data.get('numero_credito', '')).replace(' ', '')
            vencimiento = payment_data.get('vencimiento') or payment_data.get('vencimiento_credito')
            
            print(f"Procesando tarjeta crédito - número: {numero}, vencimiento: {vencimiento}")
            print(f"Datos originales recibidos: numero='{payment_data.get('numero')}', numero_credito='{payment_data.get('numero_credito')}', vencimiento='{payment_data.get('vencimiento')}', vencimiento_credito='{payment_data.get('vencimiento_credito')}'")
            
            if not numero or not vencimiento:
                print(f"ERROR: Faltan datos para tarjeta de crédito")
                print(f"  - numero: '{numero}'")
                print(f"  - vencimiento: '{vencimiento}'")
                print(f"  - datos completos: {payment_data}")
                return JsonResponse({'status': 'error', 'message': 'Faltan datos requeridos para tarjeta de crédito'}, status=400)
            
            tar_cre_numero = int(numero)
            tar_cre_vencimiento = datetime.strptime(vencimiento, '%Y-%m-%d').date()
        
        # Llamar a la función SQL para registrar el método de pago
        print(f"Llamando función SQL con parámetros:")
        print(f"  - usuario_id: {usuario_id}")
        print(f"  - tipo_pago: {tipo_pago}")
        print(f"  - tar_deb_numero: {tar_deb_numero}")
        print(f"  - tar_deb_vencimiento: {tar_deb_vencimiento}")
        print(f"  - tar_deb_banco: {tar_deb_banco}")
        print(f"  - tar_cre_numero: {tar_cre_numero}")
        print(f"  - tar_cre_vencimiento: {tar_cre_vencimiento}")
        print(f"  - efe_denominacion: {efe_denominacion}")
        print(f"  - che_num_cheque: {che_num_cheque}")
        print(f"  - his_pre_pun_id: {his_pre_pun_id}")
        
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT public.registrar_metodo_pago(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, [
                usuario_id, tipo_pago, tar_deb_numero, tar_deb_vencimiento, tar_deb_banco,
                tar_cre_numero, tar_cre_vencimiento, efe_denominacion, che_num_cheque, his_pre_pun_id
            ])
            
            result = cursor.fetchone()
            print(f"Resultado de la función SQL: {result}")
            
            if result and result[0]:
                metodo_pago_id = result[0]
                print(f"Método de pago creado exitosamente con ID: {metodo_pago_id}")
                # Retornar un objeto mock para compatibilidad con el código existente
                class MockMetodoPago:
                    def __init__(self, met_pag_id):
                        self.met_pag_id = met_pag_id
                        
                return MockMetodoPago(metodo_pago_id)
            else:
                print("ERROR: La función SQL no retornó un ID válido")
                return JsonResponse({'status': 'error', 'message': 'Error al crear el método de pago'}, status=500)
            
    except (ValueError, TypeError) as e:
        print(f"ERROR ValueError/TypeError: {e}")
        return JsonResponse({'status': 'error', 'message': f'Error en los datos del método de pago: {str(e)}'}, status=400)
    except Exception as e:
        print(f"ERROR Exception: {e}")
        return JsonResponse({'status': 'error', 'message': f'Error al registrar método de pago: {str(e)}'}, status=500)

# FUNCIÓN ORIGINAL DE MÉTODOS DE PAGO (MANTENIDA PARA COMPATIBILIDAD)
@login_required
def payment_method_view_original(request):
    """Vista original para un solo método de pago (mantenida para compatibilidad)"""
    order_data = request.session.get('pending_order_data')
    
    if not order_data:
        # No hay orden pendiente, redirigir al inicio
        return redirect('store_view', tipo='fisica')
    
    # Extraer datos de la orden
    total = order_data['total']
    pending_tipo = order_data['tipo']
    
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
    
    # Obtener puntos disponibles del usuario usando función SQL
    puntos_disponibles = 0
    valor_punto = 0
    
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT * FROM public.obtener_info_puntos_usuario(%s) 
                AS (cliente_id INTEGER, puntos_disponibles INTEGER, valor_punto INTEGER)
            """, [request.user.id])
            result = cursor.fetchone()
            if result:
                # result = (cliente_id, puntos_disponibles, valor_punto)
                puntos_disponibles = result[1] or 0
                valor_punto = result[2] or 0
            
    except Exception as e:
        print(f"Error obteniendo puntos del usuario: {e}")
    
    context = {
        'total': total,
        'tipo': pending_tipo,
        'monedas_disponibles': monedas_disponibles,
        'tipos_pago': ['efectivo', 'cheque', 'tarjeta_debito', 'tarjeta_credito', 'puntos'],
        'puntos_disponibles': puntos_disponibles,
        'valor_punto': valor_punto
    }
    
    return render(request, 'payment_method_original.html', context)

@csrf_exempt
@login_required
def get_saved_payment_methods(request):
    """Vista para obtener los métodos de pago guardados del usuario (función original)"""
    if request.method != 'GET':
        return JsonResponse({'status': 'error', 'message': 'Método no permitido'}, status=405)
    
    try:
        # Obtener métodos de pago del usuario (excluyendo cheque, efectivo y puntos)
        metodos_guardados = metodo_pago.objects.filter(
            fk_usuario=request.user
        ).exclude(
            met_pag_tipo_pago__in=['efectivo', 'puntos', 'cheque']
        ).order_by('-met_pag_id')
        
        # Organizar por tipo de método
        methods_by_type = {
            'tarjeta_debito': [],
            'tarjeta_credito': []
        }
        
        for metodo in metodos_guardados:
            method_data = {
                'id': metodo.met_pag_id,
                'tipo_pago': metodo.met_pag_tipo_pago
            }
                
            if metodo.met_pag_tipo_pago == 'tarjeta_debito' and metodo.tar_deb_numero:
                method_data.update({
                    'tar_deb_numero': metodo.tar_deb_numero,
                    'tar_deb_vencimiento': metodo.tar_deb_vencimiento.isoformat() if metodo.tar_deb_vencimiento else None,
                    'tar_deb_banco': metodo.tar_deb_banco
                })
                methods_by_type['tarjeta_debito'].append(method_data)
                
            elif metodo.met_pag_tipo_pago == 'tarjeta_credito' and metodo.tar_cre_numero:
                method_data.update({
                    'tar_cre_numero': metodo.tar_cre_numero,
                    'tar_cre_vencimiento': metodo.tar_cre_vencimiento.isoformat() if metodo.tar_cre_vencimiento else None
                })
                methods_by_type['tarjeta_credito'].append(method_data)
        
        return JsonResponse({
            'status': 'success',
            'methods': methods_by_type
        })
        
    except Exception as e:
        print(f"Error obteniendo métodos guardados: {e}")
        return JsonResponse({'status': 'error', 'message': 'Error interno del servidor'}, status=500)

@csrf_exempt
@login_required
def process_payment_method_original(request):
    """Vista original para procesar un solo método de pago"""
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Método no permitido'}, status=405)
    
    try:
        data = json.loads(request.body)
        order_data = request.session.get('pending_order_data')
        
        if not order_data:
            return JsonResponse({'status': 'error', 'message': 'No hay orden pendiente'}, status=400)
        
        # Extraer datos de la orden
        total = order_data['total']
        pending_tipo = order_data['tipo']
        detalles = order_data['detalles']
        cart_key = order_data['cart_key']
        
        tipo_pago = data.get('tipo_pago')
        moneda_id = data.get('moneda_id')
        
        if not tipo_pago:
            return JsonResponse({'status': 'error', 'message': 'Debe seleccionar un tipo de pago'}, status=400)
        
        # Manejar pago con puntos
        if tipo_pago == 'puntos':
            return process_points_payment(request, data, order_data, total, pending_tipo)
        
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
        
        # Determinar si usar método guardado o crear nuevo
        use_saved_method = data.get('use_saved_method', False)
        metodo_pago_obj = None
        
        if use_saved_method and data.get('saved_method_id'):
            # Usar método guardado
            try:
                metodo_pago_obj = metodo_pago.objects.get(
                    met_pag_id=data.get('saved_method_id'),
                    fk_usuario=request.user
                )
            except metodo_pago.DoesNotExist:
                return JsonResponse({'status': 'error', 'message': 'Método de pago guardado no encontrado'}, status=404)
        else:
            # Crear nuevo método de pago
            metodo_pago_obj = create_new_payment_method(request.user, tipo_pago, data)
            if isinstance(metodo_pago_obj, JsonResponse):
                return metodo_pago_obj  # Error en la creación
        
        # CREAR LA VENTA SOLO AQUÍ - después de todas las validaciones
        venta_fisica_obj, venta_online_obj = create_sale_from_order_data(order_data, request.user)
        
        # Preparar IDs para el registro de pago
        venta_fisica_id = venta_fisica_obj.ven_fis_id if venta_fisica_obj else None
        venta_online_id = venta_online_obj.ven_onl_id if venta_online_obj else None
        
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT public.registrar_pago(%s, %s, %s, %s, %s)
            """, [
                float(monto_convertido), metodo_pago_obj.met_pag_id, 
                venta_fisica_id, venta_online_id, moneda_obj.mon_id
            ])
            
            result = cursor.fetchone()
            if not result or not result[0]:
                return JsonResponse({'status': 'error', 'message': 'Error al registrar el pago'}, status=500)
            
            pago_id = result[0]
            
            # Crear objeto mock para compatibilidad
            class MockPago:
                def __init__(self, pag_id):
                    self.pag_id = pag_id
                    
            pago_obj = MockPago(pago_id)
        
        # Limpiar la sesión - incluir el carrito ahora que el pago fue exitoso
        request.session.pop('pending_order_data', None)
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

def process_points_payment(request, data, order_data, total, pending_tipo):
    """Función para procesar pagos con puntos usando función SQL (función original)"""
    try:
        # Calcular puntos necesarios (convertir total USD a bolívares y luego a puntos)
        total_bs = convert_price_to_bolivars(Decimal(str(total)))
        
        # Obtener el valor actual del punto para calcular puntos necesarios
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT * FROM public.obtener_info_puntos_usuario(%s) 
                AS (cliente_id INTEGER, puntos_disponibles INTEGER, valor_punto INTEGER)
            """, [request.user.id])
            result = cursor.fetchone()
            if not result:
                return JsonResponse({'status': 'error', 'message': 'Cliente no encontrado'}, status=404)
            
            puntos_disponibles = result[1] or 0
            valor_punto = result[2] or 0
            
            if puntos_disponibles == 0:
                return JsonResponse({'status': 'error', 'message': 'No tienes puntos disponibles'}, status=400)
            
            if valor_punto == 0:
                return JsonResponse({'status': 'error', 'message': 'No hay precio de puntos configurado'}, status=400)
            
            puntos_necesarios = int(math.ceil(float(total_bs) / valor_punto))
            
            if puntos_necesarios > puntos_disponibles:
                return JsonResponse({
                    'status': 'error', 
                    'message': f'Puntos insuficientes. Necesitas {puntos_necesarios} puntos, pero tienes {puntos_disponibles}'
                }, status=400)
            
            # CREAR LA VENTA SOLO AQUÍ - después de todas las validaciones
            venta_fisica_obj, venta_online_obj = create_sale_from_order_data(order_data, request.user)
            
            # Procesar el pago con puntos usando la función SQL
            venta_fisica_id = venta_fisica_obj.ven_fis_id if venta_fisica_obj else None
            venta_online_id = venta_online_obj.ven_onl_id if venta_online_obj else None
            
            cursor.execute("""
                SELECT * FROM public.procesar_pago_puntos(%s, %s, %s, %s)
                AS (pago_id INTEGER, metodo_pago_id INTEGER, puntos_utilizados INTEGER, puntos_restantes INTEGER, monto_pago DECIMAL)
            """, [request.user.id, puntos_necesarios, venta_fisica_id, venta_online_id])
            
            resultado = cursor.fetchone()
            if not resultado:
                return JsonResponse({'status': 'error', 'message': 'Error procesando el pago con puntos'}, status=500)
            
            # resultado = (pago_id, metodo_pago_id, puntos_utilizados, puntos_restantes, monto_pago)
            pago_id = resultado[0]
            puntos_utilizados = resultado[2]
            puntos_restantes = resultado[3]
        
        # Limpiar la sesión
        cart_key = order_data['cart_key']
        
        request.session.pop('pending_order_data', None)
        request.session[cart_key] = {}
        
        return JsonResponse({
            'status': 'success',
            'message': 'Pago con puntos procesado exitosamente',
            'pago_id': pago_id,
            'puntos_utilizados': puntos_utilizados,
            'puntos_restantes': puntos_restantes,
            'redirect_url': f'/store/{pending_tipo}/'
        })
        
    except Exception as e:
        print(f"Error procesando pago con puntos: {e}")
        return JsonResponse({'status': 'error', 'message': f'Error procesando pago con puntos: {str(e)}'}, status=500)

def create_sale_from_order_data(order_data, user):
    """Crear venta y detalles basándose en los datos validados de la orden"""
    tipo = order_data['tipo']
    detalles = order_data['detalles']
    total_usd = order_data['total']
    
    # Convertir total de USD a bolívares
    total_bolivares = convert_price_to_bolivars(Decimal(str(total_usd)))
    
    tienda_obj = tienda.objects.first()
    venta_fisica_obj = None
    venta_online_obj = None
    
    try:
        if tipo == 'fisica':
            # Crear venta física con total en bolívares
            venta_id = ejecutar_registro_venta_fisica(
                cliente_id=user.fk_cliente.cli_id,
                tienda_id=tienda_obj.tie_id,
                total_bolivares=float(total_bolivares)
            )
            venta_fisica_obj = venta_fisica.objects.get(ven_fis_id=venta_id)
            
            # Crear detalles de venta física
            for detalle in detalles:
                inventario_obj = inventario.objects.get(inv_id=detalle['inventario_id'])
                detalle_venta_fisica.objects.create(
                    fk_venta_fisica=venta_fisica_obj,
                    fk_inventario=inventario_obj,
                    det_ven_fis_cantidad=detalle['cantidad'],
                    det_ven_fis_precio_unitario=detalle['precio_unitario']
                )
        else:
            # Crear venta online con total en bolívares
            venta_online_obj = venta_online.objects.create(
                ven_onl_fecha=timezone.now(),
                ven_onl_total=float(total_bolivares),
                fk_usuario=user,
                fk_tienda=tienda_obj
            )
            
            # Crear detalles de venta online
            for detalle in detalles:
                prealm_obj = pre_alm.objects.get(pre_alm_id=detalle['prealm_id'])
                detalle_venta_online.objects.create(
                    fk_venta_online=venta_online_obj,
                    fk_pre_alm=prealm_obj,
                    det_ven_onl_cantidad=detalle['cantidad'],
                    det_ven_onl_precio=detalle['precio_unitario']
                )
        
        return venta_fisica_obj, venta_online_obj
        
    except Exception as e:
        raise Exception(f'Error creando venta: {str(e)}')

def create_new_payment_method(user, tipo_pago, data):
    """Función para crear un nuevo método de pago usando función SQL"""
    try:
        # Validar datos del método de pago
        validation_errors = validate_payment_data(tipo_pago, data)
        if validation_errors:
            return JsonResponse({'status': 'error', 'message': '; '.join(validation_errors)}, status=400)
        
        # Preparar parámetros para la función SQL
        usuario_id = user.id
        tar_deb_numero = None
        tar_deb_vencimiento = None
        tar_deb_banco = None
        tar_cre_numero = None
        tar_cre_vencimiento = None
        efe_denominacion = None
        che_num_cheque = None
        his_pre_pun_id = None
        
        if tipo_pago == 'efectivo':
            efe_denominacion = int(data.get('denominacion'))
            
        elif tipo_pago == 'cheque':
            che_num_cheque = data.get('num_cheque', '').strip()
            
        elif tipo_pago == 'tarjeta_debito':
            numero = data.get('numero', '').replace(' ', '')
            vencimiento = data.get('vencimiento')
            banco = data.get('banco', '').strip()
            
            tar_deb_numero = int(numero)
            tar_deb_vencimiento = datetime.strptime(vencimiento, '%Y-%m-%d').date()
            tar_deb_banco = banco
            
        elif tipo_pago == 'tarjeta_credito':
            numero = data.get('numero', '').replace(' ', '')
            vencimiento = data.get('vencimiento')
            
            tar_cre_numero = int(numero)
            tar_cre_vencimiento = datetime.strptime(vencimiento, '%Y-%m-%d').date()
        
        # Llamar a la función SQL para registrar el método de pago
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT public.registrar_metodo_pago(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, [
                usuario_id, tipo_pago, tar_deb_numero, tar_deb_vencimiento, tar_deb_banco,
                tar_cre_numero, tar_cre_vencimiento, efe_denominacion, che_num_cheque, his_pre_pun_id
            ])
            
            result = cursor.fetchone()
            if result and result[0]:
                metodo_pago_id = result[0]
                # Retornar un objeto mock para compatibilidad con el código existente
                class MockMetodoPago:
                    def __init__(self, met_pag_id):
                        self.met_pag_id = met_pag_id
                        
                return MockMetodoPago(metodo_pago_id)
            else:
                return JsonResponse({'status': 'error', 'message': 'Error al crear el método de pago'}, status=500)
            
    except (ValueError, TypeError) as e:
        return JsonResponse({'status': 'error', 'message': f'Error en los datos del método de pago: {str(e)}'}, status=400)
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': f'Error al registrar método de pago: {str(e)}'}, status=500)

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
    user_obj = usuario.objects.get(pk=id_usuario)

    if request.method == 'POST':
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')  # puede estar vacío si no se desea cambiar
        first_name = request.POST.get('first_name')
        last_name = request.POST.get('last_name')

        modificar_usuario_sql(id_usuario, username, email, password, first_name, last_name)
        messages.success(request, 'Los datos del usuario han sido actualizados correctamente.')
        return redirect('modificar_usuario', id_usuario=id_usuario)
    
    # Limpiar mensajes persistentes de login u otras vistas
    storage = messages.get_messages(request)
    for _ in storage:
        pass  # Esto limpia todos los mensajes pendientes

    return render(request, 'modificar_usuario.html', {
        'usuario': user_obj
    })

from django.contrib.auth import logout
from django.shortcuts import redirect

@login_required
def eliminar_usuario_view(request, id_usuario):
    print(f"Vista eliminar_usuario llamada. Método: {request.method}")
    if request.method == 'POST':
        print(f"Eliminando usuario con ID {id_usuario}")
        eliminar_usuario_sql(id_usuario)

        # Si el usuario que se eliminó es el que está logueado:
        if request.user.id == id_usuario:
            logout(request)
            return redirect('login')  # Te lleva al login

        return redirect('store')  # O donde prefieras si eliminás a otro usuario
    else:
        print("Vista llamada por GET, no se elimina nada.")
        return redirect('/')

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


# Facturas
def vista_factura(request):
    # Asegúrate de que tu archivo 'factura_reporte.html' esté en tu carpeta de templates
        return render(request, 'reportes/factura_reporte.html')

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
    

# Orden de Compra
def vista_orden_compra(request):
    # Asegúrate de que tu archivo 'factura_reporte.html' esté en tu carpeta de templates
        return render(request, 'reportes/Orden_compra_reporte.html')

def generar_orden_compra_api(request, orden_id):
    if request.method != 'GET':
        return JsonResponse({'error': 'Método no permitido'}, status=405)

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT obtener_datos_orden_compra(%s);", [orden_id])
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                return HttpResponseNotFound(f'No se encontraron datos para la orden de compra con ID {orden_id}')

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)
    

# Reportes de Productores en Eventos
def reporte_productores_eventos_api(request):
    """
    API endpoint que devuelve los datos para el reporte de productores en eventos.
    """
    print("Iniciando llamada al API de reporte de productores...")
    try:
        with connection.cursor() as cursor:
            # Se llama a la función de la base de datos
            cursor.execute("SELECT public.obtener_datos_productores_eventos();")
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print("La consulta a la BD no devolvió resultados.")
                return JsonResponse([], safe=False)

            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Se procederá a enviar.")

            # Se utiliza HttpResponse para un control manual y evitar errores de serialización
            json_output = json.dumps(report_data, cls=DjangoJSONEncoder, indent=4)
            return HttpResponse(json_output, content_type='application/json')

    except Exception as e:
        # ¡ESTA PARTE ES LA MÁS IMPORTANTE!
        # Imprimirá el error exacto de la base de datos en tu consola de Django.
        print("\n¡Ocurrió un error grave en la vista del API!")
        print("------------------------------------------")
        print(f"Tipo de Excepción: {type(e).__name__}")
        print(f"Error: {e}")
        print("------------------------------------------\n")
        return JsonResponse({'error': f'Ocurrió un error en el servidor: {e}'}, status=500)

def vista_reporte_productores(request):
    """
    Esta vista simplemente renderiza la página HTML que mostrará el reporte.
    """
    return render(request, 'reportes/productores_eventos.html')


# Reporte de Eficiencia de Despacho
def reporte_eficiencia_despacho_api(request):
    """
    API endpoint que devuelve el tiempo promedio de despacho.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.calcular_eficiencia_despacho();")
            result = cursor.fetchone()
            print("Ejecutando consulta para calcular eficiencia de despacho...")
            print(f"Resultado de la consulta: {result}")
            if result is None or result[0] is None:
                return JsonResponse({'error': 'No se pudo calcular la eficiencia.'}, status=404)

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

def vista_reporte_eficiencia(request):
    """
    Esta vista simplemente renderiza la página HTML que mostrará el reporte.
    """
    # Asegúrate de crear la carpeta 'reportes' dentro de 'templates'
    return render(request, 'reportes/eficiencia_despacho.html')

# Reporte Histórico de Ofertas
def reporte_historico_ofertas_api(request):
    """
    API endpoint que devuelve las ofertas activas en un rango de fechas.
    """
    print("Iniciando llamada al API de histórico de ofertas...")
    try:
        # Obtener fechas desde los parámetros de la URL, con valores por defecto
        fecha_inicio_str = request.GET.get('inicio', '1900-01-01')
        fecha_fin_str = request.GET.get('fin', datetime.now().strftime('%Y-%m-%d'))
        
        print(f"Buscando ofertas entre {fecha_inicio_str} y {fecha_fin_str}")

        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT public.obtener_historico_ofertas(%s::DATE, %s::DATE);",
                [fecha_inicio_str, fecha_fin_str]
            )
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print("La consulta a la BD no devolvió resultados.")
                return JsonResponse([], safe=False)

            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Enviando respuesta.")
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        # ¡ESTA PARTE ES LA MÁS IMPORTANTE!
        # Imprimirá el error exacto en tu consola de Django.
        print("\n¡Ocurrió un error grave en la vista del API de Ofertas!")
        print("-----------------------------------------------------")
        print(f"Tipo de Excepción: {type(e).__name__}")
        print(f"Error: {e}")
        print("-----------------------------------------------------\n")
        return JsonResponse({'error': f'Ocurrió un error en el servidor: {e}'}, status=500)

def vista_reporte_ofertas(request):
    """
    Renderiza la página HTML para el reporte de histórico de ofertas.
    """
    return render(request, 'reportes/historico_ofertas.html')

# Reporte de Incumplimiento de Horario
def reporte_incumplimiento_horario_api(request):
    """
    API endpoint que devuelve los incumplimientos de horario en un rango de fechas.
    """
    try:
        # Obtener fechas desde los parámetros de la URL
        fecha_inicio_str = request.GET.get('inicio')
        fecha_fin_str = request.GET.get('fin')
        
        if not fecha_inicio_str or not fecha_fin_str:
            return JsonResponse({'error': 'Fechas de inicio y fin son requeridas'}, status=400)
        
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT public.obtener_reporte_incumplimiento_horario(%s::DATE, %s::DATE);",
                [fecha_inicio_str, fecha_fin_str]
            )
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                return JsonResponse([], safe=False)

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        # Manejo de errores para depuración
        print(f"Error en API de incumplimiento: {e}")
        return JsonResponse({'error': str(e)}, status=500)
    
def reporte_incumplimiento_horario_api(request):
    """
    API endpoint que devuelve los incumplimientos de horario en un rango de fechas.
    """
    try:
        # Obtener fechas desde los parámetros de la URL
        fecha_inicio_str = request.GET.get('inicio')
        fecha_fin_str = request.GET.get('fin')
        
        if not fecha_inicio_str or not fecha_fin_str:
            return JsonResponse({'error': 'Fechas de inicio y fin son requeridas'}, status=400)
        
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT public.obtener_reporte_incumplimiento_horario(%s::DATE, %s::DATE);",
                [fecha_inicio_str, fecha_fin_str]
            )
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                return JsonResponse([], safe=False)

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)
     

    except Exception as e:
        # Manejo de errores para depuración
        print(f"Error en API de incumplimiento: {e}")
        return JsonResponse({'error': str(e)}, status=500)

def vista_reporte_incumplimiento(request):
    """
    Renderiza la página HTML para el reporte de incumplimiento de horario.
    """
    return render(request, 'reportes/incumplimiento_horario.html')

# Reporte de Órdenes de Compra Pendientes
def reporte_ordenes_pendientes_api(request):
    """
    API endpoint que devuelve las órdenes de compra pendientes.
    """
    print("Iniciando llamada al API de órdenes pendientes...")
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_ordenes_compra_pendientes();")
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print("La consulta a la BD no devolvió resultados.")
                return JsonResponse([], safe=False)

            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Enviando respuesta.")
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        # ¡ESTA PARTE ES LA MÁS IMPORTANTE!
        # Imprimirá el error exacto en tu consola de Django.
        print("\n¡Ocurrió un error grave en la vista del API de Órdenes Pendientes!")
        print("-----------------------------------------------------------")
        print(f"Tipo de Excepción: {type(e).__name__}")
        print(f"Error: {e}")
        # Imprime el traceback completo para un diagnóstico detallado
        traceback.print_exc()
        print("-----------------------------------------------------------\n")
        return JsonResponse({'error': f'Ocurrió un error en el servidor: {e}'}, status=500)

def vista_reporte_ordenes_pendientes(request):
    """
    Renderiza la página HTML para el reporte de órdenes pendientes.
    """
    return render(request, 'reportes/ordenes_pendientes.html')
