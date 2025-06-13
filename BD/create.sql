/*
--Archivo create para la primera entrega de codigo de la base de datos.
*/
/************************************************************/
/***************** CREACIÓN DE TABLAS ***********************/
/************************************************************/

-- Tabla: LUGAR
CREATE TABLE LUGAR (
    lug_id INT NOT NULL, -- Identificador único del lugar.
    lug_nombre VARCHAR(255) NOT NULL, -- Nombre del lugar.
    lug_tipo VARCHAR(255) NOT NULL, -- Descripción del lugar.
    FK_lugar INT, -- Clave foránea que referencia a lugar.
    PRIMARY KEY (lug_id)
);

-- Tabla: TIENDA
CREATE TABLE TIENDA (
    tie_id INT NOT NULL, -- Identificador único de la tienda.
    tie_nombre VARCHAR(255) NOT NULL, -- Nombre de la tienda.
    tie_direccion VARCHAR(255) NOT NULL, -- Dirección de la tienda.
    FK_lugar INT NOT NULL, -- Clave foránea que hace referencia al lugar (ubicación) de la tienda.
    PRIMARY KEY (tie_id)
);

-- Tabla: CARGO
CREATE TABLE CARGO (
    car_id INT NOT NULL, -- Identificador único del cargo.
    car_nombre VARCHAR(255) NOT NULL, -- Nombre del cargo.
    car_descripcion VARCHAR(255) NOT NULL, -- Descripción del cargo.
    PRIMARY KEY (car_id)
);

-- Tabla: EMPLEADO
CREATE TABLE EMPLEADO (
    emp_id INT NOT NULL, -- Identificador único del empleado.
    emp_ci INT NOT NULL, -- Cédula de identidad del empleado.
    emp_pnombre VARCHAR(255) NOT NULL, -- Primer nombre del empleado.
    emp_snombres VARCHAR(255), -- Segundos nombres del empleado.
    emp_papellido VARCHAR(255) NOT NULL, -- Primer apellido del empleado.
    emp_sapellido VARCHAR(255), -- Segundo apellido del empleado.
    emp_fecha_nacimiento DATETIME NOT NULL, -- Fecha de nacimiento del empleado.
    FK_lugar INT NOT NULL, -- Clave foránea que hace referencia al lugar (ubicación) del empleado.
    FK_tienda INT NOT NULL, -- Clave foránea que hace referencia a la tienda donde trabaja el empleado.
    emp_sexo VARCHAR(50) NOT NULL CHECK (emp_sexo IN ('Masculino', 'femenino')), -- Sexo del empleado (Masculino o Femenino).
    PRIMARY KEY (emp_id)
);

-- Tabla: EMP_CAR
CREATE TABLE EMP_CAR (
    emp_car_id INT NOT NULL, -- Identificador único del cargo del empleado.
    FK_empleado INT NOT NULL, -- Clave foránea que referencia al empleado asociado al cargo.
    FK_cargo INT NOT NULL, -- Clave foránea que referencia el cargo del empleado.
    emc_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio del empleado en el cargo.
    emc_fecha_fin DATETIME NOT NULL, -- Fecha de fin del empleado en el cargo.
    PRIMARY KEY (emp_car_id, FK_empleado, FK_cargo)
);

-- Tabla: CLIENTE
CREATE TABLE CLIENTE (
    cli_id INT NOT NULL, -- Identificador único del cliente.
    cli_rif VARCHAR(20) NOT NULL, -- Número de Registro de Identificación Fiscal (RIF) del cliente.
    cli_direccion_fisica VARCHAR(255) NOT NULL, -- Dirección física del cliente.
    cli_nat_ci INT, -- Cédula de identidad (CI) del cliente natural.
    cli_nat_pnombre VARCHAR(255), -- Primer nombre del cliente natural.
    cli_nat_snombre VARCHAR(255), -- Segundo nombre del cliente natural.
    cli_nat_papellido VARCHAR(255), -- Primer apellido del cliente natural.
    cli_nat_sapellido VARCHAR(255), -- Segundo apellido del cliente natural.
    cli_nat_sexo CHAR(1) CHECK (cli_nat_sexo IN ('M', 'F')), -- Sexo del cliente natural (Masculino o Femenino).
    cli_jur_denom_comercial VARCHAR(255), -- Denominación comercial del cliente jurídico.
    cli_jur_razon_social VARCHAR(255), -- Razón social del cliente jurídico.
    cli_jur_url_web VARCHAR(255), -- URL web del cliente jurídico.
    cli_jur_capital VARCHAR(255), -- Capital del cliente jurídico.
    cli_jur_dir_fiscal VARCHAR(255), -- Dirección fiscal del cliente jurídico.
    cli_tipo_cliente VARCHAR(50) NOT NULL CHECK (cli_tipo_cliente IN ('NATURAL', 'JURIDICO')), -- Tipo de cliente (NATURAL o JURIDICO).
    FK_lugar INT NOT NULL, -- Clave foránea que referencia el lugar asociado al cliente.
    PRIMARY KEY (cli_id)
);

-- Tabla: PROVEEDOR
CREATE TABLE PROVEEDOR (
    pro_id INT NOT NULL, -- Identificador único del proveedor.
    pro_rif VARCHAR(20) NOT NULL, -- Registro de Identificación Fiscal (RIF) del proveedor.
    pro_razon_social VARCHAR(255) NOT NULL, -- Razón social del proveedor.
    pro_denominacion_comercial VARCHAR(255) NOT NULL, -- Denominación comercial del proveedor.
    pro_direccion_fisica VARCHAR(255) NOT NULL, -- Dirección física del proveedor.
    pro_url_web VARCHAR(255) NOT NULL, -- URL web del proveedor.
    FK_lugar INT NOT NULL, -- Clave foránea que referencia el lugar (ubicación) del proveedor.
    PRIMARY KEY (pro_id)
);

-- Tabla: ROL
CREATE TABLE ROL (
    rol_id INT NOT NULL, -- Identificador único del rol.
    rol_nombre VARCHAR(255) NOT NULL, -- Nombre del rol.
    rol_descripcion VARCHAR(255) NOT NULL, -- Descripción del rol.
    PRIMARY KEY (rol_id)
);

-- Tabla: USUARIO
CREATE TABLE USUARIO (
    usu_id INT NOT NULL, -- Identificador único del usuario.
    usu_nombre_usuario VARCHAR(255) NOT NULL, -- Nombre de usuario del usuario.
    usu_contraseña VARCHAR(255) NOT NULL, -- Contraseña del usuario.
    usu_email VARCHAR(255) NOT NULL, -- Correo electrónico del usuario.
    FK_emp_car1 INT, -- Clave foránea que referencia una de las claves de EMP_CAR
    FK_emp_car2 INT, -- Clave foránea que referencia una de las claves de EMP_CAR
    FK_emp_car3 INT, -- Clave foránea que referencia una de las claves de EMP_CAR
    FK_cliente INT, -- Clave foránea que referencia el cliente asociado al usuario.
    FK_proveedor INT, -- Clave foránea que referencia el proveedor asociado al usuario.
    FK_rol INT NOT NULL, -- Clave foránea que referencia el rol del usuario.
    PRIMARY KEY (usu_id)
);

-- Tabla: TIPO_EVENTO
CREATE TABLE TIPO_EVENTO (
    tip_eve_id INT NOT NULL, -- Identificador único del tipo de evento.
    tip_eve_nombre VARCHAR(255) NOT NULL, -- Nombre del tipo de evento.
    tip_eve_descripcion VARCHAR(255) NOT NULL, -- Descripción del tipo de evento.
    PRIMARY KEY (tip_eve_id)
);

-- Tabla: EVENTO
CREATE TABLE EVENTO (
    eve_id INT NOT NULL, -- Identificador único del evento.
    eve_nombre VARCHAR(255) NOT NULL, -- Nombre del evento.
    eve_descripcion VARCHAR(255) NOT NULL, -- Descripción detallada del evento.
    eve_fecha_hora DATETIME NOT NULL, -- Fecha y hora en que el evento tendrá lugar.
    eve_nro_boletos INT NOT NULL, -- Número total de boletos disponibles para el evento.
    FK_tip_eve INT NOT NULL, -- Clave foránea que referencia el tipo de evento.
    PRIMARY KEY (eve_id)
);

-- Tabla: VENTA_EVENTO
CREATE TABLE VENTA_EVENTO (
    ven_eve_id INT NOT NULL, -- Identificador único de la venta del evento.
    ven_eve_fecha_hora DATETIME NOT NULL, -- Fecha y hora en que se realizó la venta del evento.
    ven_eve_monto_total DECIMAL(18, 2) NOT NULL, -- Monto total de la venta del evento.
    ven_eve_descripcion VARCHAR(255) NOT NULL, -- Descripción de la venta del evento.
    FK_evento INT NOT NULL, -- Clave foránea que referencia el evento asociado a la venta.
    PRIMARY KEY (ven_eve_id)
);

