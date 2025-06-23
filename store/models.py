from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings

class afi_est(models.Model):
    afi_est_id = models.AutoField(primary_key=True)
    afi_est_fecha_inicio = models.DateField()
    afi_est_fecha_fin = models.DateField(blank=True, null=True)
    fk_afiliacion = models.ForeignKey('afiliacion', models.DO_NOTHING, db_column='fk_afiliacion')
    fk_estatus = models.ForeignKey('estatus', models.DO_NOTHING, db_column='fk_estatus')

    class Meta:
        managed = True
        db_table = 'afi_est'


class afiliacion(models.Model):
    afi_id = models.AutoField(primary_key=True)
    afi_nombre = models.CharField(max_length=50)
    afi_monto = models.IntegerField()
    fk_proveedor = models.ForeignKey('proveedor', models.DO_NOTHING, db_column='fk_proveedor')
    fk_tienda = models.ForeignKey('tienda', models.DO_NOTHING, db_column='fk_tienda')

    class Meta:
        managed = True
        db_table = 'afiliacion'


class almacen(models.Model):
    alm_id = models.AutoField(primary_key=True)
    alm_nombre = models.CharField(max_length=100)
    alm_descripcion = models.TextField()
    fk_tienda = models.ForeignKey('tienda', models.DO_NOTHING, db_column='fk_tienda')

    class Meta:
        managed = True
        db_table = 'almacen'

    def __str__(self):
        return self.alm_nombre

class anaquel(models.Model):
    ana_id = models.AutoField(primary_key=True)
    ana_numero = models.IntegerField()
    fk_lugar_tienda = models.ForeignKey('lugar_tienda', models.DO_NOTHING, db_column='fk_lugar_tienda')

    class Meta:
        managed = True
        db_table = 'anaquel'

    def __str__(self):
        return str(self.ana_numero)


class asistencia(models.Model):
    asi_id = models.AutoField(primary_key=True)
    asi_fecha_hora_inico = models.DateTimeField()
    asi_fecha_hora_fin = models.DateTimeField(blank=True, null=True)
    fk_empleado = models.ForeignKey('empleado', models.DO_NOTHING, db_column='fk_empleado')

    class Meta:
        managed = True
        db_table = 'asistencia'


class asistencia_evento(models.Model):
    asi_eve_id = models.AutoField(primary_key=True)
    fk_evento = models.ForeignKey('evento', models.DO_NOTHING, db_column='fk_evento')
    fk_cliente = models.ForeignKey('cliente', models.DO_NOTHING, db_column='fk_cliente')
    asi_eve_fecha_hora = models.DateTimeField()
    fk_ven_bol_eve = models.ForeignKey('venta_boleto_evento', models.DO_NOTHING, db_column='fk_ven_bol_eve')

    class Meta:
        managed = True
        db_table = 'asistencia_evento'


class car_tip_cer(models.Model):
    fk_caracteristica = models.ForeignKey('caracteristica', models.DO_NOTHING, db_column='fk_caracteristica')
    fk_tipo_cerveza = models.ForeignKey('tipo_cerveza', models.DO_NOTHING, db_column='fk_tipo_cerveza')
    carac_tip_cer_valor = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'car_tip_cer'


class caracteristica(models.Model):
    car_id = models.AutoField(primary_key=True)
    car_nombre = models.CharField(max_length=255)
    car_descripcion = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'caracteristica'


class cargo(models.Model):
    car_id = models.AutoField(primary_key=True)
    car_nombre = models.CharField(unique=True, max_length=100)
    car_descripcion = models.TextField()
    car_salario = models.IntegerField()

    class Meta:
        managed = True
        db_table = 'cargo'


class cerv_car(models.Model):
    fk_cerveza = models.ForeignKey('cerveza', models.DO_NOTHING, db_column='fk_cerveza')
    fk_caracteristica = models.ForeignKey(caracteristica, models.DO_NOTHING, db_column='fk_caracteristica')
    carac_cer_valor = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'cerv_car'


