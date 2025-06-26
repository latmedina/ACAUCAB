from django.urls import path
from . import views

app_name = 'empleados'

urlpatterns = [
    # Dashboard principal de empleados
    path('', views.empleado_dashboard, name='dashboard'),
    path('dashboard/', views.empleado_dashboard, name='dashboard'),
    
    # Sección de reportes
    path('reportes/', views.empleado_reportes, name='reportes'),
    
    # ========== URLs DE REPORTES ==========
    
    # Facturas
    path('reportes/facturas/', views.vista_factura, name='vista_factura'),
    path('api/reportes/venta/<int:venta_id>/', views.generar_reporte_venta_api, name='generar_reporte_venta_api'),
    
    # Órdenes de Compra
    path('reportes/ordenes-compra/', views.vista_orden_compra, name='vista_orden_compra'),
    path('api/reportes/orden-compra/<int:orden_id>/', views.generar_orden_compra_api, name='generar_orden_compra_api'),
    
    # Productores en Eventos
    path('reportes/productores-eventos/', views.vista_reporte_productores, name='vista_reporte_productores'),
    path('api/reportes/productores-eventos/', views.reporte_productores_eventos_api, name='reporte_productores_eventos_api'),
    
    # Eficiencia de Despacho
    path('reportes/eficiencia-despacho/', views.vista_reporte_eficiencia, name='vista_reporte_eficiencia'),
    path('api/reportes/eficiencia-despacho/', views.reporte_eficiencia_despacho_api, name='reporte_eficiencia_despacho_api'),
    
    # Histórico de Ofertas
    path('reportes/historico-ofertas/', views.vista_reporte_ofertas, name='vista_reporte_ofertas'),
    path('api/reportes/historico-ofertas/', views.reporte_historico_ofertas_api, name='reporte_historico_ofertas_api'),
    
    # Incumplimiento de Horario
    path('reportes/incumplimiento-horario/', views.vista_reporte_incumplimiento, name='vista_reporte_incumplimiento'),
    path('api/reportes/incumplimiento-horario/', views.reporte_incumplimiento_horario_api, name='reporte_incumplimiento_horario_api'),
    
    # Órdenes Pendientes
    path('reportes/ordenes-pendientes/', views.vista_reporte_ordenes_pendientes, name='vista_reporte_ordenes_pendientes'),
    path('api/reportes/ordenes-pendientes/', views.reporte_ordenes_pendientes_api, name='reporte_ordenes_pendientes_api'),

    # Gestión de órdenes de compra
    path('gestion_ordenes/', views.vista_gestion_ordenes, name='vista_gestion_ordenes'),
    path('api/gestion/ordenes/', views.gestion_ordenes_api, name='api_gestion_ordenes'),
    path('gestion_ordenes/api/gestion/ordenes/actualizar/<int:orden_id>/', views.actualizar_orden_api, name='api_actualizar_orden'),
    path('gestion_ordenes/orden/<int:orden_id>/', views.vista_orden_compra_directa, name='vista_orden_compra_directa'),

    path('gestion_reposicion/', views.vista_gestion_reposicion, name='vista_gestion_reposicion'),
    path('api/gestion/reposicion/', views.gestion_reposicion_api, name='api_gestion_reposicion'),
    path('gestion_reposicion/api/gestion/reposicion/actualizar/<int:solicitud_id>/', views.actualizar_reposicion_api, name='api_actualizar_reposicion'),
]
    