import json
from .models import *
from django.contrib.auth.hashers import make_password
from django.db import connection

def sessionCart(request):
    cart = request.session.get('cart', {})
    items = []
    order = {'get_cart_total': 0, 'get_cart_items': 0}
    cartItems = 0

    for prese_id_str, quantity in cart.items():
        try:
            product = Presentacion.objects.get(prese_id=int(prese_id_str))
            price = product.prese_precio or 0
            subtotal = price * quantity

            item = {
                'product': product,
                'quantity': quantity,
                'get_total': subtotal
            }

            items.append(item)
            cartItems += quantity
            order['get_cart_total'] += subtotal
            order['get_cart_items'] += quantity
        except Presentacion.DoesNotExist:
            continue

    return {'cartItems': cartItems, 'order': order, 'items': items}

def cartData(request):
    cart = request.session.get('cart', {})
    items = []
    order = {'get_cart_total': 0, 'get_cart_items': 0}
    cartItems = 0

    for prese_id_str, quantity in cart.items():
        if not prese_id_str.strip().isdigit():  # ← evita errores con claves vacías o inválidas
            continue

        try:
            product = Presentacion.objects.get(prese_id=int(prese_id_str))
            price = product.prese_precio or 0
            subtotal = price * quantity

            item = {
                'product': product,
                'quantity': quantity,
                'get_total': subtotal
            }

            items.append(item)
            cartItems += quantity
            order['get_cart_total'] += subtotal
            order['get_cart_items'] += quantity
        except Presentacion.DoesNotExist:
            continue

    return {'cartItems': cartItems, 'order': order, 'items': items}



def guestOrder(request, data):
	name = data['form']['name']
	email = data['form']['email']
	cookieData = cookieCart(request)
	items = cookieData['items']

	# Puedes implementar una tabla para guardar info de clientes si quieres persistencia
	# Por ahora simulamos que se guarda
	print(f"Simulando creación de pedido para invitado: {name} - {email}")
	
	return None, None

def crear_usuario_sql(username, email, password, tipo, id_entidad, emp_car_id=None, first_name='', last_name=''):
    hashed_password = make_password(password)
    with connection.cursor() as cursor:
        cursor.callproc('registrar_usuario', [
            username,
            email,
            hashed_password,
            tipo,
            id_entidad,
            emp_car_id,
            first_name,
            last_name
        ])

def modificar_usuario_sql(id_usuario, username, email, password, first_name, last_name):
    if password:
        password = make_password(password)
    with connection.cursor() as cursor:
        cursor.callproc('modificar_usuario', [
            id_usuario,
            username,
            email,
            password,
            first_name,
            last_name
        ])

def eliminar_usuario_sql(id_usuario):
    print(f"Llamando procedimiento eliminar_usuario con ID: {id_usuario}")
    with connection.cursor() as cursor:
        cursor.callproc('eliminar_usuario', [id_usuario])


