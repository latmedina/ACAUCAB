from django.urls import path
from . import views

urlpatterns = [
    # Redirección y tienda principal
    path('', views.redirect_store, name='redirect_store'),
    path('store/', views.store, name='store'),  # Vista básica original
    
    # Tienda generalizada (física/online)
    path('store/<str:tipo>/', views.store_view, name='store_view'),
    path('cart/<str:tipo>/', views.cart_view, name='cart_view'),
    path('update_cart/<str:tipo>/', views.update_cart_view, name='update_cart_view'),
    path('checkout/<str:tipo>/', views.checkout_view, name='checkout_view'),
    path('process_order/<str:tipo>/', views.process_order_view, name='process_order_view'),
    
    # Rutas básicas (compatibilidad)
    path('cart/', views.cart_view, {'tipo': 'online'}, name='cart'),
    path('update_cart/', views.update_cart, name='update_cart'),
    path('checkout/', views.checkout, name='checkout'),
    path('process_order/', views.processOrder, name='process_order'),

    # Métodos de pago
    path('payment-method/', views.payment_method_view, name='payment_method'),
    path('process-payment-method/', views.process_payment_method, name='process_payment_method'),
    path('currency-rates/', views.currency_rates_view, name='currency_rates'),

    # Autenticación
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('registrar/cliente/', views.registrar_cliente_view, name='registrar_cliente'),
    path('registrar/empleado/', views.registrar_empleado_view, name='registrar_empleado'),
    path('registrar/proveedor/', views.registrar_proveedor_view, name='registrar_proveedor'),
    path('registrar/usuario/<str:tipo>/<int:id_entidad>/', views.crear_usuario_view, name='crear_usuario'),

    # Página principal post-login
    path('home/', views.home_view, name='home'),
]