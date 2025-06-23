from django.shortcuts import render, redirect
from django.http import JsonResponse
import json
from django.utils import timezone
from django.contrib.auth.models import User, Group
from .models import (
    presentacion, venta_online, detalle_venta_online, pre_alm, 
    metodo_pago, pago, moneda, historico_moneda, tienda, 
    inventario, venta_fisica, detalle_venta_fisica
)
from django.db import connection
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from .forms import CustomUserCreationForm
from django.views.decorators.csrf import csrf_exempt
from decimal import Decimal
from datetime import datetime, date
from .utils import registrar_usuario_via_sql

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
def cart_data(request, tipo='online'):
    """Función generalizada para carrito físico y online"""
    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})
    items, total_usd, total_items = [], 0, 0
    dollar_rate = get_dollar_exchange_rate()

    for product_id, quantity in cart.items():
        try:
            producto = presentacion.objects.get(pk=int(product_id))
            prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
            if not prealm:
                continue
            precio_usd = prealm.pre_alm_precio  # Precio en dólares (base en BD)
            precio_bs = convert_price_to_bolivars(precio_usd)  # Precio en bolívares para mostrar
            subtotal_usd = precio_usd * quantity  # Subtotal en dólares (para cálculos internos)
            subtotal_bs = precio_bs * quantity  # Subtotal en bolívares (para mostrar)

            items.append({
                'product': producto,
                'quantity': quantity,
                'get_total': subtotal_usd,  # Total en dólares (base)
                'get_total_bs': subtotal_bs,  # Total en bolívares para mostrar
                'precio_unitario': precio_usd,  # Precio unitario en dólares
                'precio_unitario_bs': precio_bs,  # Precio unitario en bolívares
                'precio_unitario_usd': precio_usd,  # Para compatibilidad con templates
                'prealm': prealm
            })
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
        'cartItems': total_items
    }

# VISTAS DE TIENDA
def redirect_store(request):
    """Redirecciona a la tienda online por defecto"""
    return redirect('store_view', tipo='online')

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

def store_view(request, tipo='online'):
    """Vista general de tienda (física/online)"""
    data = cart_data(request, tipo)
    productos = presentacion.objects.all()
    for p in productos:
        prealm = pre_alm.objects.filter(fk_presentacion=p).first()
        if prealm:
            p.precio_usd = prealm.pre_alm_precio
            p.precio_bs = convert_price_to_bolivars(prealm.pre_alm_precio)
            p.disponible = prealm.pre_alm_cantidad > 0
        else:
            p.precio_usd = 0
            p.precio_bs = 0
            p.disponible = False

    template = 'tienda_fisica.html' if tipo == 'fisica' else 'store.html'
    return render(request, template, {
        'products': productos,
        'cartItems': data['cartItems'],
        'tipo': tipo,
        'dollar_rate': get_dollar_exchange_rate()
    })

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
    """Actualizar carrito generalizado (física/online)"""
    data = json.loads(request.body)
    product_id = str(data.get('productId', '')).strip()
    action = data.get('action')

    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})

    if action == 'add':
        cart[product_id] = cart.get(product_id, 0) + 1
    elif action == 'remove' and cart.get(product_id):
        cart[product_id] -= 1
        if cart[product_id] <= 0:
            del cart[product_id]

    request.session[cart_key] = cart
    total_items = sum(q for _, q in cart.items() if str(q).isdigit())
    return JsonResponse({'status': 'ok', 'cartItems': total_items})

# VISTAS DE CARRITO
def cart_view(request, tipo='online'):
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

def checkout_view(request, tipo='online'):
    """Vista de checkout generalizada"""
    data = cart_data(request, tipo)
    return render(request, 'checkout.html', {
        'items': data['items'],
        'order': data['order'],
        'cartItems': data['cartItems'],
        'tipo': tipo,
    })

