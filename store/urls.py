from django.urls import path
from . import views

urlpatterns = [
    # Redirección y tienda principal
    path('', views.redirect_store, name='redirect_store'),
    path('store/', views.store, name='store'),  # Vista básica original
    
    # Tienda generalizada (física/online)
    path('store/<str:tipo>/', views.store_view, name='store_view'),
    path('cart/<str:tipo>/', views.cart_view, name='cart_view'),
    path('cart-dropdown-data/', views.cart_dropdown_data, name='cart_dropdown_data'),
    path('update_cart/<str:tipo>/', views.update_cart_view, name='update_cart_view'),
    path('checkout/<str:tipo>/', views.checkout_view, name='checkout_view'),
    path('process_order/<str:tipo>/', views.process_order_view, name='process_order_view'),
    
    # Sistema de Autopago
    path('autopago/', views.autopago_inicio, name='autopago_inicio'),
    path('autopago/login/', views.autopago_login, name='autopago_login'),
    path('autopago/tienda/', views.autopago_tienda, name='autopago_tienda'),
    path('autopago/logout/', views.autopago_logout, name='autopago_logout'),
    
    # Rutas básicas (compatibilidad) - ahora por defecto a tienda física
    path('cart/', views.cart_view, {'tipo': 'fisica'}, name='cart'),
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
    path('registro/', views.registro, name='registro'),

    # Página principal post-login
    path('home/', views.home_view, name='home'),
]