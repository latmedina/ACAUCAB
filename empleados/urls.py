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
    path('api/reportes/venta/<str:tipo>/<int:venta_id>/', views.generar_reporte_venta_api, name='generar_reporte_venta_api'),
    
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

    # ROLES
    path('crear-rol/', views.crear_rol_view, name='crear_rol'),
    path('asignar-rol/', views.asignar_rol_view, name='asignar_rol'),
    path('roles/', views.listar_roles_view, name='listar_roles'),
    path('modificar-rol/<int:rol_id>/', views.modificar_rol_view, name='modificar_rol'),
    path('eliminar-rol/<int:id>/', views.eliminar_rol_view, name='eliminar_rol'),

    #Privilegios
    path('crear-privilegio/', views.crear_privilegio_view, name='crear_privilegio'),
    path('privilegios/', views.listar_privilegios_view, name='listar_privilegios'),
    path('modificar-privilegio/<int:id>/', views.modificar_privilegio_view, name='modificar_privilegio'),
    path('eliminar-privilegio/<int:id>/', views.eliminar_privilegio_view, name='eliminar_privilegio'),
    path('asignar-privilegios/', views.seleccionar_rol_para_privilegios_view, name='seleccionar_rol_para_privilegios'),
    path('asignar-privilegios/<int:id>/', views.asignar_privilegio_view, name='asignar_privilegios'),

    #GESTIÓN DE USUARIOS
    path('gestion-usuarios/', views.gestion_usuarios_view, name='gestion_usuarios'),

    # Gestión de órdenes de compra
    path('gestion_ordenes/', views.vista_gestion_ordenes, name='vista_gestion_ordenes'),
    path('api/gestion/ordenes/', views.gestion_ordenes_api, name='api_gestion_ordenes'),
    path('gestion_ordenes/api/gestion/ordenes/actualizar/<int:orden_id>/', views.actualizar_orden_api, name='api_actualizar_orden'),
    path('gestion_ordenes/orden/<int:orden_id>/', views.vista_orden_compra_directa, name='vista_orden_compra_directa'),

    path('gestion_reposicion/', views.vista_gestion_reposicion, name='vista_gestion_reposicion'),
    path('api/gestion/reposicion/', views.gestion_reposicion_api, name='api_gestion_reposicion'),
    path('gestion_reposicion/api/gestion/reposicion/actualizar/<int:solicitud_id>/', views.actualizar_reposicion_api, name='api_actualizar_reposicion'),

    # ========== GESTIÓN DE SOLICITUDES PENDIENTES ==========
    path('solicitudes-pendientes/', views.vista_gestion_solicitudes_pendientes, name='vista_gestion_solicitudes_pendientes'),
    path('api/solicitudes-pendientes/', views.solicitudes_pendientes_api, name='api_solicitudes_pendientes'),
    path('api/solicitudes-aprobadas/', views.solicitudes_aprobadas_api, name='api_solicitudes_aprobadas'),
    path('api/solicitudes-rechazadas/', views.solicitudes_rechazadas_api, name='api_solicitudes_rechazadas'),
    path('api/solicitudes-entregadas/', views.solicitudes_entregadas_api, name='api_solicitudes_entregadas'),
    path('api/proveedores/', views.proveedores_api, name='api_proveedores'),
    path('api/solicitudes-pendientes/<int:solicitud_id>/cambiar-proveedor/', views.cambiar_proveedor_api, name='api_cambiar_proveedor'),
    path('api/solicitudes-pendientes/<int:solicitud_id>/aprobar/', views.aprobar_solicitud_api, name='api_aprobar_solicitud'),
    path('api/solicitudes-pendientes/<int:solicitud_id>/rechazar/', views.rechazar_solicitud_api, name='api_rechazar_solicitud'),
    path('api/solicitudes-rechazadas/<int:solicitud_id>/devolver-pendiente/', views.devolver_a_pendiente_api, name='api_devolver_pendiente'),
    path('api/solicitudes-aprobadas/<int:solicitud_id>/marcar-entregada/', views.marcar_entregada_api, name='api_marcar_entregada'),

    # Removed: duplicate/missing functions
    # path('obtener-ordenes-pendientes/', views.obtener_ordenes_pendientes, name='obtener_ordenes_pendientes'),
    # path('actualizar-fecha-ven-onl-est/', views.actualizar_fecha_ven_onl_est, name='actualizar_fecha_ven_onl_est'),
    # path('cargar-presentaciones/', views.cargar_presentaciones, name='cargar_presentaciones'),
    
    # ========== indicadores de ventas ==========
    path('', views.empleado_dashboard_indicadores, name='dashboard_indicadores'),
    path('dashboard_indicadores/', views.empleado_dashboard_indicadores, name='dashboard_indicadores'),
    path('dashboard_indicadores/indicadores_ventas', views.vista_indicadores_ventas, name='indicadores_ventas'),
    path('api/kpi/ventas-totales/',views.ventas_totales_api, name='api_kpi_ventas_totales'),
    path('dashboard_indicadores/ventas_totales', views.vista_ventas_totales, name='ventas_totales'),
    path('api/kpi/crecimiento-ventas/', views.crecimiento_ventas_api, name='api_kpi_crecimiento_ventas'),
    path('api/kpi/ticket-promedio/', views.kpi_ticket_promedio_api, name='api_kpi_ticket_promedio'),
    path('api/kpi/volumen-unidades/', views.kpi_volumen_unidades_api, name='api_kpi_volumen_unidades'),
    path('api/kpi/ventas-por-estilo/', views.kpi_ventas_por_estilo_api, name='api_kpi_ventas_por_estilo'),

    # ========== indicadores de clientes ==========
    path('dashboard_indicadores/indicadores_clientes/', views.vista_indicadores_clientes, name='indicadores_clientes'),
    path('api/kpi/clientes-nuevos-recurrentes/', views.kpi_clientes_nuevos_recurrentes_api, name='api_kpi_clientes_nuevos_recurrentes'),
    path('api/kpi/tasa-retencion/', views.kpi_tasa_retencion_api, name='api_kpi_tasa_retencion'),

    # ========== indicadores de inventario ==========
    path('dashboard_indicadores/indicadores_inventario/', views.vista_indicadores_inventario, name='indicadores_inventario'),
    path('api/kpi/rotacion-inventario/', views.kpi_rotacion_inventario_api, name='api_kpi_rotacion_inventario'),
    path('api/kpi/ruptura-stock/', views.kpi_tasa_ruptura_stock_api, name='api_kpi_ruptura_stock'),

    # ========== graficos de tendencia de ventas ==========
    path('graficos/tendencia-ventas/', views.vista_grafico_tendencia, name='vista_grafico_tendencia'),
    path('api/graficos/tendencia-ventas/', views.grafico_tendencia_ventas_api, name='api_grafico_tendencia_ventas'),

    # ========== graficos de productos mas vendidos ==========
    path('reportes/top-productos/', views.vista_productos_mas_vendidos, name='vista_productos_mas_vendidos'),
    path('api/kpi/top-productos/', views.kpi_productos_mas_vendidos_api, name='api_kpi_top_productos'),

    # ========== graficos de productos mas vendidos ==========
    path('reportes/inventario-actual/', views.vista_reporte_inventario, name='vista_reporte_inventario'),
    path('api/stock-por-presentacion/', views.reporte_stock_presentacion_api, name='api_reporte_stock_presentacion'),
    path('api/tiendas/', views.tiendas_api, name='api_tiendas'),
    

    # URLs del módulo de Eventos
    path('eventos/', views.lista_eventos, name='lista_eventos'),
    path('eventos/crear/', views.crear_evento, name='crear_evento'),
    path('eventos/<int:evento_id>/', views.detalle_evento, name='detalle_evento'),
    path('eventos/<int:evento_id>/editar/', views.editar_evento, name='editar_evento'),
    path('eventos/<int:evento_id>/eliminar/', views.eliminar_evento, name='eliminar_evento'),
    path('eventos/<int:evento_id>/invitados/', views.asignar_invitados, name='asignar_invitados'),
    path('eventos/<int:evento_id>/invitados/<int:inv_eve_id>/eliminar/', views.eliminar_invitado_evento, name='eliminar_invitado_evento'),
    path('eventos/<int:evento_id>/proveedores/', views.asignar_proveedores, name='asignar_proveedores'),
    path('eventos/<int:evento_id>/proveedores/<int:eve_pro_id>/eliminar/', views.eliminar_proveedor_evento, name='eliminar_proveedor_evento'),
    path('eventos/<int:evento_id>/proveedores/<int:eve_pro_id>/existencias/', views.gestionar_existencias_evento, name='gestionar_existencias_evento'),
    path('api/proveedores/<int:proveedor_id>/presentaciones/', views.obtener_presentaciones_proveedor, name='obtener_presentaciones_proveedor'),
]
    