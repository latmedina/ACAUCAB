from django.db import models
from django.contrib.auth.models import User

class Lugar(models.Model):
    lug_id = models.AutoField(primary_key=True)
    lug_nombre = models.CharField(max_length=255)
    lug_tipo = models.CharField(max_length=255)
    fk_lugar = models.ForeignKey('self', null=True, blank=True, on_delete=models.SET_NULL)

    def __str__(self):
        return self.lug_nombre

    class Meta:
        db_table = 'LUGAR'


class Tienda(models.Model):
    tie_id = models.AutoField(primary_key=True)
    tie_nombre = models.CharField(max_length=255)
    tie_direccion = models.CharField(max_length=255)
    fk_lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)

    def __str__(self):
        return self.tie_nombre

    class Meta:
        db_table = 'TIENDA'


class Cliente(models.Model):
    NATURAL = 'NATURAL'
    JURIDICO = 'JURIDICO'
    TIPO_CHOICES = [
        (NATURAL, 'Natural'),
        (JURIDICO, 'Jurídico')
    ]

    cli_id = models.AutoField(primary_key=True)
    cli_rif = models.CharField(max_length=20)
    cli_direccion_fisica = models.CharField(max_length=255)
    cli_tipo_cliente = models.CharField(max_length=50, choices=TIPO_CHOICES)
    fk_lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)

    cli_nat_ci = models.IntegerField(null=True, blank=True)
    cli_nat_pnombre = models.CharField(max_length=255, null=True, blank=True)
    cli_nat_snombre = models.CharField(max_length=255, null=True, blank=True)
    cli_nat_papellido = models.CharField(max_length=255, null=True, blank=True)
    cli_nat_sapellido = models.CharField(max_length=255, null=True, blank=True)
    cli_nat_sexo = models.CharField(max_length=1, null=True, blank=True, choices=[('M', 'Masculino'), ('F', 'Femenino')])

    cli_jur_denom_comercial = models.CharField(max_length=255, null=True, blank=True)
    cli_jur_razon_social = models.CharField(max_length=255, null=True, blank=True)
    cli_jur_url_web = models.URLField(max_length=255, null=True, blank=True)
    cli_jur_capital = models.CharField(max_length=255, null=True, blank=True)
    cli_jur_dir_fiscal = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return self.cli_rif

    class Meta:
        db_table = 'CLIENTE'


class Proveedor(models.Model):
    pro_id = models.AutoField(primary_key=True)
    pro_rif = models.CharField(max_length=20)
    pro_razon_social = models.CharField(max_length=255)
    pro_denominacion_comercial = models.CharField(max_length=255)
    pro_direccion_fisica = models.CharField(max_length=255)
    pro_url_web = models.URLField(max_length=255)
    fk_lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)

    def __str__(self):
        return self.pro_razon_social

    class Meta:
        db_table = 'PROVEEDOR'


class Cargo(models.Model):
    car_id = models.AutoField(primary_key=True)
    car_nombre = models.CharField(max_length=255)
    car_descripcion = models.CharField(max_length=255)

    def __str__(self):
        return self.car_nombre

    class Meta:
        db_table = 'CARGO'


class Empleado(models.Model):
    emp_id = models.AutoField(primary_key=True)
    emp_ci = models.IntegerField()
    emp_pnombre = models.CharField(max_length=255)
    emp_snombres = models.CharField(max_length=255, null=True, blank=True)
    emp_papellido = models.CharField(max_length=255)
    emp_sapellido = models.CharField(max_length=255, null=True, blank=True)
    emp_fecha_nacimiento = models.DateTimeField()
    emp_sexo = models.CharField(max_length=50, choices=[('Masculino', 'Masculino'), ('femenino', 'Femenino')])
    fk_lugar = models.ForeignKey(Lugar, on_delete=models.CASCADE)
    fk_tienda = models.ForeignKey(Tienda, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.emp_pnombre} {self.emp_papellido}"

    class Meta:
        db_table = 'EMPLEADO'

