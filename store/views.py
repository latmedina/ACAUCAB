# views.py adaptado solo al modelo User de Django

from django.shortcuts import render, redirect
from .models import Presentacion
from django.http import JsonResponse, HttpResponse
import json
from django.utils import timezone
from django.contrib.auth.models import User, Group
from .models import Presentacion, HistoricoPrecioCerveza, VentaOnline, DetalleVentaOnline
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from .utils import cartData, guestOrder
from django.views.decorators.csrf import csrf_exempt

# VISTAS DE TIENDA
def store(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    products = Presentacion.objects.all()
    context = {'products': products, 'cartItems': cartItems}
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



def cart_view(request):
    cart = request.session.get('cart', {})
    items = []
    total = 0
    total_items = 0

    for product_id, quantity in cart.items():
        if not product_id.strip():
            continue  # Ignora claves vacías

        try:
            product = Presentacion.objects.get(prese_id=int(product_id))
            precio = product.precio_actual
            if precio is None:
                continue  # Si no hay precio, no mostrar

            subtotal = precio * quantity
            item = {
                'product': product,
                'quantity': quantity,
                'get_total': subtotal,
            }
            items.append(item)
            total += subtotal
            total_items += quantity
        except Presentacion.DoesNotExist:
            continue

    order = {
        'get_cart_total': total,
        'get_cart_items': total_items,
    }

    context = {'items': items, 'order': order}
    return render(request, 'cart.html', context)

def checkout(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    context = {'items': items, 'order': order, 'cartItems': cartItems}
    return render(request, 'checkout.html', context)

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

    for product_id, cantidad in cart.items():
        if not product_id.strip().isdigit():
            continue  # ⚠️ Evita IDs vacíos o inválidos que rompen int()

        try:
            producto = Presentacion.objects.get(prese_id=int(product_id))
            precio_unitario = producto.precio_actual or 0
            subtotal = precio_unitario * cantidad

            total_venta += subtotal

            detalles.append({
                'producto': producto,
                'cantidad': cantidad,
                'precio_unitario': precio_unitario
            })

        except Presentacion.DoesNotExist:
            continue

    # Crear venta
    venta = VentaOnline.objects.create(
        ven_onl_fecha=timezone.now(),
        ven_onl_total=total_venta
    )

    # Crear detalles
    for item in detalles:
        DetalleVentaOnline.objects.create(
            venta=venta,
            det_ven_onl_cantidad=item['cantidad'],
            det_ven_onl_precio_unitario=item['precio_unitario']
        )

    # Limpiar carrito
    request.session['cart'] = {}

    return JsonResponse({'status': 'ok', 'message': 'Venta registrada', 'venta_id': venta.ven_onl_id})
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
