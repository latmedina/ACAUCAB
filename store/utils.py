import json
from .models import *

def sessionCart(request):
    cart = request.session.get('cart', {})
    items = []
    order = {'get_cart_total': 0, 'get_cart_items': 0}
    cartItems = 0

    for prese_id_str, quantity in cart.items():
        try:
            product = Presentacion.objects.get(prese_id=int(prese_id_str))
            price = product.precio_actual or 0
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
            price = product.precio_actual or 0
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