class VentaOnline(models.Model):
    ven_onl_id = models.AutoField(primary_key=True)
    ven_onl_fecha = models.DateTimeField()
    ven_onl_total = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"VentaOnline #{self.ven_onl_id}"

    class Meta:
        db_table = 'VENTA_ONLINE'

class DetalleVentaOnline(models.Model):
    venta = models.ForeignKey(VentaOnline, on_delete=models.CASCADE)
    det_ven_onl_cantidad = models.PositiveIntegerField()
    det_ven_onl_precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"DetalleVentaOnline #{self.id}"

    class Meta:
        db_table = 'DETALLE_VENTA_ONLINE'

class MetodoPago(models.Model):
    met_pag_id = models.AutoField(primary_key=True)

    def __str__(self):
        return f"MetodoPago #{self.met_pag_id}"

    class Meta:
        db_table = 'METODO_PAGO'

class Cheque(models.Model):
    metodo = models.OneToOneField(MetodoPago, on_delete=models.CASCADE)
    che_num_cheque = models.CharField(max_length=50)

    def __str__(self):
        return self.che_num_cheque

    class Meta:
        db_table = 'CHEQUE'

class TarjetaDebito(models.Model):
    metodo = models.OneToOneField(MetodoPago, on_delete=models.CASCADE)
    tar_deb_numero = models.CharField(max_length=16)
    tar_deb_vencimiento = models.DateField()
    tar_deb_banco = models.CharField(max_length=50)

    def __str__(self):
        return self.tar_deb_numero

    class Meta:
        db_table = 'TARJETA_DEBITO'

class TarjetaCredito(models.Model):
    metodo = models.OneToOneField(MetodoPago, on_delete=models.CASCADE)
    tar_cre_numero = models.CharField(max_length=16)
    tar_cre_vencimiento = models.DateField()

    def __str__(self):
        return self.tar_cre_numero

    class Meta:
        db_table = 'TARJETA_CREDITO'

class Efectivo(models.Model):
    metodo = models.OneToOneField(MetodoPago, on_delete=models.CASCADE)
    efe_denominacion = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.efe_denominacion} Bs"

    class Meta:
        db_table = 'EFECTIVO'

class Pago(models.Model):
    pag_id = models.AutoField(primary_key=True)
    pago_monto = models.DecimalField(max_digits=10, decimal_places=2)
    pago_fecha = models.DateTimeField()

    def __str__(self):
        return f"Pago #{self.pag_id}"

    class Meta:
        db_table = 'PAGO'

class CorreoElectronico(models.Model):
    cor_ele_id = models.AutoField(primary_key=True)
    cor_ele_dirreccion = models.EmailField()

    def __str__(self):
        return self.cor_ele_dirreccion

    class Meta:
        db_table = 'CORREO_ELECTRONICO'

class Telefono(models.Model):
    tel_id = models.AutoField(primary_key=True)
    tel_codigo_area = models.CharField(max_length=5)
    tel_numero = models.CharField(max_length=10)

    def __str__(self):
        return f"({self.tel_codigo_area}) {self.tel_numero}"

    class Meta:
        db_table = 'TELEFONO'

class Evento(models.Model):
    eve_id = models.AutoField(primary_key=True)
    eve_nombre = models.CharField(max_length=100)
    eve_descripcion = models.TextField()
    eve_fecha_hora = models.DateTimeField()
    eve_nro_boletos = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return self.eve_nombre

    class Meta:
        db_table = 'EVENTO'

class TipoEvento(models.Model):
    tip_eve_id = models.AutoField(primary_key=True)
    tip_eve_nombre = models.CharField(max_length=100)
    tip_eve_descripcion = models.TextField()

    def __str__(self):
        return self.tip_eve_nombre

    class Meta:
        db_table = 'TIPO_EVENTO'

class VentaEvento(models.Model):
    ven_eve_id = models.AutoField(primary_key=True)
    ven_eve_fecha_hora = models.DateTimeField()
    ven_eve_monto_total = models.DecimalField(max_digits=10, decimal_places=2)
    ven_eve_descripcion = models.TextField()

    def __str__(self):
        return f"VentaEvento #{self.ven_eve_id}"

    class Meta:
        db_table = 'VENTA_EVENTO'

