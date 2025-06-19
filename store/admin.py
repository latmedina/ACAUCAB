from django.contrib import admin
from .models import (
    lugar, tienda, cliente, proveedor, cargo, empleado, presentacion,
    metodo_pago, pago, correo_electronico, telefono, evento, tipo_evento,
    venta_online, venta_evento, detalle_venta_evento, venta_boleto_evento,
    lugar_tienda, horario, vacacion, tipo_beneficio, estatus, oferta,
    moneda, historico_moneda, almacen, anaquel, ingrediente, instruccion,
    receta, estilo_cerveza, historico_precio_punto, pago_efectivo,
    existencia_evento, asistencia, asistencia_evento, pre_alm
)

@admin.register(lugar)
class lugar_admin(admin.ModelAdmin):
    list_display = ('lug_id', 'lug_nombre', 'lug_tipo')

@admin.register(tienda)
class tienda_admin(admin.ModelAdmin):
    list_display = ('tie_id', 'tie_nombre', 'tie_direccion')

@admin.register(cliente)
class cliente_admin(admin.ModelAdmin):
    list_display = ('cli_id', 'cli_rif', 'cli_tipo_cliente', 'cli_direccion_fisica')

@admin.register(proveedor)
class proveedor_admin(admin.ModelAdmin):
    list_display = ('pro_id', 'pro_rif', 'pro_razon_social', 'pro_direccion_fiscal')

@admin.register(cargo)
class cargo_admin(admin.ModelAdmin):
    list_display = ('car_id', 'car_nombre', 'car_descripcion')

@admin.register(empleado)
class empleado_admin(admin.ModelAdmin):
    list_display = ('emp_id', 'emp_ci', 'emp_pnombre', 'emp_papellido', 'emp_sexo')

@admin.register(presentacion)
class presentacion_admin(admin.ModelAdmin):
    list_display = ('prese_id', 'prese_nombre', 'prese_recipiente')
    search_fields = ('prese_nombre',)

# Registros sin personalización
admin.site.register(metodo_pago)
admin.site.register(pago)
admin.site.register(correo_electronico)
admin.site.register(telefono)
admin.site.register(evento)
admin.site.register(tipo_evento)
admin.site.register(venta_online)
admin.site.register(venta_evento)
admin.site.register(detalle_venta_evento)
admin.site.register(venta_boleto_evento)
admin.site.register(lugar_tienda)
admin.site.register(horario)
admin.site.register(vacacion)
admin.site.register(tipo_beneficio)
admin.site.register(estatus)
admin.site.register(oferta)
admin.site.register(moneda)
admin.site.register(historico_moneda)
admin.site.register(almacen)
admin.site.register(anaquel)
admin.site.register(ingrediente)
admin.site.register(instruccion)
admin.site.register(receta)
admin.site.register(estilo_cerveza)
admin.site.register(historico_precio_punto)
admin.site.register(pago_efectivo)
admin.site.register(existencia_evento)
admin.site.register(asistencia)
admin.site.register(asistencia_evento)
admin.site.register(pre_alm)