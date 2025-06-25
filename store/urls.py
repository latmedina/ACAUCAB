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

    # Sistema de Múltiples Métodos de Pago
    path('payment-method/', views.payment_method_view, name='payment_method'),
    path('get-applied-payments/', views.get_applied_payments, name='get_applied_payments'),
    path('add-partial-payment/', views.add_partial_payment, name='add_partial_payment'),
    path('remove-partial-payment/', views.remove_partial_payment, name='remove_partial_payment'),
    path('finalize-multiple-payment-purchase/', views.finalize_multiple_payment_purchase, name='finalize_multiple_payment_purchase'),
    
    # Métodos de pago originales (compatibilidad)
    path('payment-method-original/', views.payment_method_view_original, name='payment_method_original'),
    path('process-payment-method/', views.process_payment_method_original, name='process_payment_method'),
    path('get-saved-payment-methods/', views.get_saved_payment_methods, name='get_saved_payment_methods'),
    path('currency-rates/', views.currency_rates_view, name='currency_rates'),

    # Autenticación
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('registrar/cliente/', views.registrar_cliente_view, name='registrar_cliente'),
    path('registrar/empleado/', views.registrar_empleado_view, name='registrar_empleado'),
    path('registrar/proveedor/', views.registrar_proveedor_view, name='registrar_proveedor'),
    path('registrar/usuario/<str:tipo>/<int:id_entidad>/', views.crear_usuario_view, name='crear_usuario'),
    path('modificar_usuario/<int:id_usuario>/', views.modificar_usuario_view, name='modificar_usuario'),
    path('eliminar_usuario/<int:id_usuario>/', views.eliminar_usuario_view, name='eliminar_usuario'),

    # Reportes
    #path('factura/', views.vista_factura, name='vista_factura'),
    path('factura/<int:venta_id>/', views.vista_factura_directa, name='vista_factura_directa'),
    path('api/reporte/venta/<int:venta_id>/', views.generar_reporte_venta_api, name='api_reporte_venta'),
    path('orden/', views.vista_orden_compra, name='vista_orden_compra'),
    path('api/reporte/orden/<int:orden_id>/', views.generar_orden_compra_api, name='api_orden_compra'),
    path('reporte1/', views.vista_reporte_productores, name='vista_reporte_productores'),
    path('api/reportes/productores-en-eventos/', views.reporte_productores_eventos_api, name='api_reporte_productores'),
    path('reporte2', views.vista_reporte_eficiencia, name='vista_reporte_eficiencia'),
    path('api/reportes/eficiencia-despacho/', views.reporte_eficiencia_despacho_api, name='api_reporte_eficiencia'),
    path('reporte3/', views.vista_reporte_ofertas, name='vista_reporte_ofertas'),
    path('api/reportes/historico-ofertas/', views.reporte_historico_ofertas_api, name='api_reporte_ofertas'),
    path('reporte4', views.vista_reporte_incumplimiento, name='vista_reporte_incumplimiento'),
    path('api/reportes/incumplimiento-horario/', views.reporte_incumplimiento_horario_api, name='api_reporte_incumplimiento'),
    path('reporte5', views.vista_reporte_ordenes_pendientes, name='vista_reporte_ordenes_pendientes'),
    path('api/reportes/ordenes-pendientes/', views.reporte_ordenes_pendientes_api, name='api_reporte_ordenes_pendientes'),

    #Interfaz de historial de compras de un cliente
    path('historial-compras/<int:id_usuario>/', views.vista_historial_compras, name='historial-compras'),
    path('api/historial/usuario/<int:id_usuario>/', views.historial_compras_api, name='api_historial_compras'),

    # Interfaz de empleado
    path('empleado/home/', views.empleado_home, name='empleado_home'),

    # AJAX para selector jerárquico de lugar
    path('ajax/load-municipios/', views.load_municipios, name='ajax_load_municipios'),
    path('ajax/load-parroquias/', views.load_parroquias, name='ajax_load_parroquias'),

    # Página principal post-login
    path('home/', views.home_view, name='home'),
]