class DetalleVentaEvento(models.Model):
    venta_evento = models.ForeignKey(VentaEvento, on_delete=models.CASCADE)
    det_ven_eve_precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    det_ven_eve_cantidad = models.PositiveIntegerField()

    def __str__(self):
        return f"Detalle #{self.id} de VentaEvento {self.venta_evento_id}"

    class Meta:
        db_table = 'DETALLE_VENTA_EVENTO'

class VentaBoletoEvento(models.Model):
    ven_bol_eve_id = models.AutoField(primary_key=True)
    ven_bol_eve_fecha_hora = models.DateTimeField()
    ven_bol_eve_monto_total = models.DecimalField(max_digits=10, decimal_places=2)
    ven_bol_eve_descripcion = models.TextField()

    def __str__(self):
        return f"BoletoEvento #{self.ven_bol_eve_id}"

    class Meta:
        db_table = 'VENTA_BOLETO_EVENTO'


class LugarTienda(models.Model):
    lug_tie_id = models.AutoField(primary_key=True)
    lug_tie_nombre = models.CharField(max_length=100)
    lug_tie_tipo = models.CharField(max_length=50)

    def __str__(self):
        return self.lug_tie_nombre

    class Meta:
        db_table = 'LUGAR_TIENDA'

class Punto(models.Model):
    id = models.AutoField(primary_key=True)

    def __str__(self):
        return f"Punto #{self.id}"

    class Meta:
        db_table = 'PUNTO'

class Salario(models.Model):
    sal_id = models.AutoField(primary_key=True)
    sal_monto = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Salario #{self.sal_id}"

    class Meta:
        db_table = 'SALARIO'

class EmpCar(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    cargo = models.ForeignKey(Cargo, on_delete=models.CASCADE)
    emp_car_fecha_inicio = models.DateField()
    emp_car_fecha_fin = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.empleado} - {self.cargo}"

    class Meta:
        db_table = 'EMP_CAR'

class Horario(models.Model):
    hor_id = models.AutoField(primary_key=True)
    hor_dia = models.CharField(max_length=20)
    hor_hora_inicio = models.TimeField()
    hor_hora_fin = models.TimeField()

    def __str__(self):
        return f"{self.hor_dia} {self.hor_hora_inicio}-{self.hor_hora_fin}"

    class Meta:
        db_table = 'HORARIO'

class EmpCarHor(models.Model):
    emp_car = models.ForeignKey(EmpCar, on_delete=models.CASCADE)
    horario = models.ForeignKey(Horario, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.emp_car} - {self.horario}"

    class Meta:
        db_table = 'EMP_CAR_HOR'

class Vacacion(models.Model):
    vac_id = models.AutoField(primary_key=True)
    vac_nombre = models.CharField(max_length=100)
    vac_descripcion = models.TextField()

    def __str__(self):
        return self.vac_nombre

    class Meta:
        db_table = 'VACACION'

class EmpVac(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    vacacion = models.ForeignKey(Vacacion, on_delete=models.CASCADE)
    emp_vac_fecha_inicio = models.DateField()
    emp_vac_fecha_fin = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.empleado} - {self.vacacion}"

    class Meta:
        db_table = 'EMP_VAC'

class TipoBeneficio(models.Model):
    tip_ben_id = models.AutoField(primary_key=True)
    tip_ben_nombre = models.CharField(max_length=100)
    tip_ben_descripcion = models.TextField()

    def __str__(self):
        return self.tip_ben_nombre

    class Meta:
        db_table = 'TIPO_BENFICIO'

class EmpTipBen(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.CASCADE)
    tipo_beneficio = models.ForeignKey(TipoBeneficio, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.empleado} - {self.tipo_beneficio}"

    class Meta:
        db_table = 'EMP_TIP_BEN'

class Estatus(models.Model):
    est_id = models.AutoField(primary_key=True)
    est_tipo_estatus = models.CharField(max_length=100)
    est_descripcion = models.TextField()

    def __str__(self):
        return self.est_tipo_estatus

    class Meta:
        db_table = 'ESTATUS'

