# Django core
from django.shortcuts import render, redirect, get_object_or_404
from django.http import (
    JsonResponse, HttpResponse, HttpResponseNotFound, HttpResponseForbidden
)
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from django.utils.timezone import now
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User, Group
from django.core.serializers.json import DjangoJSONEncoder
from django.db import connection, transaction

# Python estándar
import json
import math
import traceback
from decimal import Decimal
from datetime import datetime, date

# Formularios
from .forms import ClienteForm, EmpleadoForm, ProveedorForm

# Utilidades personalizadas
from empleados.utils import obtener_privilegios, requiere_privilegio
from .utils import crear_usuario_sql, modificar_usuario_sql, eliminar_usuario_sql

# Modelos
from .models import (
    presentacion, venta_online, detalle_venta_online, pre_alm,
    metodo_pago, pago, moneda, historico_moneda, historico_precio_punto,
    tienda, inventario, venta_fisica, detalle_venta_fisica,
    cliente, proveedor, empleado, emp_car, usuario, lugar, estatus as Estatus,
    evento, venta_boleto_evento, existencia_evento, eve_pro, venta_evento, detalle_venta_evento
)

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

# FUNCIÓN AUXILIAR GENERALIZADA PARA CARRITO (NUEVA VERSIÓN)
def cart_data(request, tipo='fisica'):
    """Función generalizada para carrito físico, online y de eventos"""
    if tipo == 'fisica':
        cart_key = 'cart_fisica'
    elif tipo == 'evento':
        cart_key = 'cart_evento'
    elif tipo == 'venta_evento':
        # Para la nueva tienda de eventos con productos
        return cart_data_evento(request)
    else:
        cart_key = 'cart'  # para tienda online

    cart = request.session.get(cart_key, {})
    items, total_usd, total_items = [], 0, 0
    dollar_rate = get_dollar_exchange_rate()

    for product_id, quantity in cart.items():
        try:
            if tipo == 'evento':
                producto = evento.objects.get(pk=int(product_id))
                precio_usd = producto.eve_precio_boleto
                precio_bs = convert_price_to_bolivars(precio_usd)
                subtotal_usd = precio_usd * quantity
                subtotal_bs = precio_bs * quantity

                item_data = {
                    'product': producto,
                    'quantity': quantity,
                    'get_total': subtotal_usd,
                    'get_total_bs': subtotal_bs,
                    'precio_unitario': precio_usd,
                    'precio_unitario_usd': precio_usd,
                    'precio_unitario_bs': precio_bs,
                }

            else:
                producto = presentacion.objects.get(pk=int(product_id))

                if tipo == 'fisica':
                    inventario_item = inventario.objects.filter(fk_presentacion=producto).first()
                    if not inventario_item:
                        continue
                    precio_usd = inventario_item.inv_precio_unitario
                    source_item = inventario_item
                else:
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

                if tipo == 'fisica':
                    item_data['inventario'] = source_item
                else:
                    item_data['prealm'] = source_item

            items.append(item_data)
            total_usd += subtotal_usd
            total_items += quantity

        except (presentacion.DoesNotExist, evento.DoesNotExist):
            continue

    total_bs = convert_price_to_bolivars(total_usd)

    order = {
        'get_cart_total': total_usd,
        'get_cart_total_usd': total_usd,
        'get_cart_total_bs': total_bs,
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
    """Vista general de tienda (física/online/evento)"""
    data = cart_data(request, tipo)

    if tipo == 'evento':
        eventos = evento.objects.filter(eve_nro_boletos__gt=0, eve_fecha_hora__gte=timezone.now()).order_by('eve_fecha_hora')
        productos = []

        for ev in eventos:
            ev.precio_usd = ev.eve_precio_boleto
            ev.precio_bs = convert_price_to_bolivars(ev.eve_precio_boleto)
            ev.disponible = ev.eve_nro_boletos > 0
            ev.cantidad_disponible = ev.eve_nro_boletos
            ev.stock_info = f"En stock: {ev.eve_nro_boletos} boletos"
            productos.append(ev)

    else:
        productos = presentacion.objects.all()
        
        for p in productos:
            if tipo == 'fisica':
                inventario_item = inventario.objects.filter(fk_presentacion=p).first()
                if inventario_item:
                    p.precio_usd = inventario_item.inv_precio_unitario
                    p.precio_bs = convert_price_to_bolivars(inventario_item.inv_precio_unitario)
                    p.disponible = inventario_item.inv_cantidad > 0
                    p.cantidad_disponible = inventario_item.inv_cantidad
                    p.stock_info = f"En stock: {inventario_item.inv_cantidad} unidades"
                else:
                    p.precio_usd = 0
                    p.precio_bs = 0
                    p.disponible = False
                    p.cantidad_disponible = 0
                    p.stock_info = "No disponible en tienda física"
            else:
                prealm = pre_alm.objects.filter(fk_presentacion=p).first()
                if prealm:
                    p.precio_usd = prealm.pre_alm_precio
                    p.precio_bs = convert_price_to_bolivars(prealm.pre_alm_precio)
                    p.disponible = prealm.pre_alm_cantidad > 0
                    p.cantidad_disponible = prealm.pre_alm_cantidad
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

    if extra_context:
        context.update(extra_context)

    # Usar misma plantilla para todos
    template = 'store.html' if tipo != 'fisica' else 'tienda_fisica.html'
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

from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json

@csrf_exempt
def update_cart_view(request, tipo):
    """Actualizar carrito (física/online/evento) con validación e incompatibilidad entre tipos"""
    try:
        data = json.loads(request.body)
        product_id = str(data.get('productId', '')).strip()
        action = data.get('action')

        # Determinar clave de carrito por tipo
        cart_key = 'cart_evento' if tipo == 'evento' else 'cart_fisica' if tipo == 'fisica' else 'cart'
        cart = request.session.get(cart_key, {})

        if action == 'add':
            nueva_cantidad = cart.get(product_id, 0) + 1

            if tipo == 'evento':
                ev = evento.objects.get(eve_id=int(product_id))
                if ev.eve_nro_boletos < nueva_cantidad:
                    return JsonResponse({'status': 'error',
                        'message': f'No hay suficientes boletos disponibles para "{ev.eve_nombre}".'
                    }, status=400)
                cart[product_id] = nueva_cantidad

            else:
                producto = presentacion.objects.get(prese_id=int(product_id))

                if tipo == 'fisica':
                    inventario_item = inventario.objects.filter(fk_presentacion=producto).first()
                    if not inventario_item:
                        return JsonResponse({'status': 'error',
                            'message': f'Producto "{producto.prese_nombre}" no disponible en tienda física'
                        }, status=400)
                    if inventario_item.inv_cantidad < nueva_cantidad:
                        return JsonResponse({'status': 'error',
                            'message': f'Inventario insuficiente para "{producto.prese_nombre}". Disponible: {inventario_item.inv_cantidad}, Solicitado: {nueva_cantidad}'
                        }, status=400)
                else:
                    prealm_item = pre_alm.objects.filter(fk_presentacion=producto).first()
                    if not prealm_item:
                        return JsonResponse({'status': 'error',
                            'message': f'Producto "{producto.prese_nombre}" no disponible en tienda online'
                        }, status=400)
                    if prealm_item.pre_alm_cantidad < nueva_cantidad:
                        return JsonResponse({'status': 'error',
                            'message': f'Stock insuficiente para "{producto.prese_nombre}". Disponible: {prealm_item.pre_alm_cantidad}, Solicitado: {nueva_cantidad}'
                        }, status=400)

                cart[product_id] = nueva_cantidad

        elif action == 'remove' and product_id in cart:
            cart[product_id] -= 1
            if cart[product_id] <= 0:
                del cart[product_id]

        # Guardar carrito actualizado
        request.session[cart_key] = cart
        total_items = sum(q for q in cart.values() if isinstance(q, int))
        return JsonResponse({'status': 'ok', 'cartItems': total_items})

    except (presentacion.DoesNotExist, evento.DoesNotExist):
        return JsonResponse({'status': 'error', 'message': 'Producto no encontrado'}, status=404)
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': f'Error interno: {str(e)}'}, status=500)
    
# VISTAS DE CARRITO
@csrf_exempt
def cart_dropdown_data(request):
    """Vista AJAX para obtener datos del carrito para el dropdown"""
    try:
        # Detectar tipo de tienda basándose en la URL de referencia o el path actual
        tipo = 'fisica'  # default
        
        # Verificar la URL de referencia (de dónde viene la petición)
        referer = request.META.get('HTTP_REFERER', '')
        if '/store/online/' in referer:
            tipo = 'online'
        elif '/store/fisica/' in referer:
            tipo = 'fisica'
        elif '/tienda-eventos/' in referer:
            tipo = 'venta_evento'
        
        # También verificar el path actual
        current_path = request.path
        if '/online/' in current_path:
            tipo = 'online'
        elif '/fisica/' in current_path:
            tipo = 'fisica'
        elif '/eventos/' in current_path:
            tipo = 'venta_evento'
            
        # Si hay parámetro en la petición, usarlo
        if request.GET.get('tipo'):
            tipo = request.GET.get('tipo')
        
        data = cart_data(request, tipo=tipo)
        
        cart_items = []
        
        if tipo == 'venta_evento':
            # Manejar items de eventos - usar los campos correctos de cart_data_evento
            for item in data['items']:
                cart_items.append({
                    'product_id': item['id'],  # cart_data_evento devuelve 'id'
                    'name': item['nombre'],   # cart_data_evento devuelve 'nombre'
                    'quantity': item['quantity'],
                    'price_usd': float(item['precio_unitario']),
                    'price_bs': float(item['precio_unitario_bs']),
                    'subtotal_usd': float(item['get_total']),
                    'subtotal_bs': float(item['get_total_bs']),
                    'image': item.get('imagen'),  # cart_data_evento devuelve 'imagen'
                    'is_ticket': item.get('es_entrada', False)
                })
        else:
            # Manejar items normales
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
            'empty': len(cart_items) == 0,
            'tipo': tipo  # Incluir el tipo detectado en la respuesta
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
            'empty': True,
            'tipo': 'fisica'
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
    if tipo == 'venta_evento':
        data = cart_data_evento(request)
        return render(request, 'cart.html', {
            'items': data['items'],
            'order': data['order'],
            'cartItems': data['cartItems'],
            'tipo': tipo,
            'is_evento': True,
        })
    else:
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
    if tipo == 'venta_evento':
        data = cart_data_evento(request)
    else:
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
    # Limpiar el carrito ahora que la venta fue exitosa
    request.session['cart'] = {}

    return JsonResponse({
        'status': 'ok', 
        'message': 'Venta registrada', 
        'venta_id': venta.ven_fis_id,
        'redirect_url': f'/compra-exitosa/fisica/{venta.ven_fis_id}/'
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

    # Determinar clave de carrito según tipo
    if tipo == 'venta_evento':
        cart_key = 'cart_venta_evento'
    else:
        cart_key = 'cart_evento' if tipo == 'evento' else 'cart_fisica' if tipo == 'fisica' else 'cart'
    
    cart = request.session.get(cart_key, {})

    if not cart:
        return JsonResponse({'status': 'error', 'message': 'Carrito vacío'}, status=400)

    detalles_validados, total_venta = [], 0

    if tipo == 'venta_evento':
        # Manejo especial para venta de eventos (productos + boletos)
        errores_items = []
        
        for item_id, cantidad in cart.items():
            try:
                if item_id.startswith('boleto_'):
                    # Es un boleto
                    evento_id = int(item_id.replace('boleto_', ''))
                    evento_obj = evento.objects.get(eve_id=evento_id)
                    
                    # Usar función SQL para obtener disponibilidad real
                    with connection.cursor() as cursor:
                        cursor.execute("SELECT obtener_info_disponibilidad_evento(%s);", [evento_id])
                        result = cursor.fetchone()
                        if result and result[0]:
                            info_boletos = result[0]
                            boletos_disponibles = info_boletos.get('boletos_disponibles', 0)
                        else:
                            boletos_disponibles = 0
                    
                    if boletos_disponibles < cantidad:
                        errores_items.append(
                            f'No hay suficientes boletos para "{evento_obj.eve_nombre}". '
                            f'Disponibles: {boletos_disponibles}, Solicitados: {cantidad}'
                        )
                        continue
                    
                    detalles_validados.append({
                        'tipo': 'boleto',
                        'evento_id': evento_obj.eve_id,
                        'cantidad': cantidad,
                        'precio_unitario': float(evento_obj.eve_precio_boleto),
                        'nombre': f'Entrada - {evento_obj.eve_nombre}'
                    })
                    total_venta += float(evento_obj.eve_precio_boleto) * cantidad
                    
                elif item_id.startswith('producto_'):
                    # Es un producto del evento
                    existencia_id = int(item_id.replace('producto_', ''))
                    existencia = existencia_evento.objects.select_related(
                        'fk_presentacion',
                        'fk_evento_proveedor__fk_evento'
                    ).get(exi_eve_id=existencia_id)
                    
                    if existencia.exi_eve_cantidad < cantidad:
                        errores_items.append(
                            f'No hay suficiente stock de "{existencia.fk_presentacion.prese_nombre}". '
                            f'Disponible: {existencia.exi_eve_cantidad}, Solicitado: {cantidad}'
                        )
                        continue
                    
                    detalles_validados.append({
                        'tipo': 'producto',
                        'existencia_id': existencia.exi_eve_id,
                        'cantidad': cantidad,
                        'precio_unitario': float(existencia.fk_presentacion.prese_precio),
                        'nombre': existencia.fk_presentacion.prese_nombre,
                        'evento_id': existencia.fk_evento_proveedor.fk_evento.eve_id
                    })
                    total_venta += float(existencia.fk_presentacion.prese_precio) * cantidad
                    
            except (evento.DoesNotExist, existencia_evento.DoesNotExist):
                errores_items.append(f'Producto con ID {item_id} no encontrado')
                continue
        
        if errores_items:
            return JsonResponse({
                'status': 'error',
                'message': 'Errores con los productos:',
                'errores': errores_items
            }, status=400)
            
    elif tipo == 'evento':
        errores_boletos = []
        for eid, cantidad in cart.items():
            try:
                ev = evento.objects.get(pk=int(eid))

                # Usar función SQL para obtener disponibilidad real
                with connection.cursor() as cursor:
                    cursor.execute("SELECT obtener_info_disponibilidad_evento(%s);", [ev.eve_id])
                    result = cursor.fetchone()
                    if result and result[0]:
                        info_boletos = result[0]
                        boletos_disponibles = info_boletos.get('boletos_disponibles', 0)
                    else:
                        boletos_disponibles = 0

                if boletos_disponibles < cantidad:
                    errores_boletos.append(
                        f'No hay suficientes boletos para "{ev.eve_nombre}". '
                        f'Disponibles: {boletos_disponibles}, Solicitados: {cantidad}'
                    )
                    continue

                detalles_validados.append({
                    'evento_id': ev.eve_id,
                    'cantidad': cantidad,
                    'precio_unitario': float(ev.eve_precio_boleto)
                })
                total_venta += float(ev.eve_precio_boleto) * cantidad

            except evento.DoesNotExist:
                errores_boletos.append(f'Evento con ID {eid} no encontrado')
                continue

        if errores_boletos:
            return JsonResponse({
                'status': 'error',
                'message': 'Errores con los boletos:',
                'errores': errores_boletos
            }, status=400)

    elif tipo == 'fisica':
        errores_productos = []
        for pid, cantidad in cart.items():
            try:
                producto = presentacion.objects.get(pk=int(pid))
                invent = inventario.objects.filter(fk_presentacion=producto).first()

                if not invent:
                    errores_productos.append(f'Producto no disponible: {producto.prese_nombre}')
                    continue

                if invent.inv_cantidad < cantidad:
                    errores_productos.append(
                        f'Sin stock suficiente para "{producto.prese_nombre}". '
                        f'Disponible: {invent.inv_cantidad}, Solicitado: {cantidad}'
                    )
                    continue

                detalles_validados.append({
                    'presentacion_id': producto.prese_id,
                    'inventario_id': invent.inv_id,  # Agregar inventario_id
                    'cantidad': cantidad,
                    'precio_unitario': float(invent.inv_precio_unitario)
                })
                total_venta += float(invent.inv_precio_unitario) * cantidad

            except presentacion.DoesNotExist:
                errores_productos.append(f'Producto con ID {pid} no encontrado')
                continue

        if errores_productos:
            return JsonResponse({
                'status': 'error',
                'message': 'Errores con productos:',
                'errores': errores_productos
            }, status=400)

    else:  # tipo == 'online'
        errores_productos = []
        for pid, cantidad in cart.items():
            try:
                producto = presentacion.objects.get(pk=int(pid))
                prealm = pre_alm.objects.filter(fk_presentacion=producto).first()

                if not prealm:
                    errores_productos.append(f'Producto no disponible: {producto.prese_nombre}')
                    continue

                if prealm.pre_alm_cantidad < cantidad:
                    errores_productos.append(
                        f'Sin stock suficiente para "{producto.prese_nombre}". '
                        f'Disponible: {prealm.pre_alm_cantidad}, Solicitado: {cantidad}'
                    )
                    continue

                detalles_validados.append({
                    'pre_alm_id': prealm.pre_alm_id,  # ✅ CORREGIDO
                    'cantidad': cantidad,
                    'precio_unitario': float(prealm.pre_alm_precio)
                })
                total_venta += float(prealm.pre_alm_precio) * cantidad

            except presentacion.DoesNotExist:
                errores_productos.append(f'Producto con ID {pid} no encontrado')
                continue

        if errores_productos:
            return JsonResponse({
                'status': 'error',
                'message': 'Errores con productos:',
                'errores': errores_productos
            }, status=400)

    if total_venta <= 0 or not detalles_validados:
        return JsonResponse({'status': 'error', 'message': 'Orden inválida - sin productos válidos'}, status=400)

    # Guardar en sesión para usar luego en la pantalla de métodos de pago
    request.session['pending_order_data'] = {
        'tipo': tipo,
        'detalles': detalles_validados,
        'total': float(total_venta),
        'cart_key': cart_key
    }

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
                
                # VALIDACIÓN: El monto mínimo debe ser equivalente al valor de 1 punto
                if amount_bolivares < valor_punto:
                    return JsonResponse({
                        'status': 'error', 
                        'message': f'El monto mínimo para pago con puntos es {valor_punto} Bs (equivalente a 1 punto)'
                    }, status=400)
                
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
            tipo = order_data.get('tipo')
            detalles = order_data.get('detalles', [])
            venta_id = None
            venta_fisica_obj = venta_online_obj = venta_evento_obj = None

            if tipo in ['evento', 'venta_evento']:
                print("Creando ventas de evento...")
                # Separar boletos y productos
                boletos = [d for d in detalles if d['tipo'] == 'boleto']
                productos = [d for d in detalles if d['tipo'] == 'producto']
                
                print(f"=== DEBUGGING SEPARACIÓN ===")
                print(f"Detalles originales: {detalles}")
                print(f"Boletos detectados: {boletos}")
                print(f"Productos detectados: {productos}")
                print(f"Cantidad de boletos: {len(boletos)}")
                print(f"Cantidad de productos: {len(productos)}")
                
                venta_boleto_obj = None
                venta_evento_obj = None
                venta_id = None
                
                # Crear venta de boletos si hay boletos
                if boletos:
                    print(f"=== CREANDO VENTA DE BOLETOS ===")
                    evento_obj = evento.objects.get(pk=boletos[0]['evento_id'])
                    total_boletos = sum(d['precio_unitario'] * d['cantidad'] for d in boletos)
                    cantidad_total_boletos = sum(d['cantidad'] for d in boletos)
                    
                    venta_boleto_obj = venta_boleto_evento.objects.create(
                        ven_bol_eve_fecha_hora=timezone.now(),
                        ven_bol_eve_monto_total=total_boletos,
                        ven_bol_eve_cantidad=cantidad_total_boletos,
                        ven_bol_eve_descripcion=f'Compra de {cantidad_total_boletos} boletos',
                        fk_evento=evento_obj,
                        fk_usuario=request.user
                    )
                    
                    # NO reducir stock de boletos - se maneja por funciones SQL de suma
                    # evento_obj.eve_nro_boletos -= cantidad_total_boletos
                    # evento_obj.save()
                    
                    venta_id = venta_boleto_obj.ven_bol_eve_id
                    print(f"Venta de boletos creada con ID: {venta_id}")
                else:
                    print(f"=== NO HAY BOLETOS - SALTANDO CREACIÓN DE VENTA DE BOLETOS ===")
                
                # Crear venta de productos si hay productos
                if productos:
                    print(f"=== CREANDO VENTA DE PRODUCTOS ===")
                    # Obtener cliente del usuario
                    cliente_obj = None
                    if hasattr(request.user, 'fk_cliente') and request.user.fk_cliente:
                        cliente_obj = request.user.fk_cliente
                    else:
                        # Buscar cliente por username/CI si no está asociado directamente
                        try:
                            cliente_obj = cliente.objects.get(cli_nat_ci=request.user.username)
                        except cliente.DoesNotExist:
                            print(f"Cliente no encontrado para usuario {request.user.username}")
                            # Crear un cliente temporal o usar uno por defecto
                            cliente_obj = cliente.objects.first()  # Usar el primer cliente como fallback
                    
                    if cliente_obj:
                        evento_obj = evento.objects.get(pk=productos[0]['evento_id'])
                        total_productos = sum(d['precio_unitario'] * d['cantidad'] for d in productos)
                        
                        venta_evento_obj = venta_evento.objects.create(
                            ven_eve_fecha_hora=timezone.now(),
                            ven_eve_monto_total=total_productos,
                            fk_evento=evento_obj,
                            fk_cliente=cliente_obj
                        )
                        
                        # Crear detalles de venta de productos
                        for d in productos:
                            existencia = existencia_evento.objects.get(pk=d['existencia_id'])
                            detalle_venta_evento.objects.create(
                                det_ven_eve_cantidad=d['cantidad'],
                                det_ven_eve_precio_unitario=d['precio_unitario'],
                                fk_venta_evento=venta_evento_obj,
                                fk_exi_eve=existencia
                            )
                            # Actualizar stock
                            existencia.exi_eve_cantidad -= d['cantidad']
                            existencia.save()
                        
                        # Si no hay boletos, usar el ID de venta de productos
                        if not venta_id:
                            venta_id = venta_evento_obj.ven_eve_id
                            print(f"=== ASIGNANDO venta_id PRINCIPAL: {venta_id} (productos) ===")
                        else:
                            print(f"=== venta_id YA ASIGNADO: {venta_id} (boletos), productos ID: {venta_evento_obj.ven_eve_id} ===")
                        
                        print(f"Venta de productos creada con ID: {venta_evento_obj.ven_eve_id}")
                    else:
                        print(f"=== ERROR: NO SE PUDO OBTENER CLIENTE ===")
                else:
                    print(f"=== NO HAY PRODUCTOS - SALTANDO CREACIÓN DE VENTA DE PRODUCTOS ===")
                
                print(f"=== RESUMEN FINAL ===")
                print(f"venta_boleto_obj: {venta_boleto_obj}")
                print(f"venta_evento_obj: {venta_evento_obj}")
                print(f"venta_id final: {venta_id}")
                
                if not venta_id:
                    raise Exception('No se pudo crear ninguna venta')
                
                # Para compras mixtas, devolver información de ambas ventas
                venta_info = {
                    'venta_boleto_id': venta_boleto_obj.ven_bol_eve_id if venta_boleto_obj else None,
                    'venta_producto_id': venta_evento_obj.ven_eve_id if venta_evento_obj else None,
                    'es_mixta': bool(venta_boleto_obj and venta_evento_obj)
                }
                print(f"venta_info: {venta_info}")

            else:
                # Para ventas físicas u online
                venta_fisica_obj, venta_online_obj = create_sale_from_order_data(order_data, request.user)
                venta_id = venta_fisica_obj.ven_fis_id if venta_fisica_obj else venta_online_obj.ven_onl_id

            # CREAR CADA MÉTODO DE PAGO Y SU PAGO CORRESPONDIENTE
            created_payments = []

            for i, payment_data in enumerate(partial_payments):
                print(f"\n--- Procesando pago {i+1}/{len(partial_payments)} ---")
                print(f"Datos del pago: {payment_data}")

                metodo_pago_obj = create_payment_method_from_partial_data(request.user, payment_data)
                if isinstance(metodo_pago_obj, JsonResponse):
                    raise Exception(f'Error creando método de pago: {payment_data["tipo_pago"]}')

                venta_fisica_id = venta_fisica_obj.ven_fis_id if venta_fisica_obj else None
                venta_online_id = venta_online_obj.ven_onl_id if venta_online_obj else None
                # Para pagos de eventos: solo productos tienen referencia en tabla pago
                venta_evento_id = venta_evento_obj.ven_eve_id if venta_evento_obj else None

                try:
                    moneda_obj = moneda.objects.get(mon_id=payment_data['moneda_id'])
                except moneda.DoesNotExist:
                    raise Exception(f'Moneda no encontrada: {payment_data["moneda_id"]}')

                if payment_data['tipo_pago'] == 'puntos':
                    with connection.cursor() as cursor:
                        cursor.execute("""
                            SELECT * FROM public.procesar_pago_puntos(%s, %s, %s, %s, %s)
                            AS (pago_id INTEGER, metodo_pago_id INTEGER, puntos_utilizados INTEGER, puntos_restantes INTEGER, monto_pago DECIMAL)
                        """, [
                            request.user.id,
                            payment_data['puntos_utilizados'],
                            venta_fisica_id,
                            venta_online_id,
                            venta_evento_id
                        ])
                        resultado = cursor.fetchone()
                        if not resultado:
                            raise Exception('Error procesando pago con puntos')
                        pago_id = resultado[0]
                else:
                    with connection.cursor() as cursor:
                        cursor.execute("""SELECT public.registrar_pago(%s, %s, %s, %s, %s, %s)""", [
                            float(payment_data['monto_original']),
                            metodo_pago_obj.met_pag_id,
                            venta_fisica_id,
                            venta_online_id,
                            venta_evento_id,
                            moneda_obj.mon_id
                        ])
                        result = cursor.fetchone()
                        if not result or not result[0]:
                            raise Exception('Error registrando pago')
                        pago_id = result[0]

                created_payments.append({
                    'pago_id': pago_id,
                    'metodo_pago_id': metodo_pago_obj.met_pag_id,
                    'monto_original': payment_data['monto_original'],
                    'monto_bolivares': payment_data['monto_bolivares'],
                    'moneda': payment_data['moneda_tipo'],
                    'tipo_pago': payment_data['tipo_pago']
                })

        request.session.pop('pending_order_data', None)
        request.session.pop('partial_payments', None)
        request.session[order_data['cart_key']] = {}
        
        # Guardar información de venta mixta en sesión para la página de éxito
        if tipo in ['evento', 'venta_evento'] and 'venta_info' in locals():
            request.session['venta_info'] = venta_info

        if tipo not in ['fisica', 'online', 'evento', 'venta_evento']:
            return JsonResponse({'status': 'error', 'message': 'Tipo de venta inválido'}, status=400)

        # Normalizar tipo para URL
        tipo_venta = 'evento' if tipo in ['evento', 'venta_evento'] else tipo
        
        response_data = {
            'status': 'success',
            'message': 'Compra finalizada exitosamente',
            'venta_id': venta_id,
            'total_pagos': len(created_payments),
            'pagos_creados': created_payments,
            'redirect_url': f'/compra-exitosa/{tipo_venta}/{venta_id}/'
        }
        
        # Agregar información adicional para ventas de eventos
        if tipo in ['evento', 'venta_evento'] and 'venta_info' in locals():
            response_data['venta_info'] = venta_info
        
        return JsonResponse(response_data)

    except Exception as e:
        return JsonResponse({'status': 'error', 'message': f'Error finalizando compra: {str(e)}'}, status=500)
    
@login_required
def purchase_success_view(request, tipo, venta_id):
    """Vista para mostrar la página de éxito después de completar una compra"""
    try:
        # Validar tipo de venta
        if tipo not in ['fisica', 'online', 'evento', 'venta_evento']:
            return HttpResponseNotFound("Tipo de venta inválido.")
        
        venta_fisica_obj = venta_online_obj = venta_evento_obj = None

        if tipo == 'fisica':
            try:
                venta_fisica_obj = venta_fisica.objects.get(ven_fis_id=venta_id)
                if request.user.fk_cliente and venta_fisica_obj.fk_cliente.cli_id != request.user.fk_cliente.cli_id:
                    return HttpResponseNotFound("No se encontró la venta especificada.")
            except venta_fisica.DoesNotExist:
                return HttpResponseNotFound("No se encontró la venta física especificada.")
        
        elif tipo == 'online':
            try:
                venta_online_obj = venta_online.objects.get(ven_onl_id=venta_id)
                if venta_online_obj.fk_usuario.id != request.user.id:
                    return HttpResponseNotFound("No se encontró la venta especificada.")
            except venta_online.DoesNotExist:
                return HttpResponseNotFound("No se encontró la venta online especificada.")
        
        elif tipo in ['evento', 'venta_evento']:
            # Para eventos, primero verificar si hay información de venta mixta en la sesión
            venta_mixta_info = request.session.get('venta_info', {})
            
            if venta_mixta_info and venta_mixta_info.get('es_mixta', False):
                # Es una venta mixta, usar la información guardada
                venta_evento_obj = None  # No necesitamos el objeto específico
                print(f"🔄 VENTA MIXTA detectada: {venta_mixta_info}")
            else:
                # Verificar si tenemos información específica del tipo en la sesión
                if venta_mixta_info:
                    print(f"📋 INFO DE SESIÓN disponible: {venta_mixta_info}")
                    
                    # Usar la información de sesión para determinar el tipo correcto
                    if venta_mixta_info.get('venta_boleto_id') and not venta_mixta_info.get('venta_producto_id'):
                        # Solo boletos
                        print(f"🎫 SESIÓN indica: SOLO BOLETOS - ID: {venta_mixta_info['venta_boleto_id']}")
                        try:
                            venta_evento_obj = venta_boleto_evento.objects.get(ven_bol_eve_id=venta_mixta_info['venta_boleto_id'])
                            request.session['venta_info']['tipo_especifico'] = 'boleto'
                        except venta_boleto_evento.DoesNotExist:
                            return HttpResponseNotFound("No se encontró la venta de boletos especificada.")
                            
                    elif venta_mixta_info.get('venta_producto_id') and not venta_mixta_info.get('venta_boleto_id'):
                        # Solo productos
                        print(f"🛍️ SESIÓN indica: SOLO PRODUCTOS - ID: {venta_mixta_info['venta_producto_id']}")
                        try:
                            venta_evento_obj = venta_evento.objects.get(ven_eve_id=venta_mixta_info['venta_producto_id'])
                            request.session['venta_info']['tipo_especifico'] = 'producto'
                            # Importante: actualizar el venta_id para que coincida con el producto
                            venta_id = venta_mixta_info['venta_producto_id']
                        except venta_evento.DoesNotExist:
                            return HttpResponseNotFound("No se encontró la venta de productos especificada.")
                    else:
                        print(f"⚠️ INFO DE SESIÓN ambigua, usando detección tradicional")
                        # Fallback a detección tradicional
                        try:
                            venta_evento_obj = venta_boleto_evento.objects.get(ven_bol_eve_id=venta_id)
                            request.session['venta_info']['tipo_especifico'] = 'boleto'
                            print(f"🎫 Identificado como venta de BOLETOS - ID: {venta_id}")
                        except venta_boleto_evento.DoesNotExist:
                            try:
                                venta_evento_obj = venta_evento.objects.get(ven_eve_id=venta_id)
                                request.session['venta_info']['tipo_especifico'] = 'producto'
                                print(f"🛍️ Identificado como venta de PRODUCTOS - ID: {venta_id}")
                            except venta_evento.DoesNotExist:
                                return HttpResponseNotFound("No se encontró la venta de evento especificada.")
                else:
                    # No hay información de sesión, usar detección tradicional
                    print(f"⚠️ SIN INFO DE SESIÓN, usando detección tradicional para ID: {venta_id}")
                    try:
                        venta_evento_obj = venta_boleto_evento.objects.get(ven_bol_eve_id=venta_id)
                        if 'venta_info' not in request.session:
                            request.session['venta_info'] = {}
                        request.session['venta_info']['tipo_especifico'] = 'boleto'
                        print(f"🎫 Identificado como venta de BOLETOS - ID: {venta_id}")
                    except venta_boleto_evento.DoesNotExist:
                        try:
                            venta_evento_obj = venta_evento.objects.get(ven_eve_id=venta_id)
                            if 'venta_info' not in request.session:
                                request.session['venta_info'] = {}
                            request.session['venta_info']['tipo_especifico'] = 'producto'
                            print(f"🛍️ Identificado como venta de PRODUCTOS - ID: {venta_id}")
                        except venta_evento.DoesNotExist:
                            return HttpResponseNotFound("No se encontró la venta de evento especificada.")

        # Determinar la información de la venta
        if venta_fisica_obj:
            venta_info = {
                'id': venta_fisica_obj.ven_fis_id,
                'fecha': venta_fisica_obj.ven_fis_fecha.strftime('%d/%m/%Y %H:%M'),
                'total': venta_fisica_obj.ven_fis_total,
                'tipo': 'Venta Física',
                'tipo_url': 'fisica',
                'tienda': venta_fisica_obj.fk_tienda.tie_nombre if venta_fisica_obj.fk_tienda else 'N/A'
            }
        elif venta_online_obj:
            venta_info = {
                'id': venta_online_obj.ven_onl_id,
                'fecha': venta_online_obj.ven_onl_fecha.strftime('%d/%m/%Y %H:%M'),
                'total': venta_online_obj.ven_onl_total,
                'tipo': 'Venta Online',
                'tipo_url': 'online',
                'tienda': venta_online_obj.fk_tienda.tie_nombre if venta_online_obj.fk_tienda else 'N/A'
            }
        else:  # evento
            # Verificar si es venta mixta
            venta_mixta_info = request.session.get('venta_info', {})
            
            if venta_mixta_info and venta_mixta_info.get('es_mixta', False):
                # Es una venta mixta - calcular total de ambas ventas
                total_mixto = 0
                
                # Sumar total de boletos si existe
                if venta_mixta_info.get('venta_boleto_id'):
                    try:
                        boleto_venta = venta_boleto_evento.objects.get(ven_bol_eve_id=venta_mixta_info['venta_boleto_id'])
                        total_mixto += float(boleto_venta.ven_bol_eve_monto_total)
                    except venta_boleto_evento.DoesNotExist:
                        pass
                
                # Sumar total de productos si existe
                if venta_mixta_info.get('venta_producto_id'):
                    try:
                        producto_venta = venta_evento.objects.get(ven_eve_id=venta_mixta_info['venta_producto_id'])
                        total_mixto += float(producto_venta.ven_eve_monto_total)
                    except venta_evento.DoesNotExist:
                        pass
                
                venta_info = {
                    'id': venta_id,  # ID principal (puede ser cualquiera de las dos ventas)
                    'fecha': timezone.now().strftime('%d/%m/%Y %H:%M'),
                    'total': total_mixto,  # Total calculado de ambas ventas
                    'tipo': 'Venta de Evento (Mixta)',
                    'tipo_url': 'evento',
                    'tienda': 'Evento Mixto'
                }
            elif hasattr(venta_evento_obj, 'ven_bol_eve_id'):
                # Es venta de boletos
                venta_info = {
                    'id': venta_evento_obj.ven_bol_eve_id,
                    'fecha': venta_evento_obj.ven_bol_eve_fecha_hora.strftime('%d/%m/%Y %H:%M'),
                    'total': venta_evento_obj.ven_bol_eve_monto_total,
                    'tipo': 'Venta de Boletos',
                    'tipo_url': 'evento',
                    'tienda': venta_evento_obj.fk_evento.eve_nombre if venta_evento_obj.fk_evento else 'N/A'
                }
            else:
                # Es venta de productos de evento
                venta_info = {
                    'id': venta_evento_obj.ven_eve_id,
                    'fecha': venta_evento_obj.ven_eve_fecha_hora.strftime('%d/%m/%Y %H:%M'),
                    'total': venta_evento_obj.ven_eve_monto_total,
                    'tipo': 'Venta de Productos de Evento',
                    'tipo_url': 'evento',
                    'tienda': 'Evento' # Podríamos mejorar esto con el nombre del evento
                }

        context = {
            'venta_info': venta_info,
            'venta_id': venta_id,
            'venta_mixta_info': request.session.get('venta_info', {})  # Agregar info mixta al contexto
        }

        # NO limpiar información de venta mixta aún - se necesita en el template
        # if 'venta_info' in request.session:
        #     del request.session['venta_info']

        return render(request, 'purchase_success.html', context)

    except Exception as e:
        print(f"Error en página de éxito: {e}")
        return HttpResponse(f"<h1>Error</h1><p>Ocurrió un error al mostrar la página de éxito: {str(e)}</p>", status=500)
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
        
        # Obtener el ID de la venta para la página de éxito
        venta_id = venta_fisica_obj.ven_fis_id if venta_fisica_obj else venta_online_obj.ven_onl_id
        tipo_venta = 'fisica' if venta_fisica_obj else 'online'
        
        return JsonResponse({
            'status': 'success',
            'message': 'Pago procesado exitosamente',
            'pago_id': pago_obj.pag_id,
            'monto_original': float(total_decimal),
            'monto_convertido': float(monto_convertido),
            'moneda': moneda_obj.mon_tipo,
            'tasa_cambio': float(ultimo_historico.his_valor_cambio),
            'redirect_url': f'/compra-exitosa/{tipo_venta}/{venta_id}/'  # Redirigir a la página de éxito
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
            
            # VALIDACIÓN: El monto mínimo debe ser equivalente al valor de 1 punto
            if float(total_bs) < valor_punto:
                return JsonResponse({
                    'status': 'error', 
                    'message': f'El monto mínimo para pago con puntos es {valor_punto} Bs (equivalente a 1 punto)'
                }, status=400)
            
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
        
        # Obtener el ID de la venta para la página de éxito
        venta_id = venta_fisica_obj.ven_fis_id if venta_fisica_obj else venta_online_obj.ven_onl_id
        tipo_venta = 'fisica' if venta_fisica_obj else 'online'
        
        return JsonResponse({
            'status': 'success',
            'message': 'Pago con puntos procesado exitosamente',
            'pago_id': pago_id,
            'puntos_utilizados': puntos_utilizados,
            'puntos_restantes': puntos_restantes,
            'redirect_url': f'/compra-exitosa/{tipo_venta}/{venta_id}/'
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
    venta_evento_obj = None
    
    try:
        if tipo == 'venta_evento':
            # Manejar venta de eventos con productos y boletos
            # Primero agrupar por evento
            eventos_involucrados = {}
            for detalle in detalles:
                evento_id = detalle.get('evento_id')
                if evento_id:
                    if evento_id not in eventos_involucrados:
                        eventos_involucrados[evento_id] = []
                    eventos_involucrados[evento_id].append(detalle)
            
            # Si solo hay un evento, crear una venta_evento normal
            if len(eventos_involucrados) == 1:
                evento_id = list(eventos_involucrados.keys())[0]
                evento_obj = evento.objects.get(eve_id=evento_id)
                
                # Crear venta_evento
                venta_evento_obj = venta_evento.objects.create(
                    ven_eve_fecha_hora=timezone.now(),
                    ven_eve_monto_total=float(total_bolivares),
                    fk_evento=evento_obj,
                    fk_cliente=user.fk_cliente if user.fk_cliente else None
                )
                
                # Crear detalles de venta
                for detalle in detalles:
                    if detalle['tipo'] == 'boleto':
                        # Actualizar número de boletos del evento - YA SE HACE EN finalize_multiple_payment_purchase
                        # evento_obj.eve_nro_boletos -= detalle['cantidad']
                        # evento_obj.save()
                        
                        # Crear registro de venta de boleto si es necesario
                        # (podría ser en detalle_venta_evento o venta_boleto_evento)
                        pass
                        
                    elif detalle['tipo'] == 'producto':
                        # Crear detalle de venta de producto
                        existencia = existencia_evento.objects.get(exi_eve_id=detalle['existencia_id'])
                        
                        detalle_venta_evento.objects.create(
                            fk_venta_evento=venta_evento_obj,
                            fk_exi_eve=existencia,
                            det_ven_eve_cantidad=detalle['cantidad'],
                            det_ven_eve_precio_unitario=detalle['precio_unitario']
                        )
                        
                        # Actualizar stock de existencia_evento
                        existencia.exi_eve_cantidad -= detalle['cantidad']
                        existencia.save()
            
            else:
                # Si hay múltiples eventos, manejar de manera especial
                # Por ahora, crear una venta por el primer evento
                # (esto podría mejorar en el futuro)
                evento_id = list(eventos_involucrados.keys())[0]
                evento_obj = evento.objects.get(eve_id=evento_id)
                
                venta_evento_obj = venta_evento.objects.create(
                    ven_eve_fecha_hora=timezone.now(),
                    ven_eve_monto_total=float(total_bolivares),
                    fk_evento=evento_obj,
                    fk_cliente=user.fk_cliente if user.fk_cliente else None
                )
                
                # Procesar todos los detalles
                for detalle in detalles:
                    if detalle['tipo'] == 'boleto':
                        # Actualizar número de boletos del evento - YA SE HACE EN finalize_multiple_payment_purchase
                        # evento_temp = evento.objects.get(eve_id=detalle['evento_id'])
                        # evento_temp.eve_nro_boletos -= detalle['cantidad']
                        # evento_temp.save()
                        pass
                    elif detalle['tipo'] == 'producto':
                        existencia = existencia_evento.objects.get(exi_eve_id=detalle['existencia_id'])
                        
                        # Solo crear detalle si pertenece al evento principal
                        if existencia.fk_evento_proveedor.fk_evento.eve_id == evento_id:
                            detalle_venta_evento.objects.create(
                                fk_venta_evento=venta_evento_obj,
                                fk_exi_eve=existencia,
                                det_ven_eve_cantidad=detalle['cantidad'],
                                det_ven_eve_precio_unitario=detalle['precio_unitario']
                            )
                        
                        existencia.exi_eve_cantidad -= detalle['cantidad']
                        existencia.save()
        
        elif tipo == 'fisica':
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
                prealm_obj = pre_alm.objects.get(pre_alm_id=detalle['pre_alm_id'])
                detalle_venta_online.objects.create(
                    fk_venta_online=venta_online_obj,
                    fk_pre_alm=prealm_obj,
                    det_ven_onl_cantidad=detalle['cantidad'],
                    det_ven_onl_precio=detalle['precio_unitario']
                )
        
        return venta_fisica_obj, venta_online_obj, venta_evento_obj
        
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

            # Obtener privilegios desde la BD y guardarlos en la sesión
            request.session['privilegios'] = list(obtener_privilegios(user))

            # DETECTAR TIPO DE USUARIO Y REDIRIGIR APROPIADAMENTE
            if hasattr(user, 'fk_emp_car') and user.fk_emp_car:
                messages.success(request, f'¡Bienvenido al módulo de empleados, {user.get_full_name() or user.username}!')
                return redirect('empleados:dashboard')
            elif hasattr(user, 'fk_cliente') and user.fk_cliente:
                messages.success(request, f'¡Bienvenido a la tienda, {user.get_full_name() or user.username}!')
                return redirect('store_view', tipo='fisica')
            elif hasattr(user, 'fk_proveedor') and user.fk_proveedor:
                messages.success(request, f'¡Bienvenido, {user.get_full_name() or user.username}!')
                return redirect('home')

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


# NOTA: Las vistas de reportes se han movido al módulo de empleados
# para una mejor organización y control de acceso.

# Historial de Compras de Clientes
def historial_compras_api(request, id_usuario):
    """
    API endpoint que devuelve el historial de compras para un cliente,
    buscado a través de su ID de usuario.
    """
    try:
        user= get_object_or_404(usuario, pk=id_usuario)
        cliente_id = user.fk_cliente_id 
        
        if not cliente_id:
            return JsonResponse([], safe=False)

        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_historial_compras_cliente(%s);", [cliente_id])
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                return JsonResponse([], safe=False)

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except usuario.DoesNotExist:
        return HttpResponseNotFound("El usuario no existe.")
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

def vista_historial_compras(request, id_usuario):
    usuario_obj = get_object_or_404(usuario, pk=id_usuario)
    cliente_obj = usuario_obj.fk_cliente 
    
    if not cliente_obj:
        return HttpResponse("Este usuario no tiene un perfil de cliente asociado.", status=404)
    
    context = {'cliente': cliente_obj, 'usuario': usuario_obj}
    return render(request, 'historial_compras_cliente.html', context)

@login_required
def vista_factura_directa(request, tipo, venta_id):
    """Vista para mostrar factura directamente especificando el tipo de venta y el ID."""
    try:
        # Validar tipo
        if tipo not in ['fisica', 'online', 'evento']:
            return HttpResponseNotFound("<h1>Tipo de venta inválido</h1>")

        if tipo in ['fisica', 'online']:
            try:
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.obtener_datos_reporte_venta(%s, %s);", [venta_id, tipo])
                    result = cursor.fetchone()
                if result is None or result[0] is None:
                    return HttpResponseNotFound(f"<h1>Factura {tipo} no encontrada</h1>")
                
                report_data = result[0]
                report_data['dollar_rate'] = float(get_dollar_exchange_rate())
                return render(request, 'factura_template.html', {'report_data': report_data})
            except Exception as e:
                print(f"Error obteniendo factura {tipo}: {e}")
                return HttpResponse(f"<h1>Error</h1><p>Error al obtener la factura: {str(e)}</p>", status=500)

        elif tipo == 'evento':
            # Detectar automáticamente si es venta de boletos o productos
            # Verificar ambas tablas para determinar el tipo correcto
            tiene_boletos = False
            tiene_productos = False
            
            # Verificar si existe en venta_boleto_evento
            try:
                venta_boleto_obj = venta_boleto_evento.objects.get(ven_bol_eve_id=venta_id)
                tiene_boletos = True
                print(f"ENCONTRADO en venta_boleto_evento - ID: {venta_id}")
            except venta_boleto_evento.DoesNotExist:
                print(f"NO encontrado en venta_boleto_evento - ID: {venta_id}")
            
            # Verificar si existe en venta_evento
            try:
                venta_evento_obj = venta_evento.objects.get(ven_eve_id=venta_id)
                tiene_productos = True
                print(f"ENCONTRADO en venta_evento - ID: {venta_id}")
            except venta_evento.DoesNotExist:
                print(f"NO encontrado en venta_evento - ID: {venta_id}")
            
            # Determinar el tipo basándose en lo que se encontró
            if tiene_boletos and tiene_productos:
                # Esto NO debería pasar - mismo ID en ambas tablas
                print(f"ERROR: ID {venta_id} encontrado en AMBAS tablas - esto es incorrecto")
                return HttpResponseNotFound("<h1>Error: Venta duplicada en base de datos</h1>")
            elif tiene_boletos:
                print(f"Detectado como venta de BOLETOS para ID: {venta_id}")
            elif tiene_productos:
                print(f"Detectado como venta de PRODUCTOS para ID: {venta_id}")
            else:
                # No se encontró en ninguna tabla
                print(f"ERROR: ID {venta_id} NO encontrado en ninguna tabla")
                return HttpResponseNotFound("<h1>Venta de evento no encontrada</h1>")
            
            if tiene_boletos:
                # Es una venta de boletos
                try:
                    with connection.cursor() as cursor:
                        cursor.execute("SELECT public.obtener_datos_reporte_evento(%s, %s);", [venta_id, 'boleto'])
                        result = cursor.fetchone()
                    if result is None or result[0] is None:
                        raise Exception("Función SQL no devolvió datos")
                    report_data = result[0]
                    report_data['dollar_rate'] = float(get_dollar_exchange_rate())
                    return render(request, 'factura_evento.html', {'report_data': report_data})
                except Exception as e:
                    print(f"Error con función SQL, usando datos directos: {e}")
                    # Fallback: usar datos directos de la base de datos
                    return generar_factura_boleto_manual(request, venta_id)
                
            elif tiene_productos:
                # Es una venta de productos de evento
                try:
                    with connection.cursor() as cursor:
                        cursor.execute("SELECT public.obtener_datos_reporte_evento(%s, %s);", [venta_id, 'producto'])
                        result = cursor.fetchone()
                    if result is None or result[0] is None:
                        raise Exception("Función SQL no devolvió datos")
                    report_data = result[0]
                    report_data['dollar_rate'] = float(get_dollar_exchange_rate())
                    return render(request, 'factura_evento.html', {'report_data': report_data})
                except Exception as e:
                    print(f"Error con función SQL, usando datos directos: {e}")
                    # Fallback: usar datos directos de la base de datos
                    return generar_factura_producto_manual(request, venta_id)

    except Exception as e:
        print(f"Error en vista_factura_directa: {e}")
        return HttpResponse(f"<h1>Error</h1><p>Error interno del servidor: {str(e)}</p>", status=500)

@login_required
def vista_factura_evento_especifica(request, subtipo, venta_id):
    """Vista específica para facturas de eventos que usa el subtipo para determinar la tabla correcta."""
    try:
        # Validar subtipo
        if subtipo not in ['boleto', 'producto']:
            return HttpResponseNotFound("<h1>Subtipo de evento inválido. Use 'boleto' o 'producto'</h1>")

        print(f"=== FACTURA EVENTO ESPECÍFICA ===")
        print(f"Subtipo: {subtipo}")
        print(f"Venta ID: {venta_id}")

        # Verificar que el registro existe en la tabla correcta
        if subtipo == 'boleto':
            try:
                venta_boleto_evento.objects.get(ven_bol_eve_id=venta_id)
                print(f"✅ Confirmado: ID {venta_id} existe en venta_boleto_evento")
            except venta_boleto_evento.DoesNotExist:
                print(f"❌ ERROR: ID {venta_id} NO existe en venta_boleto_evento")
                return HttpResponseNotFound("<h1>Venta de boletos no encontrada</h1>")
        else:  # subtipo == 'producto'
            try:
                venta_evento.objects.get(ven_eve_id=venta_id)
                print(f"✅ Confirmado: ID {venta_id} existe en venta_evento")
            except venta_evento.DoesNotExist:
                print(f"❌ ERROR: ID {venta_id} NO existe en venta_evento")
                return HttpResponseNotFound("<h1>Venta de productos no encontrada</h1>")

        # Usar la función SQL con el tipo correcto
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.obtener_datos_reporte_evento(%s, %s);", [venta_id, subtipo])
                result = cursor.fetchone()
            
            if result is None or result[0] is None:
                raise Exception("Función SQL no devolvió datos")
            
            report_data = result[0]
            report_data['dollar_rate'] = float(get_dollar_exchange_rate())
            print(f"✅ Datos obtenidos correctamente de la función SQL")
            return render(request, 'factura_evento.html', {'report_data': report_data})
            
        except Exception as e:
            print(f"❌ Error con función SQL: {e}")
            # Fallback: usar datos directos de la base de datos
            if subtipo == 'boleto':
                return generar_factura_boleto_manual(request, venta_id)
            else:
                return generar_factura_producto_manual(request, venta_id)

    except Exception as e:
        print(f"ERROR en vista_factura_evento_especifica: {e}")
        return HttpResponse(f"<h1>Error</h1><p>Error interno del servidor: {str(e)}</p>", status=500)

def generar_factura_boleto_manual(request, venta_id):
    """Función auxiliar para generar factura de boletos sin función SQL"""
    try:
        venta = venta_boleto_evento.objects.select_related('fk_evento', 'fk_usuario__fk_cliente').get(ven_bol_eve_id=venta_id)
        
        # Obtener cliente
        if venta.fk_usuario and venta.fk_usuario.fk_cliente:
            cliente = venta.fk_usuario.fk_cliente
            cliente_nombre = f"{cliente.cli_nat_pnombre} {cliente.cli_nat_papellido}" if cliente.cli_nat_pnombre else cliente.cli_jur_razon_social
        else:
            cliente_nombre = "Usuario Evento"
        
        # Construir datos para la factura
        report_data = {
            "venta": {
                "id": venta.ven_bol_eve_id,
                "fecha": venta.ven_bol_eve_fecha_hora.strftime('%d/%m/%Y %H:%M'),
                "tipo_venta": "Venta de Boletos de Evento",
                "subtotal": float(venta.ven_bol_eve_monto_total) / 1.16,
                "iva": float(venta.ven_bol_eve_monto_total) - (float(venta.ven_bol_eve_monto_total) / 1.16),
                "total": float(venta.ven_bol_eve_monto_total)
            },
            "cliente": {
                "nombre": cliente_nombre,
                "rif": getattr(cliente, 'cli_rif', 'N/A') if venta.fk_usuario and venta.fk_usuario.fk_cliente else 'N/A',
                "direccion": getattr(cliente, 'cli_direccion_fisica', 'N/A') if venta.fk_usuario and venta.fk_usuario.fk_cliente else 'N/A',
                "telefono": "N/A"
            },
            "detalles": [{
                "id": venta.ven_bol_eve_id,
                "producto": f"Entrada - {venta.fk_evento.eve_nombre}",
                "cantidad": venta.ven_bol_eve_cantidad,
                "precio_unitario": float(venta.ven_bol_eve_monto_total) / venta.ven_bol_eve_cantidad if venta.ven_bol_eve_cantidad > 0 else float(venta.ven_bol_eve_monto_total),
                "total_linea": float(venta.ven_bol_eve_monto_total)
            }],
            "dollar_rate": float(get_dollar_exchange_rate())
        }
        
        return render(request, 'factura_evento.html', {'report_data': report_data})
        
    except Exception as e:
        return HttpResponseNotFound(f"<h1>Error al generar factura de boletos</h1><p>{e}</p>")

def generar_factura_producto_manual(request, venta_id):
    """Función auxiliar para generar factura de productos sin función SQL"""
    try:
        venta = venta_evento.objects.select_related('fk_cliente', 'fk_evento').get(ven_eve_id=venta_id)
        
        # Obtener cliente
        cliente = venta.fk_cliente
        cliente_nombre = f"{cliente.cli_nat_pnombre} {cliente.cli_nat_papellido}" if cliente.cli_nat_pnombre else cliente.cli_jur_razon_social
        
        # Obtener detalles de productos
        detalles = detalle_venta_evento.objects.filter(fk_venta_evento=venta).select_related(
            'fk_exi_eve__fk_presentacion'
        )
        
        detalles_list = []
        for detalle in detalles:
            detalles_list.append({
                "id": detalle.fk_exi_eve.fk_presentacion.prese_id,
                "producto": f"{detalle.fk_exi_eve.fk_presentacion.prese_nombre} ({venta.fk_evento.eve_nombre})",
                "cantidad": detalle.det_ven_eve_cantidad,
                "precio_unitario": float(detalle.det_ven_eve_precio_unitario),
                "total_linea": float(detalle.det_ven_eve_cantidad * detalle.det_ven_eve_precio_unitario)
            })
        
        # Construir datos para la factura
        report_data = {
            "venta": {
                "id": venta.ven_eve_id,
                "fecha": venta.ven_eve_fecha_hora.strftime('%d/%m/%Y %H:%M'),
                "tipo_venta": "Venta de Productos de Evento",
                "subtotal": float(venta.ven_eve_monto_total) / 1.16,
                "iva": float(venta.ven_eve_monto_total) - (float(venta.ven_eve_monto_total) / 1.16),
                "total": float(venta.ven_eve_monto_total)
            },
            "cliente": {
                "nombre": cliente_nombre,
                "rif": cliente.cli_rif or 'N/A',
                "direccion": cliente.cli_direccion_fisica or 'N/A',
                "telefono": "N/A"
            },
            "detalles": detalles_list,
            "dollar_rate": float(get_dollar_exchange_rate())
        }
        
        return render(request, 'factura_evento.html', {'report_data': report_data})
        
    except Exception as e:
        return HttpResponseNotFound(f"<h1>Error al generar factura de productos</h1><p>{e}</p>")

def eventos_disponibles_view(request):
    """Mostrar todos los eventos disponibles para comprar boletos"""
    eventos = evento.objects.filter(eve_fecha_hora__gte=now()).order_by('eve_fecha_hora')

    context = {
        'eventos': eventos
    }
    return render(request, 'eventos_disponibles.html', context)

def tienda_evento_view(request, evento_id=None):
    """Vista principal de la tienda de eventos con selector y productos"""
    # Si no hay evento seleccionado, mostrar el selector
    if not evento_id:
        # Obtener eventos disponibles (con fecha futura)
        eventos = evento.objects.filter(eve_fecha_hora__gte=timezone.now()).order_by('eve_fecha_hora')
        
        # Agregar información adicional a cada evento
        for ev in eventos:
            ev.precio_bs = convert_price_to_bolivars(ev.eve_precio_boleto)
            
            # Usar función SQL para obtener disponibilidad real
            with connection.cursor() as cursor:
                cursor.execute("SELECT obtener_info_disponibilidad_evento(%s);", [ev.eve_id])
                result = cursor.fetchone()
                if result and result[0]:
                    info_boletos = result[0]
                    ev.boletos_disponibles = info_boletos.get('boletos_disponibles', 0)
                    ev.low_stock = info_boletos.get('stock_bajo', False)
                else:
                    ev.boletos_disponibles = 0
                    ev.low_stock = False
            
            # Contar productos disponibles para este evento
            productos_count = existencia_evento.objects.filter(
                fk_evento_proveedor__fk_evento=ev
            ).count()
            ev.productos_disponibles = productos_count
        
        context = {
            'eventos': eventos,
            'selector_mode': True,
            'cartItems': 0  # Por defecto
        }
        return render(request, 'tienda_evento.html', context)
    
    # Si hay evento seleccionado, mostrar productos
    try:
        evento_obj = evento.objects.get(pk=evento_id)
    except evento.DoesNotExist:
        messages.error(request, 'El evento solicitado no existe.')
        return redirect('tienda_evento')
    
    # Verificar que el evento esté disponible
    if evento_obj.eve_fecha_hora < timezone.now():
        messages.warning(request, 'Este evento ya ha pasado.')
        return redirect('tienda_evento')
    
    # Obtener datos del carrito
    data = cart_data(request, tipo='venta_evento')
    
    # Obtener productos del evento
    productos = []
    
    # 1. Agregar las entradas/boletos como un producto especial
    # Obtener información actualizada de disponibilidad usando SQL
    with connection.cursor() as cursor:
        cursor.execute("SELECT obtener_info_disponibilidad_evento(%s);", [evento_obj.eve_id])
        result = cursor.fetchone()
        
        if result and result[0]:
            info_boletos = result[0]
            boletos_disponibles = info_boletos.get('boletos_disponibles', 0)
            boletos_vendidos = info_boletos.get('boletos_vendidos', 0)
            boletos_totales = info_boletos.get('boletos_totales', evento_obj.eve_nro_boletos)
        else:
            boletos_disponibles = 0
            boletos_vendidos = 0
            boletos_totales = evento_obj.eve_nro_boletos
    
    if boletos_disponibles > 0:
        entrada_producto = {
            'id': f'boleto_{evento_obj.eve_id}',
            'nombre': f'Entrada - {evento_obj.eve_nombre}',
            'tipo': 'boleto',
            'precio_usd': evento_obj.eve_precio_boleto,
            'precio_bs': convert_price_to_bolivars(evento_obj.eve_precio_boleto),
            'cantidad_disponible': boletos_disponibles,
            'imagen': None,  # Usar imagen por defecto
            'es_entrada': True,
            'evento_id': evento_obj.eve_id,
            'boletos_vendidos': boletos_vendidos,
            'boletos_totales': boletos_totales
        }
        productos.append(entrada_producto)
    
    # 2. Obtener productos del evento desde existencia_evento
    existencias = existencia_evento.objects.filter(
        fk_evento_proveedor__fk_evento=evento_obj
    ).select_related('fk_presentacion', 'fk_evento_proveedor__fk_proveedor')
    
    for existencia in existencias:
        presentacion_obj = existencia.fk_presentacion
        
        # Usar el precio base del producto
        precio_usd = presentacion_obj.prese_precio
        precio_bs = convert_price_to_bolivars(precio_usd)
        
        producto_data = {
            'id': f'producto_{existencia.exi_eve_id}',
            'existencia_id': existencia.exi_eve_id,
            'presentacion': presentacion_obj,
            'nombre': presentacion_obj.prese_nombre,
            'tipo': 'producto',
            'precio_usd': precio_usd,
            'precio_bs': precio_bs,
            'cantidad_disponible': existencia.exi_eve_cantidad,
            'imagen': presentacion_obj.get_imagen_url() if presentacion_obj.prese_imagen else None,
            'es_entrada': False,
            'proveedor': existencia.fk_evento_proveedor.fk_proveedor.pro_razon_social
        }
        productos.append(producto_data)
    
    # Información del evento para el header
    evento_info = {
        'id': evento_obj.eve_id,
        'nombre': evento_obj.eve_nombre,
        'descripcion': evento_obj.eve_descripcion,
        'fecha': evento_obj.eve_fecha_hora,
        'lugar': evento_obj.fk_lugar.lug_nombre if evento_obj.fk_lugar else 'Por definir',
        'total_productos': len(productos),
        'boletos_disponibles': boletos_disponibles,
        'boletos_vendidos': boletos_vendidos,
        'boletos_totales': boletos_totales
    }
    
    context = {
        'evento': evento_info,
        'productos': productos,
        'cartItems': data['cartItems'],
        'selector_mode': False,
        'dollar_rate': get_dollar_exchange_rate()
    }
    
    return render(request, 'tienda_evento.html', context)

@csrf_exempt
def update_cart_evento(request):
    """Actualizar carrito específico para eventos (productos y boletos)"""
    try:
        data = json.loads(request.body)
        item_id = data.get('itemId', '').strip()
        action = data.get('action')
        force_clear = data.get('forceClear', False)  # Para limpiar carrito cuando se cambie de evento
        
        if not item_id:
            return JsonResponse({'status': 'error', 'message': 'ID de producto inválido'}, status=400)
        
        cart = request.session.get('cart_venta_evento', {})
        
        # Si se solicita limpiar el carrito
        if force_clear:
            cart = {}
            request.session['cart_venta_evento'] = cart
            request.session.modified = True
            return JsonResponse({
                'status': 'cleared',
                'message': 'Carrito limpiado',
                'cartItems': 0
            })
        
        # Verificar restricción de un evento por carrito
        if action == 'add' and cart:
            evento_actual = None
            
            # Obtener el evento del producto que se quiere agregar
            if item_id.startswith('boleto_'):
                evento_actual = int(item_id.replace('boleto_', ''))
            elif item_id.startswith('producto_'):
                existencia_id = int(item_id.replace('producto_', ''))
                existencia = existencia_evento.objects.select_related('fk_evento_proveedor__fk_evento').get(exi_eve_id=existencia_id)
                evento_actual = existencia.fk_evento_proveedor.fk_evento.eve_id
            
            # Verificar si hay productos de otros eventos en el carrito
            for existing_item_id in cart.keys():
                evento_en_carrito = None
                
                if existing_item_id.startswith('boleto_'):
                    evento_en_carrito = int(existing_item_id.replace('boleto_', ''))
                elif existing_item_id.startswith('producto_'):
                    try:
                        existing_existencia_id = int(existing_item_id.replace('producto_', ''))
                        existing_existencia = existencia_evento.objects.select_related('fk_evento_proveedor__fk_evento').get(exi_eve_id=existing_existencia_id)
                        evento_en_carrito = existing_existencia.fk_evento_proveedor.fk_evento.eve_id
                    except existencia_evento.DoesNotExist:
                        continue
                
                # Si hay productos de otro evento, devolver aviso
                if evento_en_carrito and evento_en_carrito != evento_actual:
                    evento_en_carrito_obj = evento.objects.get(eve_id=evento_en_carrito)
                    evento_actual_obj = evento.objects.get(eve_id=evento_actual)
                    
                    return JsonResponse({
                        'status': 'confirm_required',
                        'message': f'Ya tienes productos del evento "{evento_en_carrito_obj.eve_nombre}" en tu carrito. ¿Deseas vaciar el carrito y agregar productos de "{evento_actual_obj.eve_nombre}"?',
                        'current_event': evento_en_carrito_obj.eve_nombre,
                        'new_event': evento_actual_obj.eve_nombre
                    })
        
        if action == 'clear':
            # Limpiar todo el carrito
            cart = {}
            request.session['cart_venta_evento'] = cart
            request.session.modified = True
            return JsonResponse({
                'status': 'cleared',
                'message': 'Carrito limpiado',
                'cartItems': 0
            })
            
        elif action == 'add':
            # Verificar disponibilidad según el tipo
            if item_id.startswith('boleto_'):
                # Es una entrada/boleto
                evento_id = int(item_id.replace('boleto_', ''))
                
                current_quantity = cart.get(item_id, 0)
                nueva_cantidad = current_quantity + 1
                
                # Validar disponibilidad usando función SQL
                with connection.cursor() as cursor:
                    cursor.execute("SELECT validar_compra_boletos(%s, %s);", [evento_id, nueva_cantidad])
                    result = cursor.fetchone()
                    
                    if result and result[0]:
                        validacion = result[0]
                        if not validacion.get('valido', False):
                            return JsonResponse({
                                'status': 'error',
                                'message': validacion.get('mensaje', 'No hay suficientes boletos disponibles')
                            }, status=400)
                    else:
                        return JsonResponse({
                            'status': 'error',
                            'message': 'Error al validar disponibilidad'
                        }, status=500)
                
                cart[item_id] = nueva_cantidad
                
            elif item_id.startswith('producto_'):
                # Es un producto del evento
                existencia_id = int(item_id.replace('producto_', ''))
                existencia = existencia_evento.objects.get(exi_eve_id=existencia_id)
                
                current_quantity = cart.get(item_id, 0)
                if current_quantity + 1 > existencia.exi_eve_cantidad:
                    return JsonResponse({
                        'status': 'error',
                        'message': f'No hay suficiente stock. Disponible: {existencia.exi_eve_cantidad}'
                    }, status=400)
                
                cart[item_id] = current_quantity + 1
                
        elif action == 'remove':
            if item_id in cart:
                cart[item_id] -= 1
                if cart[item_id] <= 0:
                    del cart[item_id]
        
        request.session['cart_venta_evento'] = cart
        request.session.modified = True
        
        # Calcular total de items
        total_items = sum(cart.values())
        
        return JsonResponse({
            'status': 'ok',
            'cartItems': total_items,
            'message': 'Carrito actualizado correctamente'
        })
        
    except evento.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'Evento no encontrado'}, status=404)
    except existencia_evento.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'Producto no encontrado'}, status=404)
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': f'Error: {str(e)}'}, status=500)

def cart_data_evento(request):
    """Función especializada para el carrito de eventos"""
    cart = request.session.get('cart_venta_evento', {})
    items = []
    total_usd = 0
    total_items = 0
    dollar_rate = get_dollar_exchange_rate()
    
    for item_id, quantity in cart.items():
        try:
            if item_id.startswith('boleto_'):
                # Es una entrada/boleto
                evento_id = int(item_id.replace('boleto_', ''))
                evento_obj = evento.objects.get(eve_id=evento_id)
                
                precio_usd = evento_obj.eve_precio_boleto
                precio_bs = convert_price_to_bolivars(precio_usd)
                subtotal_usd = precio_usd * quantity
                subtotal_bs = precio_bs * quantity
                
                item_data = {
                    'id': item_id,  # Usar el item_id completo (boleto_X)
                    'tipo': 'boleto',
                    'nombre': f'Entrada - {evento_obj.eve_nombre}',
                    'evento': evento_obj,
                    'quantity': quantity,
                    'precio_unitario': float(precio_usd),
                    'precio_unitario_bs': float(precio_bs),
                    'get_total': float(subtotal_usd),
                    'get_total_bs': float(subtotal_bs),
                    'imagen': None,
                    'es_entrada': True
                }
                items.append(item_data)
                
            elif item_id.startswith('producto_'):
                # Es un producto del evento
                existencia_id = int(item_id.replace('producto_', ''))
                existencia = existencia_evento.objects.select_related(
                    'fk_presentacion',
                    'fk_evento_proveedor__fk_evento'
                ).get(exi_eve_id=existencia_id)
                
                presentacion_obj = existencia.fk_presentacion
                precio_usd = presentacion_obj.prese_precio
                precio_bs = convert_price_to_bolivars(precio_usd)
                subtotal_usd = precio_usd * quantity
                subtotal_bs = precio_bs * quantity
                
                item_data = {
                    'id': item_id,  # Usar el item_id completo (producto_X)
                    'tipo': 'producto',
                    'nombre': presentacion_obj.prese_nombre,
                    'presentacion': presentacion_obj,
                    'existencia': existencia,
                    'quantity': quantity,
                    'precio_unitario': float(precio_usd),
                    'precio_unitario_bs': float(precio_bs),
                    'get_total': float(subtotal_usd),
                    'get_total_bs': float(subtotal_bs),
                    'imagen': presentacion_obj.get_imagen_url() if presentacion_obj.prese_imagen else None,
                    'es_entrada': False
                }
                items.append(item_data)
            
            total_usd += subtotal_usd
            total_items += quantity
            
        except (evento.DoesNotExist, existencia_evento.DoesNotExist):
            continue
    
    total_bs = convert_price_to_bolivars(total_usd)
    
    order = {
        'get_cart_total': float(total_usd),
        'get_cart_total_usd': float(total_usd),
        'get_cart_total_bs': float(total_bs),
        'get_cart_items': total_items,
        'shipping': False,
        'dollar_rate': float(dollar_rate)
    }
    
    return {
        'items': items,
        'order': order,
        'cartItems': total_items
    }

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