class cerveza(models.Model):
    cer_id = models.AutoField(primary_key=True)
    cer_nombre = models.CharField(max_length=255)
    cer_descripcion = models.CharField(max_length=255)
    cer_grado_alcohol = models.DecimalField(max_digits=5, decimal_places=2)
    fk_tipo_estilo_cerveza = models.ForeignKey('tipo_estilo_cerveza', models.DO_NOTHING, db_column='fk_tipo_estilo_cerveza')

    class Meta:
        managed = True
        db_table = 'cerveza'

    def __str__(self):
        return self.cer_nombre


class cliente(models.Model):
    cli_id = models.AutoField(primary_key=True)
    cli_rif = models.CharField(unique=True, max_length=12)
    cli_direccion_fisica = models.CharField(max_length=255)
    cli_tipo_cliente = models.CharField(max_length=10)
    cli_nat_ci = models.CharField(unique=True, max_length=12, blank=True, null=True)
    cli_nat_pnombre = models.CharField(max_length=50, blank=True, null=True)
    cli_nat_snombre = models.CharField(max_length=50, blank=True, null=True)
    cli_nat_papellido = models.CharField(max_length=50, blank=True, null=True)
    cli_nat_sapellido = models.CharField(max_length=50, blank=True, null=True)
    cli_nat_sexo = models.CharField(max_length=1, blank=True, null=True)
    cli_jur_denom_comercial = models.CharField(max_length=70, blank=True, null=True)
    cli_jur_razon_social = models.CharField(max_length=70, blank=True, null=True)
    cli_jur_url_web = models.CharField(max_length=255, blank=True, null=True)
    cli_jur_capital = models.IntegerField(blank=True, null=True)
    cli_jur_dir_fiscal = models.CharField(max_length=255, blank=True, null=True)
    fk_lugar = models.ForeignKey('Lugar', models.DO_NOTHING, db_column='fk_lugar')
    cli_cantidad_puntos = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'cliente'

    def __str__(self):
        if self.cli_tipo_cliente == 'JURIDICO':
            return self.cli_jur_razon_social or "(Razón Social no especificada)"
        else:
            nombre = self.cli_nat_pnombre or ""
            apellido = self.cli_nat_papellido or ""
            return f"{nombre} {apellido}".strip() or "(Nombre no especificado)"


class contacto_cliente(models.Model):
    con_cli_id = models.AutoField(primary_key=True)
    con_cli_nombre = models.CharField(max_length=50)
    con_cli_apellido = models.CharField(max_length=50)
    fk_cliente = models.ForeignKey(cliente, models.DO_NOTHING, db_column='fk_cliente')

    class Meta:
        managed = True
        db_table = 'contacto_cliente'


class contacto_proveedor(models.Model):
    con_pro_id = models.AutoField(primary_key=True)
    con_pro_nombre = models.CharField(max_length=50)
    con_pro_apellido = models.CharField(max_length=50)
    fk_proveedor = models.ForeignKey('Proveedor', models.DO_NOTHING, db_column='fk_proveedor')

    class Meta:
        managed = True
        db_table = 'contacto_proveedor'