class Oferta(models.Model):
    ofe_id = models.AutoField(primary_key=True)
    ofe_nombre = models.CharField(max_length=100)
    ofe_fecha_inicio = models.DateField()
    ofe_fecha_fin = models.DateField()
    ofe_descripcion = models.TextField()
    ofe_porcentaje = models.FloatField()

    def __str__(self):
        return self.ofe_nombre

    class Meta:
        db_table = 'OFERTA'

class Moneda(models.Model):
    mon_id = models.AutoField(primary_key=True)
    mon_tipo = models.CharField(max_length=50)

    def __str__(self):
        return self.mon_tipo

    class Meta:
        db_table = 'MONEDA'

class HistoricoMoneda(models.Model):
    his_mon_id = models.AutoField(primary_key=True)
    his_mon_fecha_inicio = models.DateField()
    his_mon_fecha_fin = models.DateField(null=True, blank=True)
    mon_valor_cambio = models.FloatField()

    def __str__(self):
        return f"Cambio {self.mon_valor_cambio} desde {self.his_mon_fecha_inicio}"

    class Meta:
        db_table = 'HISTORICO_MONEDA'

class Almacen(models.Model):
    alm_id = models.AutoField(primary_key=True)
    alm_nombre = models.CharField(max_length=100)
    alm_descripcion = models.TextField()

    def __str__(self):
        return self.alm_nombre

    class Meta:
        db_table = 'ALMACEN'

class Anaquel(models.Model):
    ana_id = models.AutoField(primary_key=True)
    ana_numero = models.CharField(max_length=10)

    def __str__(self):
        return self.ana_numero

    class Meta:
        db_table = 'ANAQUEL'

class Dimension(models.Model):
    dim_id = models.AutoField(primary_key=True)
    dim_nombre = models.CharField(max_length=50)
    dim_unidad_medida = models.CharField(max_length=20)

    def __str__(self):
        return self.dim_nombre

    class Meta:
        db_table = 'DIMENSION'

class Ingrediente(models.Model):
    ing_id = models.AutoField(primary_key=True)
    ing_nombre = models.CharField(max_length=100)
    ing_descripcion = models.TextField()

    def __str__(self):
        return self.ing_nombre

    class Meta:
        db_table = 'INGREDIENTE'

class Instruccion(models.Model):
    ins_id = models.AutoField(primary_key=True)
    ins_descripcion = models.TextField()

    def __str__(self):
        return self.ins_descripcion[:50]

    class Meta:
        db_table = 'INSTRUCCION'

class Receta(models.Model):
    rec_id = models.AutoField(primary_key=True)
    rec_nombre = models.CharField(max_length=100)
    rec_descrpicion = models.TextField()

    def __str__(self):
        return self.rec_nombre

    class Meta:
        db_table = 'RECETA'

class RecIng(models.Model):
    receta = models.ForeignKey(Receta, on_delete=models.CASCADE)
    ingrediente = models.ForeignKey(Ingrediente, on_delete=models.CASCADE)
    rec_ing_cantidad = models.FloatField()

    def __str__(self):
        return f"{self.receta} - {self.ingrediente} ({self.rec_ing_cantidad})"

    class Meta:
        db_table = 'REC_ING'

class EstiloCerveza(models.Model):
    est_cer_id = models.AutoField(primary_key=True)
    tip_cer_nombre = models.CharField(max_length=100)
    tip_cer_descripcion = models.TextField()

    def __str__(self):
        return self.tip_cer_nombre

    class Meta:
        db_table = 'ESTILO_CERVEZA'

