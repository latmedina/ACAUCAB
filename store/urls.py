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
    path('get-saved-payment-methods/', views.get_saved_payment_methods, name='get_saved_payment_methods'),
    path('currency-rates/', views.currency_rates_view, name='currency_rates'),

    # Autenticación
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('registrar/cliente/', views.registrar_cliente_view, name='registrar_cliente'),
    path('registrar/empleado/', views.registrar_empleado_view, name='registrar_empleado'),
    path('registrar/proveedor/', views.registrar_proveedor_view, name='registrar_proveedor'),
    path('registrar/usuario/<str:tipo>/<int:id_entidad>/', views.crear_usuario_view, name='crear_usuario'),
    path('modificar-usuario/<int:usuario_id>/', views.modificar_usuario_view, name='modificar_usuario'),


    path('factura/', views.vista_factura, name='vista_factura'),
    path('api/reporte/venta/<int:venta_id>/', views.generar_reporte_venta_api, name='api_reporte_venta'),
    path('orden/', views.vista_orden_compra, name='vista_orden_compra'),
    path('api/reporte/orden/<int:orden_id>/', views.generar_orden_compra_api, name='api_orden_compra'),
    path('reporte1/', views.vista_reporte_productores, name='vista_reporte_productores'),
    path('api/reportes/productores-en-eventos/', views.reporte_productores_eventos_api, name='api_reporte_productores'),

    path('modificar_usuario/<int:id_usuario>/', views.modificar_usuario_view, name='modificar_usuario'),

    # AJAX para selector jerárquico de lugar
    path('ajax/load-municipios/', views.load_municipios, name='ajax_load_municipios'),
    path('ajax/load-parroquias/', views.load_parroquias, name='ajax_load_parroquias'),

    # Página principal post-login
    path('home/', views.home_view, name='home'),
]