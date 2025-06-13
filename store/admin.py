from django.contrib import admin
from .models import (
    Lugar, Tienda, Cliente, Proveedor, Cargo, Empleado,
    MetodoPago, Cheque, TarjetaDebito, TarjetaCredito, Efectivo, Pago,
    CorreoElectronico, Telefono, Evento, TipoEvento, VentaOnline,
    DetalleVentaOnline, VentaEvento, DetalleVentaEvento, VentaBoletoEvento,
    LugarTienda, Punto, Salario, EmpCar, Horario, EmpCarHor,
    Vacacion, EmpVac, TipoBeneficio, EmpTipBen, Estatus, Oferta,
    Moneda, HistoricoMoneda, Almacen, Anaquel, Dimension, Ingrediente,
    Instruccion, Receta, RecIng, EstiloCerveza, HistoricoPrecioCerveza,
    HistoricoPrecioPunto, CuePun, PreAlm, PreDim, PagoEfectivo,
    ExistenciaEvento, Asistencia, AsistenciaEvento, EmpSalCar
)

@admin.register(Lugar)
class LugarAdmin(admin.ModelAdmin):
    list_display = ('lug_id', 'lug_nombre', 'lug_tipo')

@admin.register(Tienda)
class TiendaAdmin(admin.ModelAdmin):
    list_display = ('tie_id', 'tie_nombre', 'tie_direccion')

@admin.register(Cliente)
class ClienteAdmin(admin.ModelAdmin):
    list_display = ('cli_id', 'cli_rif', 'cli_tipo_cliente', 'cli_direccion_fisica')

@admin.register(Proveedor)
class ProveedorAdmin(admin.ModelAdmin):
    list_display = ('pro_id', 'pro_rif', 'pro_razon_social', 'pro_direccion_fisica')

@admin.register(Cargo)
class CargoAdmin(admin.ModelAdmin):
    list_display = ('car_id', 'car_nombre', 'car_descripcion')

@admin.register(Empleado)
class EmpleadoAdmin(admin.ModelAdmin):
    list_display = ('emp_id', 'emp_ci', 'emp_pnombre', 'emp_papellido', 'emp_sexo')


# Registros básicos sin customización especial:
admin.site.register(MetodoPago)
admin.site.register(Cheque)
admin.site.register(TarjetaDebito)
admin.site.register(TarjetaCredito)
admin.site.register(Efectivo)
admin.site.register(Pago)
admin.site.register(CorreoElectronico)
admin.site.register(Telefono)
admin.site.register(Evento)
admin.site.register(TipoEvento)
admin.site.register(VentaOnline)
admin.site.register(DetalleVentaOnline)
admin.site.register(VentaEvento)
admin.site.register(DetalleVentaEvento)
admin.site.register(VentaBoletoEvento)
admin.site.register(LugarTienda)
admin.site.register(Punto)
admin.site.register(Salario)
admin.site.register(EmpCar)
admin.site.register(Horario)
admin.site.register(EmpCarHor)
admin.site.register(Vacacion)
admin.site.register(EmpVac)
admin.site.register(TipoBeneficio)
admin.site.register(EmpTipBen)
admin.site.register(Estatus)
admin.site.register(Oferta)
admin.site.register(Moneda)
admin.site.register(HistoricoMoneda)
admin.site.register(Almacen)
admin.site.register(Anaquel)
admin.site.register(Dimension)
admin.site.register(Ingrediente)
admin.site.register(Instruccion)
admin.site.register(Receta)
admin.site.register(RecIng)
admin.site.register(EstiloCerveza)
admin.site.register(HistoricoPrecioCerveza)
admin.site.register(HistoricoPrecioPunto)
admin.site.register(CuePun)
admin.site.register(PreAlm)
admin.site.register(PreDim)
admin.site.register(PagoEfectivo)
admin.site.register(ExistenciaEvento)
admin.site.register(Asistencia)
admin.site.register(AsistenciaEvento)
admin.site.register(EmpSalCar)
