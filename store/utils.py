import json
from .models import *

def cookieCart(request):
	try:
		cart = json.loads(request.COOKIES['cart'])
	except:
		cart = {}

	items = []
	order = {'get_cart_total': 0, 'get_cart_items': 0, 'shipping': False}
	cartItems = order['get_cart_items']

	for i in cart:
		try:
			cartItems += cart[i]['quantity']

			product = Product.objects.get(id=i)
			total = (product.price * cart[i]['quantity'])

			order['get_cart_total'] += total
			order['get_cart_items'] += cart[i]['quantity']

			item = {
				'id': product.id,
				'product': {
					'id': product.id,
					'name': product.name,
					'price': product.price,
					'imageURL': product.imageURL
				},
				'quantity': cart[i]['quantity'],
				'digital': product.digital,
				'get_total': total,
			}
			items.append(item)

			if not product.digital:
				order['shipping'] = True
		except:
			pass
			
	return {'cartItems': cartItems, 'order': order, 'items': items}


def cartData(request):
	if request.user.is_authenticated:
		# Puedes extender esta lógica si conectas productos o carritos a usuarios
		# Por ahora tratamos igual que visitantes
		return cookieCart(request)
	else:
		return cookieCart(request)


def guestOrder(request, data):
	name = data['form']['name']
	email = data['form']['email']
	cookieData = cookieCart(request)
	items = cookieData['items']

	# Puedes implementar una tabla para guardar info de clientes si quieres persistencia
	# Por ahora simulamos que se guarda
	print(f"Simulando creación de pedido para invitado: {name} - {email}")
	
	return None, None
