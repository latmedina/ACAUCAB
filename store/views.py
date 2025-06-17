from django.shortcuts import render
from django.http import JsonResponse
import json
import datetime
from .models import *
from .utils import cookieCart, cartData, guestOrder

# Create your views here.

def store(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    products = Product.objects.all()
    context = {'products':products, 'cartItems':cartItems}
    return render(request, 'store.html', context)


def cart(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    context = {'items':items, 'order':order, 'cartItems':cartItems}
    return render(request, 'cart.html', context)

def checkout(request):
    data = cartData(request)
    cartItems = data['cartItems']
    order = data['order']
    items = data['items']

    context = {'items':items, 'order':order, 'cartItems':cartItems}
    return render(request, 'checkout.html', context)

def updateItem(request):
	data = json.loads(request.body)
	productId = data['productId']
	action = data['action']
	print('Action:', action)
	print('Product:', productId)

	customer = request.user.customer
	product = Product.objects.get(id=productId)
	order, created = Order.objects.get_or_create(customer=customer, complete=False)

	orderItem, created = OrderItem.objects.get_or_create(order=order, product=product)

	if action == 'add':
		orderItem.quantity = (orderItem.quantity + 1)
	elif action == 'remove':
		orderItem.quantity = (orderItem.quantity - 1)

	orderItem.save()

	if orderItem.quantity <= 0:
		orderItem.delete()

	return JsonResponse('Item was added', safe=False)

def processOrder(request):
    transaction_id = datetime.datetime.now().timestamp()
    data = json.loads(request.body)

    if request.user.is_authenticated:
        customer = request.user.customer
        order, created = Order.objects.get_or_create(customer=customer, complete=False)
        total = float(data['Form]']['total'])
        order.transaction_id = transaction_id

        if total == order.get_cart_total:
            order.complete = True
        order.save()

        if order.shipping == True:
            ShippingAddress.objects.create(
                customer=customer,
                order=order,
                address=data['shipping']['address'],
                city=data['shipping']['city'],
                state=data['shipping']['state'],
                zipcode=data['shipping']['zipcode'],
            )
    else:

        customer, order = guestOrder(request, data)
        total = float(data['Form]']['total'])
        order.transaction_id = transaction_id

        if total == order.get_cart_total:
            order.complete = True
        order.save()

        if order.shipping == True:
            ShippingAddress.objects.create(
                customer=customer,
                order=order,
                address=data['shipping']['address'],
                city=data['shipping']['city'],
                state=data['shipping']['state'],
                zipcode=data['shipping']['zipcode'],
            )

    return JsonResponse('Payment subbmitted...', safe= False)

# Vistas para promociones
def promotions(request):
    data = cartData(request)
    cartItems = data['cartItems']
    promotions = Promotion.objects.all().order_by('-created_at')
    products = Product.objects.all()
    
    context = {
        'cartItems': cartItems,
        'promotions': promotions,
        'products': products
    }
    return render(request, 'promotions.html', context)

# API Views para promociones
def promotions_list_api(request):
    promotions = Promotion.objects.all().order_by('-created_at')
    promotions_data = []
    
    for promotion in promotions:
        promotions_data.append({
            'id': promotion.id,
            'name': promotion.name,
            'discount_type': promotion.discount_type,
            'discount_amount': promotion.discount_amount,
            'start_date': promotion.start_date.isoformat(),
            'end_date': promotion.end_date.isoformat(),
            'status': promotion.status,
            'is_active': promotion.is_active
        })
    
    return JsonResponse(promotions_data, safe=False)

def promotion_detail_api(request, promotion_id):
    try:
        promotion = Promotion.objects.get(id=promotion_id)
        products_data = []
        
        for product in promotion.products.all():
            products_data.append({
                'id': product.id,
                'name': product.name,
                'price': product.price,
                'image_url': product.imageURL
            })
        
        promotion_data = {
            'id': promotion.id,
            'name': promotion.name,
            'discount_type': promotion.discount_type,
            'discount_amount': promotion.discount_amount,
            'start_date': promotion.start_date.isoformat(),
            'end_date': promotion.end_date.isoformat(),
            'status': promotion.status,
            'products': products_data
        }
        
        return JsonResponse(promotion_data)
    except Promotion.DoesNotExist:
        return JsonResponse({'error': 'Promoción no encontrada'}, status=404)

def products_api(request):
    products = Product.objects.all()
    products_data = []
    
    for product in products:
        products_data.append({
            'id': product.id,
            'name': product.name,
            'price': product.price,
            'image_url': product.imageURL
        })
    
    return JsonResponse(products_data, safe=False)

def create_promotion_api(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            
            promotion = Promotion.objects.create(
                name=data['name'],
                discount_type=data['discount_type'],
                discount_amount=data['discount_amount'],
                start_date=data['start_date'],
                end_date=data['end_date'],
                status=data['status']
            )
            
            # Agregar productos a la promoción
            if 'products' in data:
                product_ids = data['products']
                products = Product.objects.filter(id__in=product_ids)
                promotion.products.set(products)
            
            return JsonResponse({
                'success': True,
                'promotion_id': promotion.id,
                'message': 'Promoción creada exitosamente'
            })
            
        except Exception as e:
            return JsonResponse({
                'success': False,
                'error': str(e)
            }, status=400)
    
    return JsonResponse({'error': 'Método no permitido'}, status=405)

def update_promotion_api(request, promotion_id):
    if request.method == 'PUT':
        try:
            promotion = Promotion.objects.get(id=promotion_id)
            data = json.loads(request.body)
            
            promotion.name = data['name']
            promotion.discount_type = data['discount_type']
            promotion.discount_amount = data['discount_amount']
            promotion.start_date = data['start_date']
            promotion.end_date = data['end_date']
            promotion.status = data['status']
            promotion.save()
            
            # Actualizar productos de la promoción
            if 'products' in data:
                product_ids = data['products']
                products = Product.objects.filter(id__in=product_ids)
                promotion.products.set(products)
            
            return JsonResponse({
                'success': True,
                'message': 'Promoción actualizada exitosamente'
            })
            
        except Promotion.DoesNotExist:
            return JsonResponse({'error': 'Promoción no encontrada'}, status=404)
        except Exception as e:
            return JsonResponse({
                'success': False,
                'error': str(e)
            }, status=400)
    
    return JsonResponse({'error': 'Método no permitido'}, status=405)