-- Tabla: ASISTENCIA_EVENTO
CREATE TABLE ASISTENCIA_EVENTO (
    asi_eve_id INT NOT NULL, -- Identificador único de la asistencia al evento.
    FK_evento INT NOT NULL, -- Clave foránea que referencia el evento al que se asistió.
    FK_cliente INT, -- Clave foránea que referencia al cliente que asistió al evento.
    asi_eve_fecha_hora DATETIME NOT NULL, -- Fecha y hora en que el cliente asistió al evento.
    PRIMARY KEY (asi_eve_id, FK_evento)
);

-- Tabla: VENTA_BOLETO_EVENTO
CREATE TABLE VENTA_BOLETO_EVENTO (
    ven_bol_eve_id INT NOT NULL, -- Identificador único de la venta del boleto del evento.
    ven_bol_eve_fecha_hora DATETIME NOT NULL, -- Fecha y hora en que se realizó la venta del boleto del evento.
    ven_bol_eve_monto_total DECIMAL(18, 2) NOT NULL, -- Monto total de la venta del boleto del evento.
    ven_bol_eve_descripcion VARCHAR(255) NOT NULL, -- Descripción de la venta del boleto del evento.
    FK_asi_eve_id INT NOT NULL, -- FK para asi_eve_id de ASISTENCIA_EVENTO
    FK_asi_eve_evento INT NOT NULL, -- FK para FK_evento de ASISTENCIA_EVENTO
    PRIMARY KEY (ven_bol_eve_id)
);

-- Tabla: EVE_PRO
CREATE TABLE EVE_PRO (
    eve_pro_id INT NOT NULL, -- identificador único de EVE_PRO.
    FK_evento INT NOT NULL, -- Clave foránea que referencia el evento asociado a EVE_PRO.
    FK_proveedor INT NOT NULL, -- Clave foránea que referencia el proveedor asociado a EVE_PRO.
    PRIMARY KEY (eve_pro_id, FK_evento, FK_proveedor)
);

-- Tabla: TIPO_CERVEZA
CREATE TABLE TIPO_CERVEZA (
    tip_cer_id INT NOT NULL, -- Identificador único del tipo de cerveza.
    tip_cer_familia VARCHAR(255) NOT NULL CHECK (tip_cer_familia IN ('Lager', 'Ale', 'Wheat Beer')), -- Familia o clasificación del tipo de cerveza.
    PRIMARY KEY (tip_cer_id)
);

-- Tabla: CERVEZA
CREATE TABLE CERVEZA (
    cer_id INT NOT NULL, -- Identificador único de la cerveza.
    cer_nombre VARCHAR(255) NOT NULL, -- Nombre de la cerveza.
    cer_descripcion VARCHAR(255) NOT NULL, -- Descripción de la cerveza.
    cer_grado_alcohol DECIMAL(5, 2) NOT NULL, -- Grado de alcohol de la cerveza.
    FK_tipo_cerveza INT NOT NULL, -- Clave foránea que referencia el tipo de cerveza.
    PRIMARY KEY (cer_id)
);

-- Tabla: PRESENTACION
CREATE TABLE PRESENTACION (
    prese_id INT NOT NULL, -- Identificador único de la presentación.
    prese_volumen DECIMAL(10, 2) NOT NULL, -- Volumen de la presentación.
    prese_recipiente VARCHAR(255) NOT NULL, -- Tipo de recipiente de la presentación.
    FK_cerveza INT, -- Clave foránea que referencia la cerveza asociada a la presentación.
    prese_imagen VARCHAR(255) NOT NULL, -- Imagen de la presentación del producto.
    PRIMARY KEY (prese_id)
);

-- Tabla: OFERTA
CREATE TABLE OFERTA (
    ofe_id INT NOT NULL, -- Identificador único de la oferta.
    ofe_nombre VARCHAR(255) NOT NULL, -- Nombre de la oferta.
    ofe_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio de la oferta.
    ofe_fecha_fin DATETIME NOT NULL, -- Fecha de fin de la oferta.
    ofe_descripcion VARCHAR(255) NOT NULL, -- Descripción de la oferta.
    ofe_porcentaje DECIMAL(5, 2) NOT NULL, -- Porcentaje de la oferta.
    PRIMARY KEY (ofe_id)
);

-- Tabla: ALMACEN
CREATE TABLE ALMACEN (
    alm_id INT NOT NULL, -- Identificador único del almacén.
    alm_nombre VARCHAR(255) NOT NULL, -- Nombre del almacén.
    alm_descripcion VARCHAR(255) NOT NULL, -- Descripción del almacén.
    FK_tienda INT NOT NULL, -- Clave foránea que referencia la tienda asociada al almacén.
    PRIMARY KEY (alm_id)
);

-- Tabla: PRE_ALM
CREATE TABLE PRE_ALM (
    pre_alm_id INT NOT NULL, -- Identificador único de la relación cerveza-almacén.
    FK_presentacion INT NOT NULL, -- Clave foránea que referencia a la cerveza.
    FK_almacen INT NOT NULL, -- Clave foránea que referencia al almacén.
    pre_alm_precio DECIMAL(18, 2) NOT NULL, -- Precio de la cerveza en el almacén.
    pre_alm_cantidad INT NOT NULL, -- Cantidad de cervezas en el almacén.
    FK_oferta INT, -- Clave foránea que referencia a la oferta (si aplica).
    PRIMARY KEY (pre_alm_id, FK_presentacion, FK_almacen)
);

-- Tabla: EXISTENCIA_EVENTO
CREATE TABLE EXISTENCIA_EVENTO (
    exi_eve_id INT NOT NULL, -- Identificador único de la existencia del evento.
    FK_presentacion INT NOT NULL, -- Clave foránea que referencia la cerveza asociada a la existencia del evento.
    FK_eve_pro_id INT NOT NULL, -- FK a eve_pro_id de EVE_PRO
    FK_eve_pro_evento INT NOT NULL, -- FK a FK_evento de EVE_PRO
    FK_eve_pro_proveedor INT NOT NULL, -- FK a FK_proveedor de EVE_PRO
    exi_eve_cantidad INT NOT NULL, -- Cantidad de existencias disponibles para el evento.
    exi_eve_precio DECIMAL(18, 2) NOT NULL, -- Precio de la existencia para el evento.
    PRIMARY KEY (exi_eve_id, FK_presentacion, FK_eve_pro_id, FK_eve_pro_evento, FK_eve_pro_proveedor)
);

-- Tabla: DETALLE_VENTA_EVENTO
CREATE TABLE DETALLE_VENTA_EVENTO (
    det_ven_eve_id INT NOT NULL, -- Identificador único del detalle de la venta del evento.
    FK_ven_eve INT NOT NULL, -- Clave foránea que referencia la venta del evento asociada al detalle.
    FK_exi_eve_id INT NOT NULL,
    FK_exi_eve_presentacion INT NOT NULL,
    FK_exi_eve_pro_id INT NOT NULL,
    FK_exi_eve_pro_evento INT NOT NULL,
    FK_exi_eve_pro_proveedor INT NOT NULL,
    det_ven_eve_precio_unitario DECIMAL(18, 2) NOT NULL, -- Precio unitario del detalle de la venta del evento.
    det_ven_eve_cantidad INT NOT NULL, -- Cantidad del detalle de la venta del evento.
    PRIMARY KEY (det_ven_eve_id, FK_ven_eve, FK_exi_eve_id, FK_exi_eve_presentacion, FK_exi_eve_pro_id, FK_exi_eve_pro_evento, FK_exi_eve_pro_proveedor)
);

-- Tabla: SOLICITUD_COMPRA
CREATE TABLE SOLICITUD_COMPRA (
    sol_com_id INT NOT NULL, -- Identificador único de la solicitud de compra.
    sol_com_fecha DATETIME NOT NULL, -- Fecha y hora en que se realizó la solicitud de compra.
    sol_com_total DECIMAL(18, 2) NOT NULL, -- Monto total de la solicitud de compra.
    FK_usuario INT, -- Clave foránea que referencia al usuario que realizó la solicitud de compra.
    FK_proveedor INT, -- Clave foránea que referencia al proveedor asociado a la solicitud de compra.
    FK_pre_alm_id INT, -- Clave foránea que referencia una de las claves de pre_alm
    FK_pre_alm_presentacion INT, -- Clave foránea que referencia una de las claves de pre_alm
    FK_pre_alm_almacen INT, -- Clave foránea que referencia una de las claves de pre_alm
    PRIMARY KEY (sol_com_id)
);

-- Tabla: SALARIO
CREATE TABLE SALARIO (
    sal_id INT NOT NULL, -- Identificador único del salario.
    sal_monto DECIMAL(18, 2) NOT NULL, -- Monto del salario.
    PRIMARY KEY (sal_id)
);