# PROCESAR ÓRDENES
def processOrder(request):
    """Procesar orden básica (original)"""
    data = json.loads(request.body)
    cart = request.session.get('cart', {})

    if not cart:
        return JsonResponse({'status': 'error', 'message': 'Carrito vacío'}, status=400)

    total_venta = 0
    detalles = []

    for product_id, cantidad in cart.items():
        try:
            producto = presentacion.objects.get(prese_id=int(product_id))
            prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
            if not prealm:
                continue
            precio_unitario = prealm.pre_alm_precio or 0
            total_venta += precio_unitario * cantidad
            detalles.append({
                'producto': producto,
                'cantidad': cantidad,
                'precio_unitario': precio_unitario,
                'prealm': prealm
            })
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
    request.session['pending_tipo'] = 'online'  # Tipo por defecto para compatibilidad
    # NO limpiar el carrito aquí - se limpiará después del pago exitoso

    return JsonResponse({
        'status': 'ok', 
        'message': 'Venta registrada', 
        'venta_id': venta.ven_onl_id,
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
        # Lógica para venta física
        detalles, total_venta = [], 0
        for pid, cantidad in cart.items():
            try:
                producto = presentacion.objects.get(pk=int(pid))
                # Para venta física, necesitamos buscar en inventario
                inventario_item = inventario.objects.filter(fk_presentacion=producto).first()
                if not inventario_item or inventario_item.inv_cantidad < cantidad:
                    continue
                
                # El precio lo obtenemos del pre_alm
                prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
                if not prealm:
                    continue
                
                detalles.append({
                    'producto': producto, 
                    'inventario': inventario_item,
                    'prealm': prealm,
                    'cantidad': cantidad
                })
                
                subtotal = prealm.pre_alm_precio * cantidad
                total_venta += subtotal
            except presentacion.DoesNotExist:
                continue

        if total_venta <= 0:
            return JsonResponse({'status': 'error', 'message': 'Venta inválida'}, status=400)

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
                det_ven_fis_precio_unitario=d['prealm'].pre_alm_precio
            )

        # Guardar el ID de venta en la sesión para usar en el método de pago
        request.session['pending_venta_id'] = venta.ven_fis_id
        venta_id = venta.ven_fis_id
        
    else:
        # Lógica para venta online (original)
        detalles, total_venta = [], 0
        for pid, cantidad in cart.items():
            try:
                producto = presentacion.objects.get(pk=int(pid))
                prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
                if not prealm:
                    continue
                
                detalles.append({
                    'producto': producto, 
                    'prealm': prealm,
                    'cantidad': cantidad
                })
                
                subtotal = prealm.pre_alm_precio * cantidad
                total_venta += subtotal
            except presentacion.DoesNotExist:
                continue

        if total_venta <= 0:
            return JsonResponse({'status': 'error', 'message': 'Venta inválida'}, status=400)

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
    pending_tipo = request.session.get('pending_tipo', 'online')
    
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
        pending_tipo = request.session.get('pending_tipo', 'online')
        
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

def registro(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password1']
            email = form.cleaned_data['email']
            first_name = form.cleaned_data.get('first_name', '')
            last_name = form.cleaned_data.get('last_name', '')
            fk_cliente = form.cleaned_data['fk_cliente']
            fk_proveedor = form.cleaned_data['fk_proveedor']
            

            # Convertir a IDs o None
            fk_cliente_id = fk_cliente.cli_id if fk_cliente else None
            fk_proveedor_id = fk_proveedor.pro_id if fk_proveedor else None

            # Llamar al stored procedure
            registrar_usuario_via_sql(
                        username=username,
                        password=password,
                        email=email,
                        first_name=first_name,
                        last_name=last_name,
                        fk_cliente=fk_cliente_id,
                        fk_proveedor=fk_proveedor_id
                    )

            # Autenticar y loguear
            user = authenticate(request, username=username, password=password)
            if user:
                login(request, user)
                grupo_cliente, _ = Group.objects.get_or_create(name='Cliente')
                user.groups.add(grupo_cliente)
                return redirect('home')
            else:
                return render(request, 'registro.html', {
                    'form': form,
                    'error': 'Usuario creado pero no se pudo autenticar.'
                })
    else:
        form = CustomUserCreationForm()
    return render(request, 'registro.html', {'form': form})
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