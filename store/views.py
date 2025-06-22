from django.shortcuts import render, redirect
from django.http import JsonResponse
import json
from django.utils import timezone
from django.contrib.auth.models import Group
from django.contrib.auth import authenticate, login, logout, get_user_model
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.views.decorators.csrf import csrf_exempt

from .models import (
    presentacion, venta_online, detalle_venta_online,
    venta_fisica, detalle_venta_fisica, pre_alm, tienda,inventario
)

def redirect_store(request):
    return redirect('store', tipo='online')

# FUNCION AUXILIAR GENERALIZADA
def cart_data(request, tipo='online'):
    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})
    items, total, total_items = [], 0, 0

    for product_id, quantity in cart.items():
        try:
            producto = presentacion.objects.get(pk=int(product_id))
            prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
            if not prealm:
                continue
            precio = prealm.pre_alm_precio
            subtotal = precio * quantity

            items.append({
                'product': producto,
                'quantity': quantity,
                'get_total': subtotal,
                'precio_unitario': precio,
                'prealm': prealm
            })
            total += subtotal
            total_items += quantity
        except presentacion.DoesNotExist:
            continue

    return {
        'items': items,
        'order': {
            'get_cart_total': total,
            'get_cart_items': total_items,
            'shipping': False
        },
        'cartItems': total_items
    }

def cart_view(request, tipo='online'):
    data = cart_data(request, tipo)
    return render(request, 'cart.html', {
        'items': data['items'],
        'order': data['order'],
        'cartItems': data['cartItems'],
        'tipo': tipo,  # ⚠️ muy importante para los botones y URLs dinámicas
    })

# VISTA GENERAL DE TIENDA
def store_view(request, tipo='online'):
    data = cart_data(request, tipo)
    productos = presentacion.objects.all()
    for p in productos:
        prealm = pre_alm.objects.filter(fk_presentacion=p).first()
        p.get_precio_actual = prealm.pre_alm_precio if prealm else None

    template = 'tienda_fisica.html' if tipo == 'fisica' else 'store.html'
    return render(request, template, {
        'products': productos,
        'cartItems': data['cartItems'],
        'tipo': tipo,
    })

# ACTUALIZAR CARRITO
@csrf_exempt
def update_cart_view(request, tipo):  # 👈 Agrega "tipo" aquí
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

# CHECKOUT
def checkout_view(request, tipo='online'):
    data = cart_data(request, tipo)
    contexto = {
        'items': data['items'],
        'order': data['order'],
        'cartItems': data['cartItems'],
        'tipo': tipo,
    }

    return render(request, 'checkout.html', contexto)

# PROCESAR ORDEN GENERALIZADA
@csrf_exempt
def process_order_view(request, tipo):
    if request.method != 'POST':
        return JsonResponse({'status': 'error'}, status=400)

    data = json.loads(request.body)
    tipo = data.get('tipo', 'online')
    cart_key = 'cart_fisica' if tipo == 'fisica' else 'cart'
    cart = request.session.get(cart_key, {})

    detalles, total_venta = [], 0
    for pid, cantidad in cart.items():
        try:
            producto = presentacion.objects.get(pk=int(pid))
            prealm = pre_alm.objects.filter(fk_presentacion=producto).first()
            inventario_obj = inventario.objects.filter(fk_presentacion=producto).first()
            if not prealm or not inventario_obj:
                continue
            subtotal = prealm.pre_alm_precio * cantidad
            total_venta += subtotal
            detalles.append({'producto': producto, 'prealm': prealm,'inventario': inventario_obj, 'cantidad': cantidad})
        except presentacion.DoesNotExist:
            continue

    if total_venta <= 0:
        return JsonResponse({'status': 'error', 'message': 'Venta inválida'}, status=400)

    tienda_obj = tienda.objects.first()

    if tipo == 'fisica':
        cliente_obj = getattr(request.user, 'fk_cliente', None)
        if not cliente_obj:
            return JsonResponse({'status': 'error', 'message': 'Este usuario no tiene un cliente asignado'}, status=400)
        venta = venta_fisica.objects.create(
            ven_fis_fecha=timezone.now(),
            ven_fis_total=total_venta,
            fk_tienda=tienda_obj,
            fk_cliente=cliente_obj
        )
        for d in detalles:
            detalle_venta_fisica.objects.create(
                fk_venta_fisica=venta,
                fk_inventario=d['inventario'],
                det_ven_fis_cantidad=d['cantidad'],
                det_ven_fis_precio_unitario=d['prealm'].pre_alm_precio
            )
    else:
        venta = venta_online.objects.create(
            ven_onl_fecha=timezone.now(),
            ven_onl_total=total_venta,
            fk_usuario=request.user,
            fk_tienda=tienda_obj
        )
        for d in detalles:
            detalle_venta_online.objects.create(
                fk_venta_online=venta,
                fk_pre_alm=d['prealm'],
                det_ven_onl_cantidad=d['cantidad'],
                det_ven_onl_precio=d['prealm'].pre_alm_precio
            )

    request.session[cart_key] = {}
    return JsonResponse({'status': 'ok', 'message': 'Venta registrada'})

# LOGIN
def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user:
            login(request, user)
            return redirect('home')
        else:
            return render(request, 'login.html', {'error': 'Credenciales inválidas'})
    return render(request, 'login.html')

# LOGOUT
def logout_view(request):
    logout(request)
    return redirect('login')

# REGISTRO
def registro(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            usuario = form.save()
            grupo_cliente, _ = Group.objects.get_or_create(name='Cliente')
            usuario.groups.add(grupo_cliente)
            login(request, usuario)
            return redirect('home')
    else:
        form = UserCreationForm()
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