class Presentacion(models.Model):
    prese_id = models.AutoField(primary_key=True)
    prese_nombre = models.CharField(max_length=100)
    prese_recipiente = models.CharField(max_length=100)
    prese_imagen = models.ImageField(upload_to='productos/', null=True, blank=True)

    def __str__(self):
        return self.prese_nombre
    
    @property
    def precio_actual(self):
        from datetime import date
        hoy = date.today()
        precio = self.historicopreciocerveza_set.filter(
            his_pre_cer_fecha_inicio__lte=hoy
        ).filter(
            models.Q(his_pre_cer_fecha_fin__gte=hoy) | models.Q(his_pre_cer_fecha_fin__isnull=True)
        ).order_by('-his_pre_cer_fecha_inicio').first()
        return precio.his_pre_cer_precio if precio else None


    class Meta:
        db_table = 'PRESENTACION'


class HistoricoPrecioCerveza(models.Model):
    his_pre_cer_id = models.AutoField(primary_key=True)
    presentacion = models.ForeignKey(Presentacion, on_delete=models.CASCADE)
    his_pre_cer_precio = models.DecimalField(max_digits=10, decimal_places=2)
    his_pre_cer_fecha_inicio = models.DateField()
    his_pre_cer_fecha_fin = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.presentacion} - {self.his_pre_cer_precio}"

    class Meta:
        db_table = 'HISTORICO_PRECIO_CERVEZA'

class HistoricoPrecioPunto(models.Model):
    his_pre_pun_id = models.AutoField(primary_key=True)
    his_pre_pun_valor = models.DecimalField(max_digits=10, decimal_places=2)
    his_pre_pun_fecha_inicio = models.DateField()
    his_pre_pun_fecha_fin = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.his_pre_pun_valor} desde {self.his_pre_pun_fecha_inicio}"

    class Meta:
        db_table = 'HISTORICO_PRECIO_PUNTO'

class CuePun(models.Model):
    cue_pun_id = models.AutoField(primary_key=True)
    cue_pun_cantidad = models.IntegerField()

    def __str__(self):
        return f"Cuenta Punto #{self.cue_pun_id}"

    class Meta:
        db_table = 'CUE_PUN'

class PreAlm(models.Model):
    pre_alm_precio = models.DecimalField(max_digits=10, decimal_places=2)
    pre_alm_cantidad = models.IntegerField()

    def __str__(self):
        return f"Precio: {self.pre_alm_precio}, Cantidad: {self.pre_alm_cantidad}"

    class Meta:
        db_table = 'PRE_ALM'

class PreDim(models.Model):
    pre_dim_valor = models.FloatField()

    def __str__(self):
        return str(self.pre_dim_valor)

    class Meta:
        db_table = 'PRE_DIM'

class PagoEfectivo(models.Model):
    pag_efe_id = models.AutoField(primary_key=True)
    pag_efe_monto = models.DecimalField(max_digits=10, decimal_places=2)
    pag_efe_fecha = models.DateField()

    def __str__(self):
        return f"{self.pag_efe_monto} Bs el {self.pag_efe_fecha}"

    class Meta:
        db_table = 'PAGO_EFECTIVO'

class ExistenciaEvento(models.Model):
    exi_eve_id = models.AutoField(primary_key=True)
    exi_eve_cantidad = models.IntegerField()
    exi_eve_precio = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Existencia #{self.exi_eve_id}"

    class Meta:
        db_table = 'EXISTENCIA_EVENTO'

class Asistencia(models.Model):
    asi_id = models.AutoField(primary_key=True)
    asi_hora_inicio = models.DateTimeField()
    asi_hora_fin = models.DateTimeField(null=True, blank=True)
    asi_pagado = models.BooleanField(default=False)

    def __str__(self):
        return f"Asistencia #{self.asi_id}"

    class Meta:
        db_table = 'ASISTENCIA'

class AsistenciaEvento(models.Model):
    asi_eve_id = models.AutoField(primary_key=True)
    asi_eve_fecha_hora = models.DateTimeField()

    def __str__(self):
        return f"AsistenciaEvento #{self.asi_eve_id}"

    class Meta:
        db_table = 'ASISTENCIA_EVENTO'

class EmpSalCar(models.Model):
    emp_sal_car_fecha_inicio = models.DateField()
    emp_sal_car_fecha_fin = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"Inicio: {self.emp_sal_car_fecha_inicio}"

    class Meta:
        db_table = 'EMP_SAL_CAR'
