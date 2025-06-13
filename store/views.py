# views.py adaptado solo al modelo User de Django

from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse
import json
import datetime
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from .utils import cookieCart, cartData, guestOrder

# VISTAS DE TIENDA
def store(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    products = []  # Ajustar cuando se integre el modelo correcto de producto
    context = {'products': products, 'cartItems': cartItems}
    return render(request, 'store.html', context)

def cart(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    context = {'items': items, 'order': order, 'cartItems': cartItems}
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
    transaction_id = datetime.datetime.now().timestamp()
    data = json.loads(request.body)

    return JsonResponse('Payment submitted...', safe=False)

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
