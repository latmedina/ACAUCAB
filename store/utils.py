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

def registrar_usuario_via_sql(username, password, email, fk_cliente=None, fk_proveedor=None, first_name='', last_name='', is_staff=False, is_superuser=False):
    hashed_password = make_password(password)
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT registrar_usuario(%s, %s, %s, %s, %s, %s, %s, %s, %s);
        """, [username, hashed_password, email, first_name, last_name, is_superuser, is_staff, fk_cliente, fk_proveedor])