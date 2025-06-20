# views.py adaptado solo al modelo User de Django

from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse
import json
from django.utils import timezone
from django.contrib.auth.models import User, Group
from .models import presentacion, venta_online, detalle_venta_online, pre_alm
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from .utils import cartData, guestOrder
from django.views.decorators.csrf import csrf_exempt
from store.models import tienda

# VISTAS DE TIENDA
def store(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    products = presentacion.objects.all()
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

def cartData(request):
    cart = request.session.get('cart', {})
    items = []
    total = 0
    total_items = 0

    for product_id, quantity in cart.items():
        try:
            product = presentacion.objects.get(prese_id=int(product_id))
            prealm = pre_alm.objects.filter(fk_presentacion=product).first()
            if not prealm:
                continue

            precio = prealm.pre_alm_precio
            subtotal = precio * quantity

            item = {
                'product': product,
                'quantity': quantity,
                'get_total': subtotal,
                'precio_unitario': precio,
            }
            items.append(item)
            total += subtotal
            total_items += quantity
        except presentacion.DoesNotExist:
            continue

    order = {
        'get_cart_total': total,
        'get_cart_items': total_items,
        'shipping': False  # si estás usando esta bandera en JS
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