-- Tabla: EMP_CAR_SAL
CREATE TABLE EMP_CAR_SAL (
    emp_car_sal_id INT NOT NULL, -- Identificador único del salario del cargo del empleado.
    FK_emp_car_id INT NOT NULL,
    FK_emp_car_empleado INT NOT NULL,
    FK_emp_car_cargo INT NOT NULL,
    FK_salario INT NOT NULL, -- Clave foránea que referencia al salario asociado al cargo del empleado.
    emp_car_sal_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio del salario del cargo del empleado.
    emp_car_sal_fecha_hora_fin DATETIME, -- Fecha y hora de fin del salario del cargo del empleado.
    PRIMARY KEY (emp_car_sal_id, FK_emp_car_id, FK_emp_car_empleado, FK_emp_car_cargo, FK_salario)
);

-- Tabla: HORARIO
CREATE TABLE HORARIO (
    hor_id INT NOT NULL, -- Identificador único del horario.
    hor_dia VARCHAR(50) NOT NULL CHECK (hor_dia IN ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')), -- Día del horario (Lunes, Martes, etc.).
    hor_hora_inicio DATETIME NOT NULL, -- Hora de inicio del horario.
    hor_hora_fin DATETIME NOT NULL, -- Hora de fin del horario.
    PRIMARY KEY (hor_id)
);

-- Tabla: EMP_CAR_HOR
CREATE TABLE EMP_CAR_HOR (
    emp_car_hor_id INT NOT NULL, -- Identificador único de la relación entre el cargo del empleado y el horario.
    FK_emp_car_id INT NOT NULL,
    FK_emp_car_empleado INT NOT NULL,
    FK_emp_car_cargo INT NOT NULL,
    FK_horario INT NOT NULL, -- Clave foránea que referencia el horario asociado al cargo del empleado.
    PRIMARY KEY (emp_car_hor_id, FK_emp_car_id, FK_emp_car_empleado, FK_emp_car_cargo, FK_horario)
);

-- Tabla: ASISTENCIA
CREATE TABLE ASISTENCIA (
    asi_id INT NOT NULL, -- Identificador único de la asistencia.
    FK_emp_car_id INT NOT NULL,
    FK_emp_car_empleado INT NOT NULL,
    FK_emp_car_cargo INT NOT NULL,
    asi_hora_inicio DATETIME NOT NULL, -- Hora de inicio de la asistencia.
    asi_hora_fin DATETIME, -- Hora de fin de la asistencia.
    asi_pagado BOOLEAN, -- Indicador si la asistencia fue pagada.
    PRIMARY KEY (asi_id, FK_emp_car_id, FK_emp_car_empleado, FK_emp_car_cargo)
);

-- Tabla: LUGAR_TIENDA
CREATE TABLE LUGAR_TIENDA (
    lug_tie_id INT NOT NULL, -- Identificador único de la relación entre lugar y tienda.
    lug_tie_nombre VARCHAR(255) NOT NULL, -- Nombre del lugar.
    lug_tie_tipo VARCHAR(255) NOT NULL, -- Tipo de lugar.
    FK_lugar_tienda INT, -- Clave foránea que hace referencia al lugar dentro de la tienda.
    FK_tienda INT NOT NULL, -- Clave foránea que hace referencia a la tienda
    PRIMARY KEY (lug_tie_id)
);

-- Tabla: ANAQUEL
CREATE TABLE ANAQUEL (
    ana_id INT NOT NULL, -- Identificador único del anaquel.
    ana_nombre VARCHAR(255) NOT NULL, -- Nombre del anaquel.
    FK_lugar_tienda INT NOT NULL, -- Clave foránea que hace referencia al lugar dentro de la tienda donde esta anaquel.
    PRIMARY KEY (ana_id)
);

-- Tabla: INVENTARIO
CREATE TABLE INVENTARIO (
    inv_id INT NOT NULL, -- Identificador único del inventario.
    FK_pre_alm_id INT NOT NULL, 
    FK_pre_alm_presentacion INT NOT NULL, 
    FK_pre_alm_almacen INT NOT NULL, 
    inv_cantidad INT NOT NULL, -- Cantidad de artículos en el inventario.
    FK_anaquel INT NOT NULL, -- Clave foránea que referencia el anaquel donde se encuentra el inventario.
    PRIMARY KEY (inv_id, FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen)
);

-- Tabla: VENTA_FISICA
CREATE TABLE VENTA_FISICA (
    ven_fis_id INT NOT NULL, -- Identificador único de la venta física.
    ven_fis_fecha DATETIME NOT NULL, -- Fecha y hora en que se realizó la venta física.
    ven_fis_total DECIMAL(18, 2) NOT NULL, -- Monto total de la venta física.
    FK_cliente INT NOT NULL, -- Clave foránea que referencia al cliente asociado a la venta física.
    FK_tienda INT NOT NULL, -- Clave foránea que referencia a la tienda asociada a la venta física.
    FK_oferta INT, -- Clave foránea que referencia a la oferta aplicada en la venta física (puede ser nulo si no hay oferta).
    PRIMARY KEY (ven_fis_id)
);

-- Tabla: DETALLE_VENTA_FISICA
CREATE TABLE DETALLE_VENTA_FISICA (
    det_ven_fis_id INT NOT NULL, -- Identificador único del detalle de venta física.
    FK_ven_fisica INT NOT NULL, -- Clave foránea que referencia la venta física asociada al detalle.
    FK_inv_id INT NOT NULL,
    FK_inv_pre_alm_id INT NOT NULL,
    FK_inv_pre_alm_presentacion INT NOT NULL,
    FK_inv_pre_alm_almacen INT NOT NULL,
    det_ven_fis_precio_unitario DECIMAL(18, 2) NOT NULL, -- Precio unitario del detalle de venta física.
    det_ven_fis_cantidad INT NOT NULL, -- Cantidad del detalle de venta física.
    PRIMARY KEY (det_ven_fis_id, FK_ven_fisica, FK_inv_id, FK_inv_pre_alm_id, FK_inv_pre_alm_presentacion, FK_inv_pre_alm_almacen)
);

-- Tabla: VENTA_ONLINE
CREATE TABLE VENTA_ONLINE (
    ven_onl_id INT NOT NULL, -- Identificador único de la venta en línea.
    ven_onl_fecha DATETIME NOT NULL, -- Fecha y hora en que se realizó la venta en línea.
    ven_onl_total DECIMAL(18, 2) NOT NULL, -- Monto total de la venta en línea.
    FK_usuario INT NOT NULL, -- Clave foránea que referencia al usuario que realizó la venta en línea.
    FK_tienda INT NOT NULL, -- Clave foránea que referencia a la tienda asociada a la venta en línea.
    FK_oferta INT, -- Clave foránea que referencia a la oferta aplicada en la venta en línea.
    PRIMARY KEY (ven_onl_id)
);

-- Tabla: DETALLE_VENTA_ONLINE
CREATE TABLE DETALLE_VENTA_ONLINE (
    det_ven_onl_id INT NOT NULL, -- Identificador único del detalle de venta en línea.
    FK_ven_online INT NOT NULL, -- Clave foránea que referencia la venta en línea asociada al detalle.
    FK_pre_alm_id INT NOT NULL,
    FK_pre_alm_presentacion INT NOT NULL,
    FK_pre_alm_almacen INT NOT NULL,
    det_ven_onl_precio_unitario DECIMAL(18, 2) NOT NULL, -- Precio unitario del detalle de venta en línea.
    det_ven_onl_cantidad INT NOT NULL, -- Cantidad del detalle de venta en línea.
    PRIMARY KEY (det_ven_onl_id, FK_ven_online, FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen)
);

-- Tabla: AFILIACION
CREATE TABLE AFILIACION (
    afi_id INT NOT NULL, -- Identificador único de la afiliación.
    afi_nombre VARCHAR(255) NOT NULL, -- Nombre de la afiliación.
    afi_monto DECIMAL(18, 2) NOT NULL, -- Monto de la afiliación.
    FK_tienda INT NOT NULL, -- Clave foránea que referencia a la tienda.
    FK_proveedor INT NOT NULL, -- Clave foránea que referencia al proveedor.
    PRIMARY KEY (afi_id)
);

-- Tabla: METODO_PAGO
CREATE TABLE METODO_PAGO (
    met_pag_id INT NOT NULL, -- Identificador único del método de pago.
    efe_denominacion DECIMAL(18, 2), -- Denominación del billete en efectivo.
    che_num_cheque VARCHAR(255), -- Número de cheque.
    tar_deb_numero VARCHAR(255), -- Número de tarjeta de débito.
    tar_deb_vencimiento DATETIME, -- Fecha de vencimiento de la tarjeta de débito.
    tar_deb_banco VARCHAR(255), -- Banco de la tarjeta de débito.
    tar_cre_numero VARCHAR(255), -- Número de tarjeta de crédito.
    tar_cre_vencimiento DATETIME, -- Fecha de vencimiento de la tarjeta de crédito.
    met_pag_tipo VARCHAR(50) NOT NULL CHECK (met_pag_tipo IN ('EFECTIVO', 'CHEQUE', 'TARJETA_DEBITO', 'TARJETA_CREDITO', 'PUNTO')), -- Tipo de método de pago.
    FK_cuenta_punto INT, -- Clave foránea que referencia la cuenta del punto de venta asociada al método de pago.
    FK_his_pre_pun INT, -- Clave foránea que referencia el historial de precio del punto de venta asociado al método de pago.
    PRIMARY KEY (met_pag_id)
);

-- Tabla: PAGO
CREATE TABLE PAGO (
    pag_id INT NOT NULL, -- Identificador único del pago.
    pag_fecha DATETIME NOT NULL, -- Fecha en que se realizó el pago.
    pag_monto DECIMAL(18, 2) NOT NULL, -- Monto del pago.
    FK_venta_online INT, -- Clave foránea que referencia la venta en línea asociada al pago.
    FK_venta_fisica INT, -- Clave foránea que referencia la venta física asociada al pago.
    FK_afiliacion INT, -- Clave foránea que referencia la afiliación asociada al pago.
    FK_metodo_pago INT NOT NULL, -- Clave foránea que referencia el método de pago utilizado.
    FK_venta_evento INT, -- Clave foránea que referencia la venta del evento asociada al pago.
    PRIMARY KEY (pag_id)
);

-- Tabla: ESTATUS
CREATE TABLE ESTATUS (
    est_id INT NOT NULL, -- Identificador único del estatus.
    est_tipo_estatus VARCHAR(255) NOT NULL, -- Tipo de estatus.
    est_descripcion VARCHAR(255) NOT NULL, -- Descripción del estatus.
    PRIMARY KEY (est_id)
);

-- Tabla: SOL_COM_EST
CREATE TABLE SOL_COM_EST (
    sol_com_est_id INT NOT NULL, -- Identificador único del estado de la solicitud de compra.
    sol_com_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio del estado de la solicitud de compra.
    sol_com_fecha_fin DATETIME, -- Fecha de fin del estado de la solicitud de compra.
    FK_estatus INT NOT NULL, -- Clave foránea que referencia el estatus de la solicitud de compra.
    FK_sol_com INT NOT NULL, -- Clave foránea que referencia la solicitud de compra.
    PRIMARY KEY (sol_com_est_id, FK_estatus, FK_sol_com)
);

-- Tabla: AFI_EST
CREATE TABLE AFI_EST (
    afi_est_id INT NOT NULL, -- Identificador único del estado de la afiliación.
    afi_est_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio del estado de la afiliación.
    afi_est_fecha_final DATETIME, -- Fecha final del estado de la afiliación.
    FK_estatus INT NOT NULL, -- Clave foránea que referencia el estatus de la afiliación.
    FK_afiliacion INT NOT NULL, -- Clave foránea que referencia la afiliación.
    PRIMARY KEY (afi_est_id)
);

-- Tabla: VEN_ONL_EST
CREATE TABLE VEN_ONL_EST (
    ven_onl_est_id INT NOT NULL, -- Identificador único del estado de la venta en línea.
    ven_onl_est_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio del estado de la venta en línea.
    ven_onl_est_fecha_fin DATETIME, -- Fecha de fin del estado de la venta en línea (puede ser nula).
    FK_estatus INT NOT NULL, -- Clave foránea que referencia el estatus de la venta en línea.
    FK_venta_online INT NOT NULL, -- Clave foránea que referencia la venta en línea.
    PRIMARY KEY (ven_onl_est_id)
);

-- Tabla: SOLICITUD_REPOSICION
CREATE TABLE SOLICITUD_REPOSICION (
    sol_rep_id INT NOT NULL, -- Identificador único de la solicitud de reposición.
    sol_rep_fecha DATETIME NOT NULL, -- Fecha y hora en que se realizó la solicitud de reposición.
    FK_usuario INT, -- Clave foránea que referencia al usuario que realizó la solicitud de reposición.
    PRIMARY KEY (sol_rep_id)
);

-- Tabla: SOL_REP_EST
CREATE TABLE SOL_REP_EST (
    sol_rep_est_id INT NOT NULL, -- Identificador único del estado de la solicitud de reposición.
    sol_rep_est_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio del estado de la solicitud de reposición.
    sol_rep_est_fecha_fin DATETIME, -- Fecha de fin del estado de la solicitud de reposición (puede ser nula).
    FK_estatus INT NOT NULL, -- Clave foránea que referencia el estatus de la solicitud de reposición.
    FK_solicitud_reposicion INT NOT NULL, -- Clave foránea que referencia la solicitud de reposición.
    PRIMARY KEY (sol_rep_est_id)
);

-- Tabla: PRIVILEGIO
CREATE TABLE PRIVILEGIO (
    pri_id INT NOT NULL, -- Identificador único del privilegio.
    pri_accion VARCHAR(255) NOT NULL, -- Accion asociada al privilegio.
    pri_vista VARCHAR(255) NOT NULL, -- Vista asociada al privilegio.
    PRIMARY KEY (pri_id)
);

-- Tabla: PRI_ROL
CREATE TABLE PRI_ROL (
    pri_rol_id INT NOT NULL, -- Identificador único del rol con privilegio.
    FK_rol INT NOT NULL, -- Clave foránea que referencia el rol asociado al privilegio.
    FK_privilegio INT NOT NULL, -- Clave foránea que referencia el privilegio asociado al rol.
    PRIMARY KEY (pri_rol_id, FK_rol, FK_privilegio)
);

-- Tabla: TIP_EVE_TIP_EVE (Manejando columnas duplicadas)
CREATE TABLE TIP_EVE_TIP_EVE (
    tip_eve_tip_eve_id INT NOT NULL, -- Identificador único.
    FK_tip_eve_1 INT, -- Clave foránea que referencia al tipo de evento.
    FK_tip_eve_2 INT, -- Clave foránea que referencia al tipo de evento.
    PRIMARY KEY (tip_eve_tip_eve_id)
);

-- Tabla: TIPO_BENEFICIO
CREATE TABLE TIPO_BENEFICIO (
    tip_ben_id INT NOT NULL, -- Identificador único del tipo de beneficio.
    tip_ben_nombre VARCHAR(255) NOT NULL, -- Nombre del tipo de beneficio.
    tip_ben_descripcion VARCHAR(255) NOT NULL, -- Descripción del tipo de beneficio.
    PRIMARY KEY (tip_ben_id)
);

-- Tabla: EMP_TIP_BEN
CREATE TABLE EMP_TIP_BEN (
    emp_tic_ben_id INT NOT NULL, -- Identificador único de la relación.
    FK_tip_beneficio INT NOT NULL, -- Clave foránea que referencia el tipo de beneficio.
    FK_empleado INT NOT NULL, -- Clave foránea que referencia al empleado.
    PRIMARY KEY (emp_tic_ben_id, FK_tip_beneficio, FK_empleado)
);

-- Tabla: VACACION
CREATE TABLE VACACION (
    vac_id INT NOT NULL, -- Identificador único de la vacación.
    vac_nombre VARCHAR(255) NOT NULL, -- Nombre de la vacación.
    vac_descripcion VARCHAR(255) NOT NULL, -- Descripción de la vacación.
    PRIMARY KEY (vac_id)
);

-- Tabla: EMP_VAC
CREATE TABLE EMP_VAC (
    emp_vac_id INT NOT NULL, -- Identificador único de la vacación del empleado.
    emp_vac_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio de la vacación del empleado.
    emp_vac_fecha_fin DATETIME, -- Fecha de fin de la vacación del empleado.
    FK_vacacion INT NOT NULL, -- Clave foránea que referencia la vacación.
    FK_empleado INT NOT NULL, -- Clave foránea que referencia al empleado.
    PRIMARY KEY (emp_vac_id, FK_vacacion, FK_empleado)
);

-- Tabla: DETALLE_COMPRA
CREATE TABLE DETALLE_COMPRA (
    det_com_cantidad INT NOT NULL, -- Cantidad del detalle de compra.
    det_com_precio_unit DECIMAL(18, 2) NOT NULL, -- Precio unitario del detalle de compra.
    FK_solicitud_compra INT NOT NULL, -- Clave foránea que referencia la solicitud de compra.
    FK_presentacion INT NOT NULL, -- Clave foránea que referencia la cerveza.
    PRIMARY KEY (FK_solicitud_compra, FK_presentacion)
);

-- Tabla: ESTILO_CERVEZA
CREATE TABLE ESTILO_CERVEZA (
    est_cer_id INT NOT NULL, -- Identificador único del estilo de cerveza.
    est_cer_nombre VARCHAR(255) NOT NULL, -- Nombre del estilo de cerveza.
    est_cer_descripcion VARCHAR(255) NOT NULL, -- Descripción del estilo de cerveza.
    FK_tipo_cerveza INT NOT NULL, -- Clave foránea que referencia el tipo de cerveza.
    PRIMARY KEY (est_cer_id)
);

-- Tabla: CARACTERISTICA
CREATE TABLE CARACTERISTICA (
    carac_id INT NOT NULL, -- Identificador único de la característica.
    carac_nombre VARCHAR(255) NOT NULL, -- Nombre de la característica.
    carac_descripcion VARCHAR(255) NOT NULL, -- Descripción de la característica.
    carac_valor DECIMAL(10, 2) NOT NULL, -- Valor numérico de la característica.
    PRIMARY KEY (carac_id)
);

-- Tabla: CAR_CER
CREATE TABLE CAR_CER (
    carac_distintiva VARCHAR(255) NOT NULL, -- Valor que representa una característica distintiva.
    FK_caracteristica INT NOT NULL, -- Clave foránea a una característica específica.
    FK_cerveza INT NOT NULL, -- Clave foránea a la cerveza.
    PRIMARY KEY (FK_caracteristica, FK_cerveza)
);

-- Tabla: DIMENSION
CREATE TABLE DIMENSION (
    dim_id INT NOT NULL, -- Identificador único de la dimensión.
    dim_nombre VARCHAR(255) NOT NULL, -- Nombre de la dimensión (Corregido de Numeric).
    dim_unidad_medida VARCHAR(50) NOT NULL, -- Unidad de medida (Corregido de Numeric).
    PRIMARY KEY (dim_id)
);

-- Tabla: PRE_DIM
CREATE TABLE PRE_DIM (
    FK_presentacion INT NOT NULL, -- Clave foránea que referencia la presentación.
    FK_dimension INT NOT NULL, -- Clave foránea que referencia la dimensión.
    pre_dim_valor DECIMAL(10, 2) NOT NULL, -- Medida específica de la dimensión para la presentación.
    PRIMARY KEY (FK_presentacion, FK_dimension)
);

-- Tabla: INGREDIENTE
CREATE TABLE INGREDIENTE (
    ing_id INT NOT NULL, -- Identificador único del ingrediente.
    ing_nombre VARCHAR(255) NOT NULL, -- Nombre del ingrediente.
    ing_descripcion VARCHAR(255) NOT NULL, -- Descripción del ingrediente.
    PRIMARY KEY (ing_id)
);

-- Tabla: INV_SOL_REP
CREATE TABLE INV_SOL_REP (
    inv_sol_rep_id INT NOT NULL, -- Identificador único de la relación.
    FK_solicitud_reposicion INT NOT NULL, 
    FK_inv_id INT NOT NULL,
    FK_inv_pre_alm_id INT NOT NULL,
    FK_inv_pre_alm_presentacion INT NOT NULL,
    FK_inv_pre_alm_almacen INT NOT NULL,
    inv_sol_rep_fecha DATETIME NOT NULL, -- Fecha de la relación.
    PRIMARY KEY (inv_sol_rep_id, FK_solicitud_reposicion, FK_inv_id, FK_inv_pre_alm_id, FK_inv_pre_alm_presentacion, FK_inv_pre_alm_almacen)
);

-- Tabla: HISTORICO_PRECIO_CERVEZA
CREATE TABLE HISTORICO_PRECIO_CERVEZA (
    his_pre_cer_id INT NOT NULL, -- Identificador único del precio histórico.
    his_pre_cer_precio DECIMAL(18, 2) NOT NULL, -- Precio histórico de la cerveza.
    his_pre_cer_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio del precio.
    his_pre_cer_fecha_fin DATETIME, -- Fecha de fin del precio.
    FK_pre_alm_id INT NOT NULL, 
    FK_pre_alm_presentacion INT NOT NULL, 
    FK_pre_alm_almacen INT NOT NULL, 
    PRIMARY KEY (his_pre_cer_id)
);

-- Tabla: RECETA
CREATE TABLE RECETA (
    rec_id INT NOT NULL, -- Identificador único de la receta.
    rec_nombre VARCHAR(255) NOT NULL, -- Nombre de la receta.
    rec_descripcion VARCHAR(255) NOT NULL, -- Descripción de la receta.
    PRIMARY KEY (rec_id)
);

-- Tabla: INSTRUCCION
CREATE TABLE INSTRUCCION (
    ins_id INT NOT NULL, -- Identificador único de la instrucción.
    ins_descripcion VARCHAR(1000) NOT NULL, -- Descripción detallada de la instrucción.
    PRIMARY KEY (ins_id)
);

-- Tabla: REC_INS
CREATE TABLE REC_INS (
    rec_ins_id INT NOT NULL, 
    FK_receta INT NOT NULL, 
    FK_instruccion INT NOT NULL,
    PRIMARY KEY (rec_ins_id)
);

-- Tabla: REC_ING
CREATE TABLE REC_ING (
    rec_ing_id INT NOT NULL, -- Identificador único.
    FK_receta INT NOT NULL, -- Clave foránea que referencia a la receta.
    FK_ingrediente INT NOT NULL, -- Clave foránea que referencia al ingrediente.
    rec_ing_cantidad DECIMAL(10, 3) NOT NULL,
    PRIMARY KEY (rec_ing_id, FK_receta, FK_ingrediente)
);

-- Tabla: PAGO_EFECTIVO (Nombre corregido)
CREATE TABLE PAGO_EFECTIVO (
    pag_efe_id INT NOT NULL, -- Identificador único del pago en efectivo.
    pag_efe_monto DECIMAL(18, 2) NOT NULL, -- Monto del pago en efectivo.
    pag_efe_fecha DATETIME NOT NULL, -- Fecha del pago en efectivo.
    FK_solicitud_compra INT NOT NULL, -- Clave foránea que referencia la solicitud de compra.
    FK_metodo_pago INT NOT NULL, -- Clave foránea que referencia el método de pago.
    PRIMARY KEY (pag_efe_id)
);

-- Tabla: MONEDA
CREATE TABLE MONEDA (
    mon_id INT NOT NULL, -- Identificador único de la moneda.
    mon_tipo VARCHAR(255) NOT NULL, -- Tipo o nombre de la moneda.
    mon_valor_cambio DECIMAL(18, 6) NOT NULL, -- Valor de cambio de la moneda.
    PRIMARY KEY (mon_id)
);

-- Tabla: HISTORICO_MONEDA
CREATE TABLE HISTORICO_MONEDA (
    his_mon_id INT NOT NULL, -- Identificador único.
    his_mon_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio (Corregido).
    his_mon_valor_cambio DECIMAL(18, 6) NOT NULL, -- Monto de la afiliación.
    his_mon_fecha_fin DATETIME NOT NULL, -- Fecha de fin (Corregido).
    FK_moneda INT NOT NULL, -- Clave foránea a la moneda.
    PRIMARY KEY (his_mon_id)
);

-- Tabla: CUENTA_PUNTO (Manejando columnas duplicadas)
CREATE TABLE CUENTA_PUNTO (
    cue_pun_id INT NOT NULL, -- Identificador único de la cuenta del punto de venta.
    cue_pun_cantidad DECIMAL(18, 2) NOT NULL, -- Cantidad en la cuenta del punto de venta.
    FK_metodo_pago_1 INT NOT NULL,
    FK_metodo_pago_2 INT NOT NULL,
    PRIMARY KEY (cue_pun_id)
);

-- Tabla: HISTORICO_PRECIO_PUNTO
CREATE TABLE HISTORICO_PRECIO_PUNTO (
    his_pre_pun_id INT NOT NULL, -- Identificador único del precio histórico.
    his_pre_pun_valor DECIMAL(18, 2) NOT NULL, -- Valor numérico del precio histórico.
    his_pre_pun_fecha_inicio DATETIME NOT NULL, -- Fecha de inicio (Corregido).
    his_pre_pun_fecha_fin DATETIME NOT NULL, -- Fecha de fin (Corregido).
    PRIMARY KEY (his_pre_pun_id)
);

-- Tabla: CONTACTO_PROVEEDOR
CREATE TABLE CONTACTO_PROVEEDOR (
    con_pro_id INT NOT NULL, -- Identificador único del contacto del proveedor.
    con_pro_nombre VARCHAR(255) NOT NULL, -- Nombre del contacto.
    con_pro_apellido VARCHAR(255) NOT NULL, -- Apellido del contacto.
    FK_proveedor INT NOT NULL, -- Clave foránea que referencia al proveedor.
    PRIMARY KEY (con_pro_id)
);

-- Tabla: CONTACTO_CLIENTE
CREATE TABLE CONTACTO_CLIENTE (
    con_cli_id INT NOT NULL, -- Identificador único del contacto del cliente.
    con_cli_nombre VARCHAR(255) NOT NULL, -- Nombre del contacto.
    con_cli_apellido VARCHAR(255) NOT NULL, -- Apellido del contacto.
    FK_cliente INT NOT NULL, -- Clave foránea que referencia al cliente.
    PRIMARY KEY (con_cli_id)
);

-- Tabla: CORREO_ELECTRONICO
CREATE TABLE CORREO_ELECTRONICO (
    cor_ele_id INT NOT NULL, -- Identificador único del correo electrónico.
    cor_ele_direccion VARCHAR(255) NOT NULL, -- Dirección de correo electrónico.
    FK_empleado INT, 
    FK_cliente INT, 
    FK_contacto_cliente INT,
    FK_contacto_proveedor INT,
    FK_proveedor INT, 
    PRIMARY KEY (cor_ele_id)
);

-- Tabla: TELEFONO
CREATE TABLE TELEFONO (
    tel_id INT NOT NULL, -- Identificador único del teléfono.
    tel_codigo_area VARCHAR(10) NOT NULL, -- Código de área del teléfono.
    tel_numero VARCHAR(20) NOT NULL, -- Número de teléfono.
    FK_empleado INT,
    FK_cliente INT,
    FK_contacto_cliente INT,
    FK_contacto_proveedor INT,
    FK_proveedor INT,
    PRIMARY KEY (tel_id)
);

-- Tabla: TIPO_ESTILO_CERVEZA
CREATE TABLE TIPO_ESTILO_CERVEZA (
    tip_est_cer_id INT NOT NULL, -- Identificador único.
    tip_est_cer_nombre VARCHAR(255) NOT NULL, -- Nombre.
    tip_est_cer_descripcion VARCHAR(255) NOT NULL, -- Descripción (Corregido).
    FK_tipo_cerveza INT NOT NULL,
    FK_estilo_cerveza INT NOT NULL,
    PRIMARY KEY (tip_est_cer_id)
);


/************************************************************/
/************** CREACIÓN DE CLAVES FORÁNEAS *****************/
/************************************************************/

-- LUGAR
ALTER TABLE LUGAR ADD CONSTRAINT FK_LUGAR_LUGAR FOREIGN KEY (FK_lugar) REFERENCES LUGAR (lug_id);

-- TIENDA
ALTER TABLE TIENDA ADD CONSTRAINT FK_TIENDA_LUGAR FOREIGN KEY (FK_lugar) REFERENCES LUGAR (lug_id);

-- EMPLEADO
ALTER TABLE EMPLEADO ADD CONSTRAINT FK_EMPLEADO_LUGAR FOREIGN KEY (FK_lugar) REFERENCES LUGAR (lug_id);
ALTER TABLE EMPLEADO ADD CONSTRAINT FK_EMPLEADO_TIENDA FOREIGN KEY (FK_tienda) REFERENCES TIENDA (tie_id);

-- EMP_CAR
ALTER TABLE EMP_CAR ADD CONSTRAINT FK_EMPCAR_EMPLEADO FOREIGN KEY (FK_empleado) REFERENCES EMPLEADO (emp_id);
ALTER TABLE EMP_CAR ADD CONSTRAINT FK_EMPCAR_CARGO FOREIGN KEY (FK_cargo) REFERENCES CARGO (car_id);

-- CLIENTE
ALTER TABLE CLIENTE ADD CONSTRAINT FK_CLIENTE_LUGAR FOREIGN KEY (FK_lugar) REFERENCES LUGAR (lug_id);

-- PROVEEDOR
ALTER TABLE PROVEEDOR ADD CONSTRAINT FK_PROVEEDOR_LUGAR FOREIGN KEY (FK_lugar) REFERENCES LUGAR (lug_id);

-- USUARIO
ALTER TABLE USUARIO ADD CONSTRAINT FK_USUARIO_EMPCAR FOREIGN KEY (FK_emp_car1, FK_emp_car2, FK_emp_car3) REFERENCES EMP_CAR (emp_car_id, FK_empleado, FK_cargo);
ALTER TABLE USUARIO ADD CONSTRAINT FK_USUARIO_CLIENTE FOREIGN KEY (FK_cliente) REFERENCES CLIENTE (cli_id);
ALTER TABLE USUARIO ADD CONSTRAINT FK_USUARIO_PROVEEDOR FOREIGN KEY (FK_proveedor) REFERENCES PROVEEDOR (pro_id);
ALTER TABLE USUARIO ADD CONSTRAINT FK_USUARIO_ROL FOREIGN KEY (FK_rol) REFERENCES ROL (rol_id);

-- EVENTO
ALTER TABLE EVENTO ADD CONSTRAINT FK_EVENTO_TIPOEVENTO FOREIGN KEY (FK_tip_eve) REFERENCES TIPO_EVENTO (tip_eve_id);

-- VENTA_EVENTO
ALTER TABLE VENTA_EVENTO ADD CONSTRAINT FK_VENTAEVENTO_EVENTO FOREIGN KEY (FK_evento) REFERENCES EVENTO (eve_id);

-- ASISTENCIA_EVENTO
ALTER TABLE ASISTENCIA_EVENTO ADD CONSTRAINT FK_ASISTENCIAEVENTO_EVENTO FOREIGN KEY (FK_evento) REFERENCES EVENTO (eve_id);
ALTER TABLE ASISTENCIA_EVENTO ADD CONSTRAINT FK_ASISTENCIAEVENTO_CLIENTE FOREIGN KEY (FK_cliente) REFERENCES CLIENTE (cli_id);

-- VENTA_BOLETO_EVENTO
ALTER TABLE VENTA_BOLETO_EVENTO ADD CONSTRAINT FK_VENTABOLETO_ASISTENCIA FOREIGN KEY (FK_asi_eve_id, FK_asi_eve_evento) REFERENCES ASISTENCIA_EVENTO (asi_eve_id, FK_evento);

-- EVE_PRO
ALTER TABLE EVE_PRO ADD CONSTRAINT FK_EVEPRO_EVENTO FOREIGN KEY (FK_evento) REFERENCES EVENTO (eve_id);
ALTER TABLE EVE_PRO ADD CONSTRAINT FK_EVEPRO_PROVEEDOR FOREIGN KEY (FK_proveedor) REFERENCES PROVEEDOR (pro_id);

-- CERVEZA
ALTER TABLE CERVEZA ADD CONSTRAINT FK_CERVEZA_TIPOCERVEZA FOREIGN KEY (FK_tipo_cerveza) REFERENCES TIPO_CERVEZA (tip_cer_id);

-- PRESENTACION
ALTER TABLE PRESENTACION ADD CONSTRAINT FK_PRESENTACION_CERVEZA FOREIGN KEY (FK_cerveza) REFERENCES CERVEZA (cer_id);

-- ALMACEN
ALTER TABLE ALMACEN ADD CONSTRAINT FK_ALMACEN_TIENDA FOREIGN KEY (FK_tienda) REFERENCES TIENDA (tie_id);

-- PRE_ALM
ALTER TABLE PRE_ALM ADD CONSTRAINT FK_PREALM_PRESENTACION FOREIGN KEY (FK_presentacion) REFERENCES PRESENTACION (prese_id);
ALTER TABLE PRE_ALM ADD CONSTRAINT FK_PREALM_ALMACEN FOREIGN KEY (FK_almacen) REFERENCES ALMACEN (alm_id);
ALTER TABLE PRE_ALM ADD CONSTRAINT FK_PREALM_OFERTA FOREIGN KEY (FK_oferta) REFERENCES OFERTA (ofe_id);

-- EXISTENCIA_EVENTO
ALTER TABLE EXISTENCIA_EVENTO ADD CONSTRAINT FK_EXISTENCIA_PRESENTACION FOREIGN KEY (FK_presentacion) REFERENCES PRESENTACION (prese_id);
ALTER TABLE EXISTENCIA_EVENTO ADD CONSTRAINT FK_EXISTENCIA_EVEPRO FOREIGN KEY (FK_eve_pro_id, FK_eve_pro_evento, FK_eve_pro_proveedor) REFERENCES EVE_PRO (eve_pro_id, FK_evento, FK_proveedor);

-- DETALLE_VENTA_EVENTO
ALTER TABLE DETALLE_VENTA_EVENTO ADD CONSTRAINT FK_DETALLEVENTA_VENTAEVENTO FOREIGN KEY (FK_ven_eve) REFERENCES VENTA_EVENTO (ven_eve_id);
ALTER TABLE DETALLE_VENTA_EVENTO ADD CONSTRAINT FK_DETALLEVENTA_EXISTENCIA FOREIGN KEY (FK_exi_eve_id, FK_exi_eve_presentacion, FK_exi_eve_pro_id, FK_exi_eve_pro_evento, FK_exi_eve_pro_proveedor) REFERENCES EXISTENCIA_EVENTO (exi_eve_id, FK_presentacion, FK_eve_pro_id, FK_eve_pro_evento, FK_eve_pro_proveedor);

-- SOLICITUD_COMPRA
ALTER TABLE SOLICITUD_COMPRA ADD CONSTRAINT FK_SOLCOMPRA_USUARIO FOREIGN KEY (FK_usuario) REFERENCES USUARIO (usu_id);
ALTER TABLE SOLICITUD_COMPRA ADD CONSTRAINT FK_SOLCOMPRA_PROVEEDOR FOREIGN KEY (FK_proveedor) REFERENCES PROVEEDOR (pro_id);
ALTER TABLE SOLICITUD_COMPRA ADD CONSTRAINT FK_SOLCOMPRA_PREALM FOREIGN KEY (FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen) REFERENCES PRE_ALM (pre_alm_id, FK_presentacion, FK_almacen);

-- EMP_CAR_SAL
ALTER TABLE EMP_CAR_SAL ADD CONSTRAINT FK_EMPCARSAL_EMPCAR FOREIGN KEY (FK_emp_car_id, FK_emp_car_empleado, FK_emp_car_cargo) REFERENCES EMP_CAR (emp_car_id, FK_empleado, FK_cargo);
ALTER TABLE EMP_CAR_SAL ADD CONSTRAINT FK_EMPCARSAL_SALARIO FOREIGN KEY (FK_salario) REFERENCES SALARIO (sal_id);

-- EMP_CAR_HOR
ALTER TABLE EMP_CAR_HOR ADD CONSTRAINT FK_EMPCARHOR_EMPCAR FOREIGN KEY (FK_emp_car_id, FK_emp_car_empleado, FK_emp_car_cargo) REFERENCES EMP_CAR (emp_car_id, FK_empleado, FK_cargo);
ALTER TABLE EMP_CAR_HOR ADD CONSTRAINT FK_EMPCARHOR_HORARIO FOREIGN KEY (FK_horario) REFERENCES HORARIO (hor_id);

-- ASISTENCIA
ALTER TABLE ASISTENCIA ADD CONSTRAINT FK_ASISTENCIA_EMPCAR FOREIGN KEY (FK_emp_car_id, FK_emp_car_empleado, FK_emp_car_cargo) REFERENCES EMP_CAR (emp_car_id, FK_empleado, FK_cargo);

-- LUGAR_TIENDA
ALTER TABLE LUGAR_TIENDA ADD CONSTRAINT FK_LUGARTIENDRA_LUGAR FOREIGN KEY (FK_lugar_tienda) REFERENCES LUGAR_TIENDA (lug_tie_id);
ALTER TABLE LUGAR_TIENDA ADD CONSTRAINT FK_LUGARTIENDRA_TIENDA FOREIGN KEY (FK_tienda) REFERENCES TIENDA (tie_id);

-- ANAQUEL
ALTER TABLE ANAQUEL ADD CONSTRAINT FK_ANAQUEL_LUGARTIENDRA FOREIGN KEY (FK_lugar_tienda) REFERENCES LUGAR_TIENDA (lug_tie_id);

-- INVENTARIO
ALTER TABLE INVENTARIO ADD CONSTRAINT FK_INVENTARIO_PREALM FOREIGN KEY (FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen) REFERENCES PRE_ALM (pre_alm_id, FK_presentacion, FK_almacen);
ALTER TABLE INVENTARIO ADD CONSTRAINT FK_INVENTARIO_ANAQUEL FOREIGN KEY (FK_anaquel) REFERENCES ANAQUEL (ana_id);

-- VENTA_FISICA
ALTER TABLE VENTA_FISICA ADD CONSTRAINT FK_VENTAFISICA_CLIENTE FOREIGN KEY (FK_cliente) REFERENCES CLIENTE (cli_id);
ALTER TABLE VENTA_FISICA ADD CONSTRAINT FK_VENTAFISICA_TIENDA FOREIGN KEY (FK_tienda) REFERENCES TIENDA (tie_id);
ALTER TABLE VENTA_FISICA ADD CONSTRAINT FK_VENTAFISICA_OFERTA FOREIGN KEY (FK_oferta) REFERENCES OFERTA (ofe_id);

-- DETALLE_VENTA_FISICA
ALTER TABLE DETALLE_VENTA_FISICA ADD CONSTRAINT FK_DETVENTAFIS_VENTAFISICA FOREIGN KEY (FK_ven_fisica) REFERENCES VENTA_FISICA (ven_fis_id);
ALTER TABLE DETALLE_VENTA_FISICA ADD CONSTRAINT FK_DETVENTAFIS_INVENTARIO FOREIGN KEY (FK_inv_id, FK_inv_pre_alm_id, FK_inv_pre_alm_presentacion, FK_inv_pre_alm_almacen) REFERENCES INVENTARIO (inv_id, FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen);

-- VENTA_ONLINE
ALTER TABLE VENTA_ONLINE ADD CONSTRAINT FK_VENTAONLINE_USUARIO FOREIGN KEY (FK_usuario) REFERENCES USUARIO (usu_id);
ALTER TABLE VENTA_ONLINE ADD CONSTRAINT FK_VENTAONLINE_TIENDA FOREIGN KEY (FK_tienda) REFERENCES TIENDA (tie_id);
ALTER TABLE VENTA_ONLINE ADD CONSTRAINT FK_VENTAONLINE_OFERTA FOREIGN KEY (FK_oferta) REFERENCES OFERTA (ofe_id);

-- DETALLE_VENTA_ONLINE
ALTER TABLE DETALLE_VENTA_ONLINE ADD CONSTRAINT FK_DETVENTAONL_VENTAONLINE FOREIGN KEY (FK_ven_online) REFERENCES VENTA_ONLINE (ven_onl_id);
ALTER TABLE DETALLE_VENTA_ONLINE ADD CONSTRAINT FK_DETVENTAONL_PREALM FOREIGN KEY (FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen) REFERENCES PRE_ALM (pre_alm_id, FK_presentacion, FK_almacen);

-- AFILIACION
ALTER TABLE AFILIACION ADD CONSTRAINT FK_AFILIACION_TIENDA FOREIGN KEY (FK_tienda) REFERENCES TIENDA (tie_id);
ALTER TABLE AFILIACION ADD CONSTRAINT FK_AFILIACION_PROVEEDOR FOREIGN KEY (FK_proveedor) REFERENCES PROVEEDOR (pro_id);

-- PAGO
ALTER TABLE PAGO ADD CONSTRAINT FK_PAGO_VENTAONLINE FOREIGN KEY (FK_venta_online) REFERENCES VENTA_ONLINE (ven_onl_id);
ALTER TABLE PAGO ADD CONSTRAINT FK_PAGO_VENTAFISICA FOREIGN KEY (FK_venta_fisica) REFERENCES VENTA_FISICA (ven_fis_id);
ALTER TABLE PAGO ADD CONSTRAINT FK_PAGO_AFILIACION FOREIGN KEY (FK_afiliacion) REFERENCES AFILIACION (afi_id);
ALTER TABLE PAGO ADD CONSTRAINT FK_PAGO_METODOPAGO FOREIGN KEY (FK_metodo_pago) REFERENCES METODO_PAGO (met_pag_id);
ALTER TABLE PAGO ADD CONSTRAINT FK_PAGO_VENTAEVENTO FOREIGN KEY (FK_venta_evento) REFERENCES VENTA_EVENTO (ven_eve_id);

-- SOL_COM_EST
ALTER TABLE SOL_COM_EST ADD CONSTRAINT FK_SOLCOMEST_ESTATUS FOREIGN KEY (FK_estatus) REFERENCES ESTATUS (est_id);
ALTER TABLE SOL_COM_EST ADD CONSTRAINT FK_SOLCOMEST_SOLCOMPRA FOREIGN KEY (FK_sol_com) REFERENCES SOLICITUD_COMPRA (sol_com_id);

-- AFI_EST
ALTER TABLE AFI_EST ADD CONSTRAINT FK_AFIEST_ESTATUS FOREIGN KEY (FK_estatus) REFERENCES ESTATUS (est_id);
ALTER TABLE AFI_EST ADD CONSTRAINT FK_AFIEST_AFILIACION FOREIGN KEY (FK_afiliacion) REFERENCES AFILIACION (afi_id);

-- VEN_ONL_EST
ALTER TABLE VEN_ONL_EST ADD CONSTRAINT FK_VENONLEST_ESTATUS FOREIGN KEY (FK_estatus) REFERENCES ESTATUS (est_id);
ALTER TABLE VEN_ONL_EST ADD CONSTRAINT FK_VENONLEST_VENTAONLINE FOREIGN KEY (FK_venta_online) REFERENCES VENTA_ONLINE (ven_onl_id);

-- SOLICITUD_REPOSICION
ALTER TABLE SOLICITUD_REPOSICION ADD CONSTRAINT FK_SOLREP_USUARIO FOREIGN KEY (FK_usuario) REFERENCES USUARIO (usu_id);

-- SOL_REP_EST
ALTER TABLE SOL_REP_EST ADD CONSTRAINT FK_SOLREPEST_ESTATUS FOREIGN KEY (FK_estatus) REFERENCES ESTATUS (est_id);
ALTER TABLE SOL_REP_EST ADD CONSTRAINT FK_SOLREPEST_SOLREP FOREIGN KEY (FK_solicitud_reposicion) REFERENCES SOLICITUD_REPOSICION (sol_rep_id);

-- PRI_ROL
ALTER TABLE PRI_ROL ADD CONSTRAINT FK_PRIROL_ROL FOREIGN KEY (FK_rol) REFERENCES ROL (rol_id);
ALTER TABLE PRI_ROL ADD CONSTRAINT FK_PRIROL_PRIVILEGIO FOREIGN KEY (FK_privilegio) REFERENCES PRIVILEGIO (pri_id);

-- TIP_EVE_TIP_EVE
ALTER TABLE TIP_EVE_TIP_EVE ADD CONSTRAINT FK_TIPEVE_TIPEVE1 FOREIGN KEY (FK_tip_eve_1) REFERENCES TIPO_EVENTO (tip_eve_id);
ALTER TABLE TIP_EVE_TIP_EVE ADD CONSTRAINT FK_TIPEVE_TIPEVE2 FOREIGN KEY (FK_tip_eve_2) REFERENCES TIPO_EVENTO (tip_eve_id);

-- EMP_TIP_BEN
ALTER TABLE EMP_TIP_BEN ADD CONSTRAINT FK_EMPTIPBEN_TIPOBENEFICIO FOREIGN KEY (FK_tip_beneficio) REFERENCES TIPO_BENEFICIO (tip_ben_id);
ALTER TABLE EMP_TIP_BEN ADD CONSTRAINT FK_EMPTIPBEN_EMPLEADO FOREIGN KEY (FK_empleado) REFERENCES EMPLEADO (emp_id);

-- EMP_VAC
ALTER TABLE EMP_VAC ADD CONSTRAINT FK_EMPVAC_VACACION FOREIGN KEY (FK_vacacion) REFERENCES VACACION (vac_id);
ALTER TABLE EMP_VAC ADD CONSTRAINT FK_EMPVAC_EMPLEADO FOREIGN KEY (FK_empleado) REFERENCES EMPLEADO (emp_id);

-- DETALLE_COMPRA
ALTER TABLE DETALLE_COMPRA ADD CONSTRAINT FK_DETCOMPRA_SOLCOMPRA FOREIGN KEY (FK_solicitud_compra) REFERENCES SOLICITUD_COMPRA (sol_com_id);
ALTER TABLE DETALLE_COMPRA ADD CONSTRAINT FK_DETCOMPRA_PRESENTACION FOREIGN KEY (FK_presentacion) REFERENCES PRESENTACION (prese_id);

-- ESTILO_CERVEZA
ALTER TABLE ESTILO_CERVEZA ADD CONSTRAINT FK_ESTILOCER_TIPOCERVEZA FOREIGN KEY (FK_tipo_cerveza) REFERENCES TIPO_CERVEZA (tip_cer_id);

-- CAR_CER
ALTER TABLE CAR_CER ADD CONSTRAINT FK_CARCER_CARACTERISTICA FOREIGN KEY (FK_caracteristica) REFERENCES CARACTERISTICA (carac_id);
ALTER TABLE CAR_CER ADD CONSTRAINT FK_CARCER_CERVEZA FOREIGN KEY (FK_cerveza) REFERENCES CERVEZA (cer_id);

-- PRE_DIM
ALTER TABLE PRE_DIM ADD CONSTRAINT FK_PREDIM_PRESENTACION FOREIGN KEY (FK_presentacion) REFERENCES PRESENTACION (prese_id);
ALTER TABLE PRE_DIM ADD CONSTRAINT FK_PREDIM_DIMENSION FOREIGN KEY (FK_dimension) REFERENCES DIMENSION (dim_id);

-- INV_SOL_REP
ALTER TABLE INV_SOL_REP ADD CONSTRAINT FK_INVSOLREP_SOLREP FOREIGN KEY (FK_solicitud_reposicion) REFERENCES SOLICITUD_REPOSICION (sol_rep_id);
ALTER TABLE INV_SOL_REP ADD CONSTRAINT FK_INVSOLREP_INVENTARIO FOREIGN KEY (FK_inv_id, FK_inv_pre_alm_id, FK_inv_pre_alm_presentacion, FK_inv_pre_alm_almacen) REFERENCES INVENTARIO (inv_id, FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen);

-- HISTORICO_PRECIO_CERVEZA
ALTER TABLE HISTORICO_PRECIO_CERVEZA ADD CONSTRAINT FK_HISPRECER_PREALM FOREIGN KEY (FK_pre_alm_id, FK_pre_alm_presentacion, FK_pre_alm_almacen) REFERENCES PRE_ALM (pre_alm_id, FK_presentacion, FK_almacen);

-- REC_INS
ALTER TABLE REC_INS ADD CONSTRAINT FK_RECINS_RECETA FOREIGN KEY (FK_receta) REFERENCES RECETA (rec_id);
ALTER TABLE REC_INS ADD CONSTRAINT FK_RECINS_INSTRUCCION FOREIGN KEY (FK_instruccion) REFERENCES INSTRUCCION (ins_id);

-- REC_ING
ALTER TABLE REC_ING ADD CONSTRAINT FK_RECING_RECETA FOREIGN KEY (FK_receta) REFERENCES RECETA (rec_id);
ALTER TABLE REC_ING ADD CONSTRAINT FK_RECING_INGREDIENTE FOREIGN KEY (FK_ingrediente) REFERENCES INGREDIENTE (ing_id);

-- PAGO_EFECTIVO
ALTER TABLE PAGO_EFECTIVO ADD CONSTRAINT FK_PAGOEFE_SOLCOMPRA FOREIGN KEY (FK_solicitud_compra) REFERENCES SOLICITUD_COMPRA (sol_com_id);
ALTER TABLE PAGO_EFECTIVO ADD CONSTRAINT FK_PAGOEFE_METODOPAGO FOREIGN KEY (FK_metodo_pago) REFERENCES METODO_PAGO (met_pag_id);

-- HISTORICO_MONEDA
ALTER TABLE HISTORICO_MONEDA ADD CONSTRAINT FK_HISMON_MONEDA FOREIGN KEY (FK_moneda) REFERENCES MONEDA (mon_id);

-- CUENTA_PUNTO
ALTER TABLE CUENTA_PUNTO ADD CONSTRAINT FK_CUENTAPUNTO_METPAGO1 FOREIGN KEY (FK_metodo_pago_1) REFERENCES METODO_PAGO (met_pag_id);
ALTER TABLE CUENTA_PUNTO ADD CONSTRAINT FK_CUENTAPUNTO_METPAGO2 FOREIGN KEY (FK_metodo_pago_2) REFERENCES METODO_PAGO (met_pag_id);

-- CONTACTO_PROVEEDOR
ALTER TABLE CONTACTO_PROVEEDOR ADD CONSTRAINT FK_CONTPROV_PROVEEDOR FOREIGN KEY (FK_proveedor) REFERENCES PROVEEDOR (pro_id);

-- CONTACTO_CLIENTE
ALTER TABLE CONTACTO_CLIENTE ADD CONSTRAINT FK_CONTCLI_CLIENTE FOREIGN KEY (FK_cliente) REFERENCES CLIENTE (cli_id);

-- CORREO_ELECTRONICO
ALTER TABLE CORREO_ELECTRONICO ADD CONSTRAINT FK_CORREO_EMPLEADO FOREIGN KEY (FK_empleado) REFERENCES EMPLEADO (emp_id);
ALTER TABLE CORREO_ELECTRONICO ADD CONSTRAINT FK_CORREO_CLIENTE FOREIGN KEY (FK_cliente) REFERENCES CLIENTE (cli_id);
ALTER TABLE CORREO_ELECTRONICO ADD CONSTRAINT FK_CORREO_CONTCLI FOREIGN KEY (FK_contacto_cliente) REFERENCES CONTACTO_CLIENTE (con_cli_id);
ALTER TABLE CORREO_ELECTRONICO ADD CONSTRAINT FK_CORREO_CONTPROV FOREIGN KEY (FK_contacto_proveedor) REFERENCES CONTACTO_PROVEEDOR (con_pro_id);
ALTER TABLE CORREO_ELECTRONICO ADD CONSTRAINT FK_CORREO_PROVEEDOR FOREIGN KEY (FK_proveedor) REFERENCES PROVEEDOR (pro_id);

-- TELEFONO
ALTER TABLE TELEFONO ADD CONSTRAINT FK_TELEFONO_EMPLEADO FOREIGN KEY (FK_empleado) REFERENCES EMPLEADO (emp_id);
ALTER TABLE TELEFONO ADD CONSTRAINT FK_TELEFONO_CLIENTE FOREIGN KEY (FK_cliente) REFERENCES CLIENTE (cli_id);
ALTER TABLE TELEFONO ADD CONSTRAINT FK_TELEFONO_CONTCLI FOREIGN KEY (FK_contacto_cliente) REFERENCES CONTACTO_CLIENTE (con_cli_id);
ALTER TABLE TELEFONO ADD CONSTRAINT FK_TELEFONO_CONTPROV FOREIGN KEY (FK_contacto_proveedor) REFERENCES CONTACTO_PROVEEDOR (con_pro_id);
ALTER TABLE TELEFONO ADD CONSTRAINT FK_TELEFONO_PROVEEDOR FOREIGN KEY (FK_proveedor) REFERENCES PROVEEDOR (pro_id);

-- TIPO_ESTILO_CERVEZA
ALTER TABLE TIPO_ESTILO_CERVEZA ADD CONSTRAINT FK_TIPOESTILO_TIPOCERVEZA FOREIGN KEY (FK_tipo_cerveza) REFERENCES TIPO_CERVEZA (tip_cer_id);
ALTER TABLE TIPO_ESTILO_CERVEZA ADD CONSTRAINT FK_TIPOESTILO_ESTILOCERVEZA FOREIGN KEY (FK_estilo_cerveza) REFERENCES ESTILO_CERVEZA (est_cer_id);