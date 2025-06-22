from django.urls import path
from . import views

urlpatterns = [
    # Redirección raíz a tienda online
    path('', views.redirect_store, name='redirect_store'),

    # Tienda general (física / online)
    path('store/<str:tipo>/', views.store_view, name='store'),
    path('cart/<str:tipo>/', views.cart_view, name='cart'),  # Puedes ajustar si tienes vista específica
    path('update_cart/<str:tipo>/', views.update_cart_view, name='update_cart'),
    path('checkout/<str:tipo>/', views.checkout_view, name='checkout'),
    path('process_order/<str:tipo>/', views.process_order_view, name='process_order'),


    # Autenticación
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('registro/', views.registro, name='registro'),

    # Página principal post-login
    path('home/', views.home_view, name='home'),
]