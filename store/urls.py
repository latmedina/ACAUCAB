from django.urls import path
from . import views

urlpatterns = [
    # Vistas de la tienda
    path('', views.store, name='store'),
    path('update_cart/', views.update_cart, name='update_cart'),
    path('checkout/', views.checkout, name='checkout'),
    path('update_item/', views.updateItem, name='update_item'),
    path('process_order/', views.processOrder, name='process_order'),
    path('cart/', views.cart_view, name='cart'),

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