class correo_electronico(models.Model):
    cor_ele_id = models.AutoField(primary_key=True)
    cor_ele_direccion = models.CharField(max_length=70)
    fk_empleado = models.ForeignKey('Empleado', models.DO_NOTHING, db_column='fk_empleado', blank=True, null=True)
    fk_cliente = models.ForeignKey(cliente, models.DO_NOTHING, db_column='fk_cliente', blank=True, null=True)
    fk_contacto_cliente = models.ForeignKey(contacto_cliente, models.DO_NOTHING, db_column='fk_contacto_cliente', blank=True, null=True)
    fk_contacto_proveedor = models.ForeignKey(contacto_proveedor, models.DO_NOTHING, db_column='fk_contacto_proveedor', blank=True, null=True)
    fk_proveedor = models.ForeignKey('Proveedor', models.DO_NOTHING, db_column='fk_proveedor', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'correo_electronico'


class cuenta_punto(models.Model):
    cue_pun_id = models.AutoField(primary_key=True)
    cue_pun_cantidad = models.DecimalField(max_digits=12, decimal_places=2)
    fk_cliente = models.ForeignKey(cliente, models.DO_NOTHING, db_column='fk_cliente')
    fk_venta_fisica = models.IntegerField()

    class Meta:
        managed = True
        db_table = 'cuenta_punto'


class dep_tie(models.Model):
    fk_departamento = models.ForeignKey('Departamento', models.DO_NOTHING, db_column='fk_departamento')
    fk_tienda = models.ForeignKey('tienda', models.DO_NOTHING, db_column='fk_tienda')
    dep_tie_fecha_inicio = models.DateField()
    dep_tie_fecha_fin = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'dep_tie'


class departamento(models.Model):
    dep_id = models.AutoField(primary_key=True)
    dep_nombre = models.CharField(unique=True, max_length=100)
    dep_descripcion = models.TextField()

    class Meta:
        managed = True
        db_table = 'departamento'


class detalle_compra(models.Model):
    det_com_id = models.AutoField(primary_key=True)
    det_com_cantidad = models.IntegerField()
    det_com_precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    fk_sol_com = models.ForeignKey('solicitud_compra' \
    '', models.DO_NOTHING, db_column='fk_sol_com')
    fk_presentacion = models.ForeignKey('presentacion', models.DO_NOTHING, db_column='fk_presentacion')

    class Meta:
        managed = True
        db_table = 'detalle_compra'


class detalle_venta_evento(models.Model):
    det_ven_eve_id = models.AutoField(primary_key=True)
    det_ven_eve_cantidad = models.IntegerField()
    det_ven_eve_precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    fk_venta_evento = models.ForeignKey('venta_evento', models.DO_NOTHING, db_column='fk_venta_evento')
    fk_exi_eve = models.ForeignKey('existencia_evento', models.DO_NOTHING, db_column='fk_exi_eve')

    class Meta:
        managed = True
        db_table = 'detalle_venta_evento'


class detalle_venta_fisica(models.Model):
    det_ven_fis_id = models.AutoField(primary_key=True)
    det_ven_fis_cantidad = models.IntegerField()
    det_ven_fis_precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    fk_venta_fisica = models.ForeignKey('venta_fisica', models.DO_NOTHING, db_column='fk_venta_fisica')
    fk_inventario = models.ForeignKey('inventario', models.DO_NOTHING, db_column='fk_inventario')

    class Meta:
        managed = True
        db_table = 'detalle_venta_fisica'


class detalle_venta_online(models.Model):
    det_ven_onl_id = models.AutoField(primary_key=True)  # <- clave primaria explícita
    det_ven_onl_cantidad = models.IntegerField()
    det_ven_onl_precio = models.DecimalField(max_digits=10, decimal_places=2)
    fk_venta_online = models.ForeignKey('venta_online', models.DO_NOTHING, db_column='fk_venta_online')
    fk_pre_alm = models.ForeignKey('pre_alm', models.DO_NOTHING, db_column='fk_pre_alm')

    class Meta:
        managed = True
        db_table = 'detalle_venta_online'

class emp_car(models.Model):
    id = models.AutoField(primary_key=True)
    fk_empleado = models.ForeignKey('empleado', models.DO_NOTHING, db_column='fk_empleado')
    fk_cargo = models.ForeignKey('cargo', models.DO_NOTHING, db_column='fk_cargo')
    fk_departamento = models.IntegerField()
    fk_tienda = models.IntegerField()
    emp_car_fecha_inicio = models.DateField()
    emp_car_fecha_fin = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'emp_car'
        unique_together = (('fk_empleado', 'fk_cargo', 'fk_departamento', 'fk_tienda'),)


class emp_car_hor(models.Model):
    fk_empleado = models.ForeignKey('empleado', models.DO_NOTHING, db_column='fk_empleado')
    fk_cargo = models.ForeignKey(cargo, models.DO_NOTHING, db_column='fk_cargo')
    fk_departamento = models.ForeignKey(departamento, models.DO_NOTHING, db_column='fk_departamento')
    fk_tienda = models.ForeignKey('tienda', models.DO_NOTHING, db_column='fk_tienda')
    fk_horario = models.ForeignKey('horario', models.DO_NOTHING, db_column='fk_horario')

    class Meta:
        managed = True
        db_table = 'emp_car_hor'


class emp_tip_ben(models.Model):
    fk_empleado = models.ForeignKey('empleado', models.DO_NOTHING, db_column='fk_empleado')
    fk_tipo_beneficio = models.ForeignKey('tipo_beneficio', models.DO_NOTHING, db_column='fk_tipo_beneficio')
    emp_tip_ben_monto = models.IntegerField()

    class Meta:
        managed = True
        db_table = 'emp_tip_ben'


class empleado(models.Model):
    emp_id = models.AutoField(primary_key=True)
    emp_ci = models.CharField(unique=True, max_length=12)
    emp_pnombre = models.CharField(max_length=30)
    emp_snombre = models.CharField(max_length=30, blank=True, null=True)
    emp_papellido = models.CharField(max_length=30)
    emp_sapellido = models.CharField(max_length=30, blank=True, null=True)
    emp_direccion = models.CharField(max_length=70)
    emp_fecha_nacimiento = models.DateField()
    emp_sexo = models.CharField(max_length=1)
    fk_lugar = models.ForeignKey('lugar', models.DO_NOTHING, db_column='fk_lugar')

    class Meta:
        managed = True
        db_table = 'empleado'

    def __str__(self):
        return self.emp_pnombre + ' ' + self.emp_papellido


class estatus(models.Model):
    est_id = models.AutoField(primary_key=True)
    est_tipo_estatus = models.CharField(unique=True, max_length=50)
    est_descripcion = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'estatus'


class estilo_cerveza(models.Model):
    est_cer_id = models.AutoField(primary_key=True)
    est_cer_nombre = models.CharField(max_length=255)
    est_cer_descripcion = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'estilo_cerveza'


class eve_pro(models.Model):
    eve_pro_id = models.AutoField(primary_key=True)
    fk_evento = models.ForeignKey('evento', models.DO_NOTHING, db_column='fk_evento')
    fk_proveedor = models.ForeignKey('proveedor', models.DO_NOTHING, db_column='fk_proveedor')

    class Meta:
        managed = True
        db_table = 'eve_pro'
        unique_together = (('fk_evento', 'fk_proveedor'),)


class evento(models.Model):
    eve_id = models.AutoField(primary_key=True)
    eve_nombre = models.CharField(max_length=255)
    eve_descripcion = models.CharField(max_length=255)
    eve_fecha_hora = models.DateTimeField()
    eve_nro_boletos = models.IntegerField()
    fk_tip_eve = models.ForeignKey('tipo_evento', models.DO_NOTHING, db_column='fk_tip_eve')
    fk_lugar = models.ForeignKey('lugar', models.DO_NOTHING, db_column='fk_lugar')

    class Meta:
        managed = True
        db_table = 'evento'


class existencia_evento(models.Model):
    exi_eve_id = models.AutoField(primary_key=True)
    exi_eve_cantidad = models.IntegerField()
    fk_presentacion = models.ForeignKey('presentacion', models.DO_NOTHING, db_column='fk_presentacion')
    fk_evento_proveedor = models.ForeignKey(eve_pro, models.DO_NOTHING, db_column='fk_evento_proveedor')

    class Meta:
        managed = True
        db_table = 'existencia_evento'


class historico_moneda(models.Model):
    his_mon_id = models.AutoField(primary_key=True)
    his_mon_fecha_hora = models.DateTimeField()
    his_valor_cambio = models.DecimalField(max_digits=12, decimal_places=2)
    fk_moneda = models.ForeignKey('moneda', models.DO_NOTHING, db_column='fk_moneda')

    class Meta:
        managed = True
        db_table = 'historico_moneda'


class historico_precio_punto(models.Model):
    his_pre_pun_id = models.AutoField(primary_key=True)
    his_pre_pun_fecha_hora = models.DateTimeField()
    his_pre_pun_valor = models.IntegerField()

    class Meta:
        managed = True
        db_table = 'historico_precio_punto'


class horario(models.Model):
    hor_id = models.AutoField(primary_key=True)
    hor_dia = models.CharField(max_length=10)
    hor_hora_inicio = models.TimeField()
    hor_hora_fin = models.TimeField()

    class Meta:
        managed = True
        db_table = 'horario'


class ingrediente(models.Model):
    ing_id = models.AutoField(primary_key=True)
    ing_nombre = models.CharField(max_length=255)
    ing_descripcion = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'ingrediente'


class instruccion(models.Model):
    ins_id = models.AutoField(primary_key=True)
    ins_descripcion = models.CharField(max_length=1000)

    class Meta:
        managed = True
        db_table = 'instruccion'


class inventario(models.Model):
    inv_id = models.AutoField(primary_key=True)
    inv_cantidad = models.IntegerField()
    inv_precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    fk_anaquel = models.ForeignKey(anaquel, models.DO_NOTHING, db_column='fk_anaquel')
    fk_presentacion = models.ForeignKey('presentacion', models.DO_NOTHING, db_column='fk_presentacion')
    fk_oferta = models.ForeignKey('oferta', models.DO_NOTHING, db_column='fk_oferta', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'inventario'

class lugar(models.Model):
    lug_id = models.AutoField(primary_key=True)
    lug_nombre = models.CharField(max_length=90)
    lug_tipo = models.CharField(max_length=20, blank=True, null=True)
    fk_lugar = models.ForeignKey('self', models.DO_NOTHING, db_column='fk_lugar', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'lugar'

    def __str__(self):
        return self.lug_nombre


class lugar_tienda(models.Model):
    lug_tie_id = models.AutoField(primary_key=True)
    lug_tie_nombre = models.CharField(max_length=255)
    lug_tie_tipo = models.CharField(max_length=255)
    fk_tienda = models.ForeignKey('tienda', models.DO_NOTHING, db_column='fk_tienda')
    fk_lugar_tienda = models.ForeignKey(lugar, models.DO_NOTHING, db_column='fk_lugar_tienda', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'lugar_tienda'

    def __str__(self):
        return self.lug_tie_nombre

class metodo_pago(models.Model):
    met_pag_id = models.AutoField(primary_key=True)
    efe_denominacion = models.IntegerField(blank=True, null=True)
    che_num_cheque = models.IntegerField(blank=True, null=True)
    tar_deb_numero = models.BigIntegerField(blank=True, null=True)
    tar_deb_vencimiento = models.DateField(blank=True, null=True)
    tar_deb_banco = models.CharField(max_length=50, blank=True, null=True)
    tar_cre_numero = models.BigIntegerField(blank=True, null=True)
    tar_cre_vencimiento = models.DateField(blank=True, null=True)
    met_pag_tipo_pago = models.CharField(max_length=50)
    fk_his_pre_pun = models.ForeignKey(historico_precio_punto, models.DO_NOTHING, db_column='fk_his_pre_pun', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'metodo_pago'


class moneda(models.Model):
    mon_id = models.AutoField(primary_key=True)
    mon_tipo = models.CharField(unique=True, max_length=50)

    class Meta:
        managed = True
        db_table = 'moneda'


class oferta(models.Model):
    ofe_id = models.AutoField(primary_key=True)
    ofe_nombre = models.CharField(max_length=100)
    ofe_descripcion = models.TextField()
    ofe_fecha_inicio = models.DateField()
    ofe_fecha_fin = models.DateField(blank=True, null=True)
    of_procentaje = models.IntegerField()

    class Meta:
        managed = True
        db_table = 'oferta'


class pago(models.Model):
    pag_id = models.AutoField(primary_key=True)
    pag_monto = models.DecimalField(max_digits=12, decimal_places=2)
    pag_fecha = models.DateTimeField()
    fk_metodo_pago = models.ForeignKey('metodo_pago', models.DO_NOTHING, db_column='fk_metodo_pago')
    fk_venta_fisica = models.ForeignKey('venta_fisica', models.DO_NOTHING, db_column='fk_venta_fisica', blank=True, null=True)
    fk_venta_online = models.ForeignKey('venta_online', models.DO_NOTHING, db_column='fk_venta_online', blank=True, null=True)
    fk_afiliacion = models.ForeignKey(afiliacion, models.DO_NOTHING, db_column='fk_afiliacion', blank=True, null=True)
    fk_venta_evento = models.ForeignKey('venta_evento', models.DO_NOTHING, db_column='fk_venta_evento', blank=True, null=True)
    fk_moneda = models.ForeignKey(moneda, models.DO_NOTHING, db_column='fk_moneda')

    class Meta:
        managed = True
        db_table = 'pago'


class pago_efectivo(models.Model):
    pag_efe_id = models.AutoField(primary_key=True)
    pag_efe_monto = models.DecimalField(max_digits=10, decimal_places=2)
    pag_efe_fecha = models.DateTimeField()
    fk_sol_com = models.IntegerField()
    fk_metodo_pago = models.ForeignKey(metodo_pago, models.DO_NOTHING, db_column='fk_metodo_pago')

    class Meta:
        managed = True
        db_table = 'pago_efectivo'


class pre_alm(models.Model):
    pre_alm_id = models.AutoField(primary_key=True)
    pre_alm_precio = models.DecimalField(max_digits=10, decimal_places=2)
    pre_alm_cantidad = models.IntegerField()
    fk_almacen = models.ForeignKey(almacen, models.DO_NOTHING, db_column='fk_almacen')
    fk_presentacion = models.ForeignKey('presentacion', models.DO_NOTHING, db_column='fk_presentacion')
    fk_oferta = models.ForeignKey(oferta, models.DO_NOTHING, db_column='fk_oferta', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'pre_alm'

    def __str__(self):
        return f"{self.fk_presentacion} - {self.fk_almacen} - {self.pre_alm_precio}$"


class presentacion(models.Model):
    prese_id = models.AutoField(primary_key=True)
    prese_nombre = models.CharField(max_length=100)
    prese_volumen = models.DecimalField(max_digits=10, decimal_places=2)
    prese_recipiente = models.CharField(max_length=255)
    fk_cerveza = models.ForeignKey(cerveza, models.DO_NOTHING, db_column='fk_cerveza', blank=True, null=True)
    prese_imagen = models.ImageField(upload_to='productos/', null=True, blank=True)
    prese_precio = models.DecimalField(max_digits=10, decimal_places=2)
    prese_alto = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    prese_ancho = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'presentacion'

    def __str__(self):
        return self.prese_nombre
    
    def get_precio_actual(self):
        prealm = self.pre_alm_set.first()
        return prealm.pre_alm_precio if prealm else None

class proveedor(models.Model):
    pro_id = models.AutoField(primary_key=True)
    pro_rif = models.CharField(unique=True, max_length=12)
    pro_denominacion_comercial = models.CharField(max_length=70, blank=True, null=True)
    pro_razon_social = models.CharField(max_length=70, blank=True, null=True)
    pro_url_web = models.CharField(max_length=255, blank=True, null=True)
    pro_direccion_fiscal = models.CharField(max_length=255, blank=True, null=True)
    fk_lugar = models.ForeignKey(lugar, models.DO_NOTHING, db_column='fk_lugar')

    class Meta:
        managed = True
        db_table = 'proveedor'

    def __str__(self):
        return f"{self.pro_razon_social or self.pro_denominacion_comercial or self.pro_rif}"


class rec_ing(models.Model):
    rec_ing_id = models.AutoField(primary_key=True)
    fk_receta = models.ForeignKey('receta', models.DO_NOTHING, db_column='fk_receta')
    fk_ingrediente = models.ForeignKey(ingrediente, models.DO_NOTHING, db_column='fk_ingrediente')
    rec_ing_cantidad = models.DecimalField(max_digits=10, decimal_places=3)

    class Meta:
        managed = True
        db_table = 'rec_ing'


class rec_ins(models.Model):
    rec_ins_id = models.AutoField(primary_key=True)
    fk_receta = models.ForeignKey('receta', models.DO_NOTHING, db_column='fk_receta')
    fk_instruccion = models.ForeignKey(instruccion, models.DO_NOTHING, db_column='fk_instruccion')

    class Meta:
        managed = True
        db_table = 'rec_ins'


class receta(models.Model):
    rec_id = models.AutoField(primary_key=True)
    rec_nombre = models.CharField(max_length=255)
    rec_descripcion = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'receta'


class sol_com_est(models.Model):
    sol_com_est_id = models.AutoField(primary_key=True)
    sol_com_est_fecha_inicio = models.DateField()
    sol_com_est_fecha_fin = models.DateField(blank=True, null=True)
    fk_sol_com = models.ForeignKey('solicitud_compra', models.DO_NOTHING, db_column='fk_sol_com')
    fk_estatus = models.ForeignKey(estatus, models.DO_NOTHING, db_column='fk_estatus')

    class Meta:
        managed = True
        db_table = 'sol_com_est'


class sol_rep_est(models.Model):
    sol_rep_est_id = models.AutoField(primary_key=True)
    sol_rep_est_fecha_inicio = models.DateField()
    sol_rep_est_fecha_fin = models.DateField(blank=True, null=True)
    fk_sol_rep = models.ForeignKey('solicitud_reposicion', models.DO_NOTHING, db_column='fk_sol_rep')
    fk_estatus = models.ForeignKey(estatus, models.DO_NOTHING, db_column='fk_estatus')

    class Meta:
        managed = True
        db_table = 'sol_rep_est'


class solicitud_compra(models.Model):
    sol_com_id = models.AutoField(primary_key=True)
    sol_com_fecha = models.DateTimeField()
    sol_com_total = models.DecimalField(max_digits=10, decimal_places=2)
    fk_proveedor = models.ForeignKey(proveedor, models.DO_NOTHING, db_column='fk_proveedor')
    fk_pre_alm = models.ForeignKey(pre_alm, models.DO_NOTHING, db_column='fk_pre_alm')
    fk_usuario = models.ForeignKey('usuario', on_delete=models.DO_NOTHING, db_column='fk_usuario', null=True, blank=True)
    
    class Meta:
        managed = True
        db_table = 'solicitud_compra'


class solicitud_reposicion(models.Model):
    sol_rep_id = models.AutoField(primary_key=True)
    sol_rep_fecha_hora = models.DateTimeField()
    sol_rep_descripcion = models.CharField(max_length=255)
    fk_inv = models.ForeignKey(inventario, models.DO_NOTHING, db_column='fk_inv')
    fk_pre_alm = models.ForeignKey(pre_alm, models.DO_NOTHING, db_column='fk_pre_alm')
    fk_usuario = models.ForeignKey('usuario', on_delete=models.DO_NOTHING, db_column='fk_usuario', null=True, blank=True)

    class Meta:
        managed = True
        db_table = 'solicitud_reposicion'


class telefono(models.Model):
    tel_id = models.AutoField(primary_key=True)
    tel_codigo_area = models.CharField(max_length=30)
    tel_numero = models.BigIntegerField()
    fk_empleado = models.ForeignKey(empleado, models.DO_NOTHING, db_column='fk_empleado', blank=True, null=True)
    fk_cliente = models.ForeignKey(cliente, models.DO_NOTHING, db_column='fk_cliente', blank=True, null=True)
    fk_contacto_cliente = models.ForeignKey(contacto_cliente, models.DO_NOTHING, db_column='fk_contacto_cliente', blank=True, null=True)
    fk_contacto_proveedor = models.ForeignKey(contacto_proveedor, models.DO_NOTHING, db_column='fk_contacto_proveedor', blank=True, null=True)
    fk_proveedor = models.ForeignKey(proveedor, models.DO_NOTHING, db_column='fk_proveedor', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'telefono'


class tienda(models.Model):
    tie_id = models.AutoField(primary_key=True)
    tie_nombre = models.CharField(max_length=150)
    tie_direccion = models.CharField(max_length=255)
    tie_tipo = models.CharField(max_length=20)
    fk_lugar = models.ForeignKey(lugar, models.DO_NOTHING, db_column='fk_lugar')

    class Meta:
        managed = True
        db_table = 'tienda'

    def __str__(self):
        return self.tie_nombre


class tipo_beneficio(models.Model):
    tip_ben_id = models.AutoField(primary_key=True)
    tip_ben_nombre = models.CharField(unique=True, max_length=255)
    tip_ben_descripcion = models.TextField()

    class Meta:
        managed = True
        db_table = 'tipo_beneficio'

    def __str__(self):
        return self.tip_ben_nombre


class tipo_cerveza(models.Model):
    tip_cer_id = models.AutoField(primary_key=True)
    tip_cer_familia = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'tipo_cerveza'

    def __str__(self):
        return self.tip_cer_familia


class tipo_estilo_cerveza(models.Model):
    tip_est_cer_id = models.AutoField(primary_key=True)
    tip_est_cer_nombre = models.CharField(max_length=255)
    tip_est_cer_descripcion = models.CharField(max_length=255)
    fk_estilo_cerveza = models.ForeignKey(estilo_cerveza, models.DO_NOTHING, db_column='fk_estilo_cerveza')
    fk_tipo_cerveza = models.ForeignKey(tipo_cerveza, models.DO_NOTHING, db_column='fk_tipo_cerveza')

    class Meta:
        managed = True
        db_table = 'tipo_estilo_cerveza'

    def __str__(self):
        return self.tip_est_cer_nombre


class tipo_evento(models.Model):
    tip_eve_id = models.AutoField(primary_key=True)
    tip_eve_nombre = models.CharField(max_length=255)
    tip_eve_descripcion = models.CharField(max_length=255)
    fk_tipo_evento = models.ForeignKey('self', models.DO_NOTHING, db_column='fk_tipo_evento', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'tipo_evento'

class usuario(AbstractUser):
    fk_cliente = models.ForeignKey(cliente, on_delete=models.DO_NOTHING, db_column='fk_cliente', null=True, blank=True)
    fk_proveedor = models.ForeignKey('proveedor', on_delete=models.DO_NOTHING, db_column='fk_proveedor', null=True, blank=True)
    
    class Meta:
        db_table = 'usuario'  # Esto cambia el nombre de la tabla a 'usuario'

    def __str__(self):
        return self.username
        
class vacacion(models.Model):
    vac_id = models.AutoField(primary_key=True)
    vac_fecha_inicio = models.DateField()
    vac_fecha_fin = models.DateField(blank=True, null=True)
    fk_empleado = models.ForeignKey(empleado, models.DO_NOTHING, db_column='fk_empleado')

    class Meta:
        managed = True
        db_table = 'vacacion'


class ven_onl_est(models.Model):
    ven_onl_est_id = models.AutoField(primary_key=True)
    ven_onl_est_fecha_inicio = models.DateField()
    ven_onl_est_fecha_fin = models.DateField(blank=True, null=True)
    fk_venta_online = models.ForeignKey('venta_online', models.DO_NOTHING, db_column='fk_venta_online')
    fk_estatus = models.ForeignKey(estatus, models.DO_NOTHING, db_column='fk_estatus')

    class Meta:
        managed = True
        db_table = 'ven_onl_est'


class venta_boleto_evento(models.Model):
    ven_bol_eve_id = models.AutoField(primary_key=True)
    ven_bol_eve_fecha_hora = models.DateTimeField()
    ven_bol_eve_monto_total = models.DecimalField(max_digits=18, decimal_places=2)
    ven_bol_eve_descripcion = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'venta_boleto_evento'


class venta_evento(models.Model):
    ven_eve_id = models.AutoField(primary_key=True)
    ven_eve_fecha_hora = models.DateTimeField()
    ven_eve_monto_total = models.DecimalField(max_digits=18, decimal_places=2)
    fk_evento = models.ForeignKey(evento, models.DO_NOTHING, db_column='fk_evento')
    fk_cliente = models.ForeignKey(cliente, models.DO_NOTHING, db_column='fk_cliente')

    class Meta:
        managed = True
        db_table = 'venta_evento'


class venta_fisica(models.Model):
    ven_fis_id = models.AutoField(primary_key=True)
    ven_fis_fecha = models.DateField()
    ven_fis_total = models.IntegerField()
    fk_tienda = models.ForeignKey(tienda, models.DO_NOTHING, db_column='fk_tienda')
    fk_cliente = models.ForeignKey(cliente, models.DO_NOTHING, db_column='fk_cliente')
    fk_oferta = models.ForeignKey(oferta, models.DO_NOTHING, db_column='fk_oferta', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'venta_fisica'


class venta_online(models.Model):
    ven_onl_id = models.AutoField(primary_key=True)
    ven_onl_fecha = models.DateField()
    ven_onl_total = models.IntegerField()
    fk_oferta = models.ForeignKey(oferta, models.DO_NOTHING, db_column='fk_oferta', blank=True, null=True)
    fk_usuario = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, db_column='fk_usuario')
    fk_tienda = models.ForeignKey(tienda, models.DO_NOTHING, db_column='fk_tienda')

    class Meta:
        db_table = 'venta_online'

    def __str__(self):
        return f"Venta #{self.ven_onl_id} por {self.fk_usuario.username}"