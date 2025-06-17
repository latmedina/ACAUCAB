--------------------------------------------------------------------------------
-- 1. LUGAR
--------------------------------------------------------------------------------

CREATE TABLE LUGAR
(
    lug_id     SERIAL PRIMARY KEY ,
    lug_nombre VARCHAR(90) NOT NULL ,
    lug_tipo   VARCHAR(20) ,
    fk_lugar  INT ,
    -- Relación recursiva con lad entidad LUGAR
    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar)
            REFERENCES LUGAR (lug_id) ON DELETE CASCADE
);

-- Índice para optimizar consultas en fk_lug_id (relación jerárquica)
CREATE INDEX idx_lugar_padre
    ON LUGAR (fk_lugar);

--------------------------------------------------------------------------------
-- 2. TIENDA
--------------------------------------------------------------------------------

--  Tienda
CREATE TABLE TIENDA
(
    tie_id              SERIAL PRIMARY KEY ,
    tie_nombre          VARCHAR(150) NOT NULL ,
    tie_direccion       VARCHAR(255) NOT NULL ,
    tie_tipo            VARCHAR(20)  NOT NULL ,
    fk_lugar            INT          NOT NULL ,

    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id)
            ON DELETE CASCADE,
    
    CONSTRAINT ck_tie_nombre
        CHECK (tie_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),    

    CONSTRAINT ck_tie_direccion
        CHECK (tie_direccion ~ '^[A-Za-z0-9ÁÉÍÓÚÑáéíóúñ\s,.-]+$'),

    CONSTRAINT ck_tie_tipo
        CHECK (tie_tipo IN ('FISICA', 'ONLINE')) -- Restricción para asegurar que el tipo de tienda sea FISICA o ONLINE.

);

CREATE TABLE LUGAR_TIENDA
(
    lug_tie_id SERIAL PRIMARY KEY ,
    lug_tie_nombre VARCHAR(255) NOT NULL ,
    lug_tie_tipo VARCHAR(255) NOT NULL ,
    fk_tienda INT NOT NULL ,
    fk_lugar_tienda INT ,

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_lugar_tienda
        FOREIGN KEY (fk_lugar_tienda) REFERENCES LUGAR (lug_id)
            ON DELETE CASCADE

);

CREATE INDEX idx_lug_tie_fk_lugar_tienda
    ON LUGAR_TIENDA (fk_lugar_tienda);

CREATE TABLE ANAQUEL
(
    ana_id SERIAL PRIMARY KEY,
    ana_numero INT NOT NULL,
    fk_lugar_tienda INT NOT NULL,

    CONSTRAINT fk_lugar_tienda
        FOREIGN KEY (fk_lugar_tienda) REFERENCES LUGAR_TIENDA (lug_tie_id)
            ON DELETE CASCADE

);


--------------------------------------------------------------------------------
-- . CERVEZA
--------------------------------------------------------------------------------

-- Tabla: TIPO_CERVEZA
CREATE TABLE TIPO_CERVEZA 
(
    tip_cer_id      SERIAL       PRIMARY KEY ,
    tip_cer_familia VARCHAR(255) NOT NULL ,

    CONSTRAINT ck_tip_cer_familia
        CHECK (tip_cer_familia IN ('Lager', 'Ale', 'Wheat Beer')) -- Restricción para asegurar que la familia de cerveza sea una de las opciones válidas.
);

CREATE TABLE ESTILO_CERVEZA 
(
    est_cer_id          SERIAL       PRIMARY KEY ,
    est_cer_nombre      VARCHAR(255) NOT NULL ,
    est_cer_descripcion VARCHAR(255) NOT NULL ,

    CONSTRAINT ck_est_cer_nombre
        CHECK (est_cer_nombre ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$'),

    CONSTRAINT ck_est_cer_descripcion
        CHECK (est_cer_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$')
);

CREATE TABLE TIPO_ESTILO_CERVEZA
(
    tip_est_cer_id          SERIAL       PRIMARY KEY ,
    tip_est_cer_nombre      VARCHAR(255) NOT NULL ,
    tip_est_cer_descripcion VARCHAR(255) NOT NULL ,
    fk_estilo_cerveza       INT          NOT NULL ,
    fk_tipo_cerveza         INT          NOT NULL ,

    CONSTRAINT fk_estilo_cerveza
        FOREIGN KEY (fk_estilo_cerveza) REFERENCES ESTILO_CERVEZA (est_cer_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tipo_cerveza
        FOREIGN KEY (fk_tipo_cerveza) REFERENCES TIPO_CERVEZA (tip_cer_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_tip_est_cer_nombre
        CHECK (tip_est_cer_nombre ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$'),

    CONSTRAINT ck_tip_est_cer_descripcion
        CHECK (tip_est_cer_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$')
);

-- Tabla: RECETA
CREATE TABLE RECETA
(
    rec_id          SERIAL PRIMARY KEY ,
    rec_nombre      VARCHAR(255) NOT NULL ,
    rec_descripcion VARCHAR(255) NOT NULL ,

    CONSTRAINT ck_rec_nombre
        CHECK (rec_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'), -- Restricción para asegurar que el nombre de la receta tenga un formato válido.

    CONSTRAINT ck_rec_descripcion
        CHECK (rec_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$') -- Restricción para asegurar que la descripción de la receta tenga un formato válido.
);

-- Tabla: CERVEZA
CREATE TABLE CERVEZA 
(
    cer_id                 SERIAL        PRIMARY KEY ,
    cer_nombre             VARCHAR(255)  NOT NULL ,
    cer_descripcion        VARCHAR(255)  NOT NULL ,
    cer_grado_alcohol      DECIMAL(5, 2) NOT NULL ,
    fk_tipo_estilo_cerveza INT           NOT NULL ,
    
    CONSTRAINT fk_tipo_estilo_cerveza
        FOREIGN KEY (fk_tipo_estilo_cerveza) REFERENCES TIPO_ESTILO_CERVEZA (tip_est_cer_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_cer_nombre
        CHECK (cer_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_cer_descripcion
        CHECK (cer_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$'),  

    CONSTRAINT ck_cer_grado_alcohol
        CHECK (cer_grado_alcohol >= 0.0 AND cer_grado_alcohol <= 100.0) -- Restricción para asegurar que el grado de alcohol esté entre 0 y 100.
);

-- Tabla: PRESENTACION
CREATE TABLE PRESENTACION 
(
    prese_id         SERIAL         PRIMARY KEY ,
    prese_volumen    DECIMAL(10, 2) NOT NULL ,
    prese_recipiente VARCHAR(255)   NOT NULL ,
    fk_cerveza       INT ,
    prese_imagen     VARCHAR(255)   NOT NULL ,
    prese_alto       DECIMAL(10, 2) ,
    prese_ancho      DECIMAL(10, 2) ,

    CONSTRAINT fk_cerveza
        FOREIGN KEY (fk_cerveza) REFERENCES CERVEZA (cer_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_prese_volumen
        CHECK (prese_volumen > 0), -- Restricción para asegurar que el volumen sea mayor a 0.

    CONSTRAINT ck_prese_recipiente
        CHECK (prese_recipiente ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'), -- Restricción para asegurar que el recipiente tenga un formato válido.

    CONSTRAINT ck_prese_imagen
        CHECK (prese_imagen ~ '^(https?://)?([a-zA-Z0-9.-]+)(:[0-9]+)?(/.*)?$'), -- Restricción para asegurar que la imagen tenga un formato de URL válido.

    CONSTRAINT ck_prese_alto
        CHECK (prese_alto IS NULL OR prese_alto > 0), -- Restricción para asegurar que el alto sea mayor a 0 si se proporciona.

    CONSTRAINT ck_prese_ancho
        CHECK (prese_ancho IS NULL OR prese_ancho > 0) -- Restricción para asegurar que el ancho sea mayor a 0 si se proporciona.
);

-- Tabla: INGREDIENTE
CREATE TABLE INGREDIENTE 
(
    ing_id          SERIAL PRIMARY KEY ,
    ing_nombre      VARCHAR(255) NOT NULL ,
    ing_descripcion VARCHAR(255) NOT NULL ,

    CONSTRAINT ck_ing_descripcion
        CHECK (ing_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$') -- Restricción para asegurar que la descripción del ingrediente tenga un formato válido.
);

-- Tabla: REC_ING
CREATE TABLE REC_ING 
(
    rec_ing_id       SERIAL NOT NULL ,
    fk_receta        INT NOT NULL ,
    fk_ingrediente   INT NOT NULL ,
    rec_ing_cantidad DECIMAL(10, 3) NOT NULL,

    PRIMARY KEY (rec_ing_id, fk_receta, fk_ingrediente),

    CONSTRAINT fk_receta
        FOREIGN KEY (fk_receta) REFERENCES RECETA (rec_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_ingrediente
        FOREIGN KEY (fk_ingrediente) REFERENCES INGREDIENTE (ing_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_rec_ing_cantidad
        CHECK (rec_ing_cantidad > 0) -- Restricción para asegurar que la cantidad sea mayor a 0.
);

-- Tabla: INSTRUCCION
CREATE TABLE INSTRUCCION 
(
    ins_id          SERIAL PRIMARY KEY ,
    ins_descripcion VARCHAR(1000) NOT NULL ,

    CONSTRAINT ck_ins_descripcion
        CHECK (ins_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$') -- Restricción para asegurar que la descripción tenga un formato válido.
);

-- Tabla: REC_INS
CREATE TABLE REC_INS
(
    rec_ins_id     SERIAL NOT NULL, 
    FK_receta      INT NOT NULL, 
    FK_instruccion INT NOT NULL,
    PRIMARY KEY (rec_ins_id, FK_receta, FK_instruccion), -- Clave primaria compuesta por rec_ins_id, FK_receta y FK_instruccion.

    CONSTRAINT fk_receta
        FOREIGN KEY (FK_receta) REFERENCES RECETA (rec_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_instruccion
        FOREIGN KEY (FK_instruccion) REFERENCES INSTRUCCION (ins_id)
            ON DELETE CASCADE
);

CREATE TABLE CARACTERISTICA
(
    car_id          SERIAL PRIMARY KEY ,
    car_nombre      VARCHAR(255) NOT NULL ,
    car_descripcion VARCHAR(255) NOT NULL ,

    CONSTRAINT ck_car_nombre
        CHECK (car_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'), -- Restricción para asegurar que el nombre tenga un formato válido.

    CONSTRAINT ck_car_descripcion
        CHECK (car_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$') -- Restricción para asegurar que la descripción tenga un formato válido.
);

CREATE TABLE CERV_CAR
(
    fk_cerveza        INT NOT NULL ,
    fk_caracteristica INT NOT NULL ,
    carac_cer_valor   VARCHAR(255) NOT NULL ,
    PRIMARY KEY (fk_cerveza, fk_caracteristica), -- Clave primaria compuesta por cer_car_id, fk_cerveza y fk_caracteristica.

    CONSTRAINT fk_cerveza
        FOREIGN KEY (fk_cerveza) REFERENCES CERVEZA (cer_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_caracteristica
        FOREIGN KEY (fk_caracteristica) REFERENCES CARACTERISTICA (car_id)
            ON DELETE CASCADE
);

CREATE TABLE CAR_TIP_CER
(
    fk_caracteristica INT NOT NULL ,
    fk_tipo_cerveza  INT NOT NULL ,
    carac_tip_cer_valor   VARCHAR(255) NOT NULL ,
    PRIMARY KEY (fk_caracteristica, fk_tipo_cerveza), -- Clave primaria compuesta por fk_caracteristica y fk_tipo_cerveza.

    CONSTRAINT fk_caracteristica
        FOREIGN KEY (fk_caracteristica) REFERENCES CARACTERISTICA (car_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tipo_cerveza
        FOREIGN KEY (fk_tipo_cerveza) REFERENCES TIPO_CERVEZA (tip_cer_id)
            ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- . CLIENTE
--------------------------------------------------------------------------------

CREATE TABLE CLIENTE
(
    cli_id                  SERIAL PRIMARY KEY,
    cli_rif                 VARCHAR(12)  NOT NULL UNIQUE,
    cli_direccion_fisica    VARCHAR(255) NOT NULL,
    cli_tipo_cliente        VARCHAR(10)  NOT NULL,
    cli_nat_ci              VARCHAR(12)  UNIQUE,
    cli_nat_pnombre         VARCHAR(50),
    cli_nat_snombre         VARCHAR(50),
    cli_nat_papellido       VARCHAR(50),
    cli_nat_sapellido       VARCHAR(50),
    cli_nat_sexo            CHAR(1),
    cli_jur_denom_comercial VARCHAR(70),
    cli_jur_razon_social    VARCHAR(70),
    cli_jur_url_web         VARCHAR(255),
    cli_jur_capital         INT,
    cli_jur_dir_fiscal      VARCHAR(255),
    fk_lugar                INT          NOT NULL,
    cli_cantidad_puntos     INT          DEFAULT 0,

    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id),

    CONSTRAINT chk_cliente_tipo
        CHECK (cli_tipo_cliente IN ('NATURAL', 'JURIDICO')),

    CONSTRAINT chk_cliente_sexo
        CHECK (cli_nat_sexo IS NULL OR cli_nat_sexo IN ('M', 'F')),

    CONSTRAINT chk_integridad_tipo_cliente
        CHECK (
            (cli_tipo_cliente = 'NATURAL' AND cli_nat_pnombre IS NOT NULL AND cli_nat_papellido IS NOT NULL AND cli_jur_denom_comercial IS NULL)
            OR
            (cli_tipo_cliente = 'JURIDICO' AND cli_jur_denom_comercial IS NOT NULL AND cli_jur_razon_social IS NOT NULL AND cli_nat_pnombre IS NULL)
        ),

    CONSTRAINT ck_cli_ci
        CHECK (cli_nat_ci IS NULL OR cli_nat_ci ~ '^[VEJP]{1}[0-9]{7,10}$'),

    CONSTRAINT ck_cli_rif
        CHECK (cli_rif ~ '^[J]{1}[0-9]{9}$'),


    CONSTRAINT ck_cli_nat_pnombre
        CHECK (cli_nat_pnombre IS NULL OR cli_nat_pnombre ~ '^[A-Za-z0-9\s]+$'),

    CONSTRAINT ck_cli_nat_snombre
        CHECK (cli_nat_snombre IS NULL OR cli_nat_snombre ~ '^[A-Za-z0-9\s]+$'),
    
    CONSTRAINT ck_cli_nat_papellido
        CHECK (cli_nat_papellido IS NULL OR cli_nat_papellido ~ '^[A-Za-z0-9\s]+$'),

    CONSTRAINT ck_cli_nat_sapellido 
        CHECK (cli_nat_sapellido IS NULL OR cli_nat_sapellido ~ '^[A-Za-z0-9\s]+$'),

    CONSTRAINT ck_cli_jur_denom_comercial
        CHECK (cli_jur_denom_comercial IS NULL OR cli_jur_denom_comercial ~ '^[A-Za-z0-9\s.]+$'),

    CONSTRAINT ck_cli_jur_razon_social
        CHECK (cli_jur_razon_social IS NULL OR cli_jur_razon_social ~ '^[A-Za-z0-9\s.]+$'),

    CONSTRAINT ck_cli_jur_url_web
        CHECK (cli_jur_url_web IS NULL OR cli_jur_url_web ~ '^(https?://)?([a-zA-Z0-9.-]+)(:[0-9]+)?(/.*)?$'),

    CONSTRAINT ck_cli_jur_dir_fiscal
        CHECK (cli_jur_dir_fiscal IS NULL OR cli_jur_dir_fiscal ~ '^[A-Za-z0-9ÁÉÍÓÚÑáéíóúñ\s,.-]+$')      
);

CREATE TABLE CONTACTO_CLIENTE
(
    con_cli_id          SERIAL PRIMARY KEY ,
    con_cli_nombre     VARCHAR(50) NOT NULL ,
    con_cli_apellido   VARCHAR(50) NOT NULL ,
    fk_cliente          INT NOT NULL ,

    CONSTRAINT fk_contacto_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_con_cli_nombre
        CHECK (con_cli_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_con_cli_apellido
        CHECK (con_cli_apellido ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$')
);

--------------------------------------------------------------------------------
-- . PROVEEDOR
--------------------------------------------------------------------------------

CREATE TABLE PROVEEDOR
(
    pro_id                      SERIAL PRIMARY KEY ,
    pro_rif                     VARCHAR(12)  NOT NULL UNIQUE ,
    pro_denominacion_comercial  VARCHAR(70) ,
    pro_razon_social            VARCHAR(70) ,
    pro_url_web                 VARCHAR(255) ,
    pro_direccion_fiscal        VARCHAR(255) ,
    fk_lugar                    INT          NOT NULL ,
    
    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id),

    CONSTRAINT ck_pro_rif
        CHECK (pro_rif ~ '^[J]{1}[0-9]{9}$'),

    CONSTRAINT ck_pro_denominacion_comercial
        CHECK (pro_denominacion_comercial ~ '^[A-Za-z0-9\s.]+$'),

    CONSTRAINT ck_pro_razon_social
        CHECK (pro_razon_social ~ '^[A-Za-z0-9\s.]+$'),

    CONSTRAINT ck_pro_url_web
        CHECK (pro_url_web ~ '^(https?://)?([a-zA-Z0-9.-]+)(:[0-9]+)?(/.*)?$'),

    CONSTRAINT ck_pro_direccion_fiscal
        CHECK (pro_direccion_fiscal ~ '^[A-Za-z0-9ÁÉÍÓÚÑáéíóúñ\s,.-]+$')  
);

CREATE TABLE CONTACTO_PROVEEDOR
(
    con_pro_id          SERIAL PRIMARY KEY ,
    con_pro_nombre     VARCHAR(50) NOT NULL ,
    con_pro_apellido   VARCHAR(50) NOT NULL ,
    fk_proveedor       INT NOT NULL ,

    CONSTRAINT fk_contacto_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_con_pro_nombre
        CHECK (con_pro_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_con_pro_apellido
        CHECK (con_pro_apellido ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$')
);

CREATE TABLE AFILIACION
(
    afi_id         SERIAL PRIMARY KEY ,
    afi_nombre     VARCHAR(50) NOT NULL ,
    afi_monto      INT NOT NULL ,
    fk_proveedor   INT NOT NULL ,
    fk_tienda      INT NOT NULL ,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id)
            ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- . EMPLEADO
--------------------------------------------------------------------------------

--  Empleado
CREATE TABLE EMPLEADO
(
    emp_id                 SERIAL        PRIMARY KEY ,
    emp_ci                 VARCHAR(12)   NOT NULL UNIQUE ,
    emp_pnombre            VARCHAR(30)   NOT NULL ,
    emp_snombre            VARCHAR(30)   ,
    emp_papellido          VARCHAR(30)   NOT NULL ,
    emp_sapellido          VARCHAR(30)   ,
    emp_direccion          VARCHAR(70)   NOT NULL ,
    emp_fecha_nacimiento   DATE          NOT NULL ,
    emp_sexo               CHAR(1)       NOT NULL ,
    fk_lugar               INT           NOT NULL ,
    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id),

	CONSTRAINT ck_emp_ci
        CHECK (emp_ci ~ '^[VEJP]{1}[0-9]{7,10}$'),

    CONSTRAINT ck_emp_sexo
        CHECK (emp_sexo IN ('M', 'F')),

    CONSTRAINT ck_emp_fecha_nacimiento
        CHECK (emp_fecha_nacimiento <= CURRENT_DATE AND emp_fecha_nacimiento >= '1900-01-01'),

    CONSTRAINT ck_emp_pnombre
        CHECK (emp_pnombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$' AND emp_papellido ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_emp_papellido
        CHECK (emp_papellido ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_emp_snombre
        CHECK (emp_snombre IS NULL OR emp_snombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_emp_sapellido
        CHECK (emp_sapellido IS NULL OR emp_sapellido ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_emp_direccion
        CHECK (emp_direccion ~ '^[A-Za-z0-9ÁÉÍÓÚÑáéíóúñ\s,.-]+$')
);

CREATE TABLE CARGO
(
    car_id              SERIAL PRIMARY KEY ,
    car_nombre          VARCHAR(100) NOT NULL UNIQUE ,
    car_descripcion     TEXT NOT NULL ,
    car_salario         INT NOT NULL ,

    CONSTRAINT ck_car_nombre
        CHECK (car_nombre ~ '^[A-Z][a-zA-Z0-9\s]+$'),

    CONSTRAINT ck_car_salario
        CHECK (car_salario > 0) 
);

CREATE TABLE DEPARTAMENTO
(
    dep_id              SERIAL PRIMARY KEY ,
    dep_nombre          VARCHAR(100) NOT NULL UNIQUE ,
    dep_descripcion     TEXT NOT NULL ,

    CONSTRAINT ck_dep_nombre
        CHECK (dep_nombre ~ '^[A-Z][a-zA-Z0-9\s]+$')
);

CREATE TABLE DEP_TIE 
(
    fk_departamento INT NOT NULL ,
    fk_tienda       INT NOT NULL ,
    dep_tie_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE ,
    dep_tie_fecha_fin    DATE ,

    CONSTRAINT pk_dep_tie
        PRIMARY KEY (fk_departamento, fk_tienda),

    CONSTRAINT fk_departamento
        FOREIGN KEY (fk_departamento) REFERENCES DEPARTAMENTO (dep_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_dep_tie_fecha_inicio
        CHECK (dep_tie_fecha_inicio <= CURRENT_DATE AND dep_tie_fecha_inicio >= '1900-01-01'),

    CONSTRAINT ck_dep_tie_fecha_fin
        CHECK (dep_tie_fecha_fin IS NULL OR dep_tie_fecha_fin >= dep_tie_fecha_inicio)
);

CREATE TABLE EMP_CAR
(
    fk_empleado          INT NOT NULL ,
    fk_cargo             INT NOT NULL ,
    fk_departamento      INT NOT NULL ,
    fk_tienda            INT NOT NULL ,
    emp_car_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE ,
    emp_car_fecha_fin    DATE ,

    CONSTRAINT pk_empleado_cargo
        PRIMARY KEY (fk_empleado, fk_cargo, fk_departamento, fk_tienda),

    CONSTRAINT fk_dep_tie
        FOREIGN KEY (fk_departamento, fk_tienda) REFERENCES DEP_TIE (fk_departamento, fk_tienda)
            ON DELETE CASCADE,

    CONSTRAINT fk_empleado
        FOREIGN KEY (fk_empleado) REFERENCES EMPLEADO (emp_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_cargo
        FOREIGN KEY (fk_cargo) REFERENCES CARGO (car_id)
            ON DELETE CASCADE,

-----------------------------------------------------------------------
    CONSTRAINT uq_empleado_cargo 
        UNIQUE (fk_empleado, fk_cargo),
----------------------------------------------------------------------

    CONSTRAINT ck_emp_car_fecha_inicio
        CHECK (emp_car_fecha_inicio <= CURRENT_DATE AND emp_car_fecha_inicio >= '1900-01-01'),

    CONSTRAINT ck_emp_car_fecha_fin
        CHECK (emp_car_fecha_fin IS NULL OR emp_car_fecha_fin >= emp_car_fecha_inicio)
);

CREATE TABLE ASISTENCIA
(
    asi_id               SERIAL PRIMARY KEY ,
    asi_fecha_hora_inico TIMESTAMP NOT NULL ,
    asi_fecha_hora_fin   TIMESTAMP ,
    fk_empleado          INT NOT NULL ,

    CONSTRAINT fk_empleado
        FOREIGN KEY (fk_empleado) REFERENCES EMPLEADO (emp_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_asi_fecha_hora_inicio
        CHECK (asi_fecha_hora_inico <= CURRENT_TIMESTAMP AND asi_fecha_hora_inico >= '1900-01-01 00:00:00'),

    CONSTRAINT ck_asi_fecha_hora_fin
        CHECK (asi_fecha_hora_fin IS NULL OR asi_fecha_hora_fin >= asi_fecha_hora_inico)
);

CREATE TABLE HORARIO
(
    hor_id              SERIAL PRIMARY KEY ,
    hor_dia            VARCHAR(10) NOT NULL ,
    hor_hora_inicio     TIME NOT NULL ,
    hor_hora_fin        TIME NOT NULL ,

    CONSTRAINT ck_hor_dia
        CHECK (hor_dia IN ('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo')),

    CONSTRAINT ck_hor_hora_inicio
        CHECK (hor_hora_inicio >= '00:00:00' AND hor_hora_inicio <= '23:59:59'),

    CONSTRAINT ck_hor_hora_fin
        CHECK (hor_hora_fin >= '00:00:00' AND hor_hora_fin <= '23:59:59' AND hor_hora_fin > hor_hora_inicio)
);

CREATE TABLE EMP_CAR_HOR 
(
    fk_empleado          INT NOT NULL ,
    fk_cargo             INT NOT NULL ,
    fk_departamento      INT NOT NULL ,
    fk_tienda            INT NOT NULL ,
    fk_horario           INT NOT NULL ,

    CONSTRAINT pk_emp_car_hor
        PRIMARY KEY (fk_empleado, fk_cargo, fk_departamento, fk_tienda, fk_horario),

    CONSTRAINT fk_empleado
        FOREIGN KEY (fk_empleado) REFERENCES EMPLEADO (emp_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_cargo
        FOREIGN KEY (fk_cargo) REFERENCES CARGO (car_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_departamento
        FOREIGN KEY (fk_departamento) REFERENCES DEPARTAMENTO (dep_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_horario
        FOREIGN KEY (fk_horario) REFERENCES HORARIO (hor_id)
            ON DELETE CASCADE
);

CREATE TABLE VACACION
(
    vac_id              SERIAL PRIMARY KEY ,
    vac_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE ,
    vac_fecha_fin       DATE ,
    fk_empleado         INT NOT NULL ,

    CONSTRAINT fk_empleado
        FOREIGN KEY (fk_empleado) REFERENCES EMPLEADO (emp_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_vac_fecha_inicio
        CHECK (vac_fecha_inicio <= CURRENT_DATE AND vac_fecha_inicio >= '1900-01-01'),

    CONSTRAINT ck_vac_fecha_fin
        CHECK (vac_fecha_fin IS NULL OR vac_fecha_fin >= vac_fecha_inicio)
);

CREATE TABLE TIPO_BENEFICIO
(
    tip_ben_id          SERIAL PRIMARY KEY ,
    tip_ben_nombre      VARCHAR(255) NOT NULL UNIQUE ,
    tip_ben_descripcion TEXT NOT NULL ,

    CONSTRAINT ck_tip_ben_nombre
        CHECK (tip_ben_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_tip_ben_descripcion
        CHECK (tip_ben_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$')
);

CREATE TABLE EMP_TIP_BEN
(
    fk_empleado         INT NOT NULL ,
    fk_tipo_beneficio   INT NOT NULL ,
    emp_tip_ben_monto   INT NOT NULL ,

    CONSTRAINT pk_emp_tip_ben
        PRIMARY KEY (fk_empleado, fk_tipo_beneficio),

    CONSTRAINT fk_empleado
        FOREIGN KEY (fk_empleado) REFERENCES EMPLEADO (emp_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tipo_beneficio
        FOREIGN KEY (fk_tipo_beneficio) REFERENCES TIPO_BENEFICIO (tip_ben_id)
            ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- . TELEFONO, CORREO_ELECTRONICO
--------------------------------------------------------------------------------

--  Teléfono
CREATE TABLE TELEFONO
(
    tel_id                  SERIAL PRIMARY KEY ,
    tel_codigo_area         VARCHAR(30) NOT NULL ,
    tel_numero              BIGINT NOT NULL ,
    fk_empleado             INT ,
    fk_cliente              INT ,
    fk_contacto_cliente     INT ,
    fk_contacto_proveedor   INT ,
    fk_proveedor            INT ,
    CONSTRAINT fk_empleado 
        FOREIGN KEY (fk_empleado ) REFERENCES EMPLEADO (emp_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_contacto_cliente 
        FOREIGN KEY (fk_contacto_cliente) REFERENCES CONTACTO_CLIENTE (con_cli_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_contacto_proveedor
        FOREIGN KEY (fk_contacto_proveedor) REFERENCES CONTACTO_PROVEEDOR (con_pro_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,
            
    CONSTRAINT ck_codigo_area
        CHECK (tel_codigo_area ~ '^\+(?:[1-9]\d{0,2})$'),

    CONSTRAINT ck_tel_numero
        CHECK (tel_numero >= 1000000000 AND tel_numero <= 99999999999),

    CONSTRAINT chk_telefono_origen_exclusivo
        CHECK (
            (fk_empleado IS NOT NULL)::int +
            (fk_cliente IS NOT NULL)::int +
            (fk_contacto_cliente   IS NOT NULL)::int +
            (fk_contacto_proveedor IS NOT NULL)::int +
            (fk_proveedor IS NOT NULL)::int
            = 1
        )
);

--  Correo Electrónico
CREATE TABLE CORREO_ELECTRONICO
(
    cor_ele_id         SERIAL PRIMARY KEY ,
    cor_ele_direccion  VARCHAR(70) NOT NULL ,
    fk_empleado             INT NULL,
    fk_cliente              INT NULL,
    fk_contacto_cliente     INT NULL,
    fk_contacto_proveedor   INT NULL,
    fk_proveedor            INT NULL,
    CONSTRAINT fk_empleado 
        FOREIGN KEY (fk_empleado ) REFERENCES EMPLEADO (emp_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_contacto_cliente 
        FOREIGN KEY (fk_contacto_cliente) REFERENCES CONTACTO_CLIENTE (con_cli_id)
            ON DELETE CASCADE,
            
    CONSTRAINT fk_contacto_proveedor
        FOREIGN KEY (fk_contacto_proveedor) REFERENCES CONTACTO_PROVEEDOR (con_pro_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_cor_ele_direccion
        CHECK (cor_ele_direccion ~ '^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$'),

    CONSTRAINT chk_correo_origen_exclusivo
        CHECK (
            (fk_empleado IS NOT NULL)::int +
            (fk_cliente IS NOT NULL)::int +
            (fk_contacto_cliente   IS NOT NULL)::int +
            (fk_contacto_proveedor IS NOT NULL)::int +
            (fk_proveedor IS NOT NULL)::int
            = 1
        )
);


--------------------------------------------------------------------------------
-- .PRIVILEGIO, ROL, PRI_ROL, USUARIO
--------------------------------------------------------------------------------

--  Rol
CREATE TABLE ROL
(
    rol_id          SERIAL PRIMARY KEY ,
    rol_nombre      VARCHAR(30) NOT NULL ,
    rol_descripcion VARCHAR(255) ,

    CONSTRAINT ck_rol_nombre
        CHECK (UPPER(rol_nombre) in ('EMPLEADO', 'CLIENTE', 'PROVEEDOR', 'ADMINISTRADOR') OR
               UPPER(rol_nombre) ~ '^[A-Z]+$')
);

--  Privilegio
CREATE TABLE PRIVILEGIO
(
    pri_id     SERIAL PRIMARY KEY ,
    pri_accion VARCHAR(30) NOT NULL ,
    pri_vista  VARCHAR(30) NOT NULL ,
    CONSTRAINT ck_pri_accion
        CHECK (UPPER(pri_accion) in ('CREATE', 'DELETE', 'UPDATE', 'READ'))
);

--  Privilegio Rol (relación)
CREATE TABLE PRI_ROL
(
    fk_rol INT NOT NULL ,
    fk_privilegio INT NOT NULL ,
    CONSTRAINT pk_pri_rol
        PRIMARY KEY (fk_privilegio, fk_rol),

    CONSTRAINT fk_privilegio
        FOREIGN KEY (fk_privilegio) REFERENCES PRIVILEGIO (pri_id),

    CONSTRAINT fk_rol
        FOREIGN KEY (fk_rol) REFERENCES ROL (rol_id)

);

-- Usuario
CREATE TABLE USUARIO
(
    usu_id             SERIAL PRIMARY KEY ,
    usu_nombre_usuario VARCHAR(30) NOT NULL ,
    usu_contrasena     VARCHAR(30) NOT NULL ,
    usu_email          VARCHAR(60) NOT NULL ,
    fk_rol             INT         NOT NULL ,
    fk_empleado        INT ,
    fk_cargo           INT ,
    fk_departamernto   INT ,
    fk_tienda          INT ,
    fk_cliente         INT ,
    fk_proveedor       INT ,

    CONSTRAINT fk_rol
        FOREIGN KEY (fk_rol) REFERENCES ROL (rol_id),
            
    CONSTRAINT fk_emp_car
        FOREIGN KEY (fk_empleado, fk_cargo, fk_departamernto, fk_tienda) REFERENCES EMP_CAR (fk_empleado, fk_cargo, fk_departamento, fk_tienda)
            ON DELETE CASCADE,
                    
    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,

    CONSTRAINT chk_correo_origen_exclusivo
        CHECK (
            (fk_empleado IS NOT NULL)::int +
            (fk_cliente IS NOT NULL)::int +
            (fk_proveedor IS NOT NULL)::int
            = 1
        )
);


--------------------------------------------------------------------------------
-- . VENTA_FISICA, VENTA_ONLINE, OFERTA
--------------------------------------------------------------------------------

-- Oferta
CREATE TABLE OFERTA
(
    ofe_id              SERIAL PRIMARY KEY ,
    ofe_nombre          VARCHAR(100) NOT NULL ,
    ofe_descripcion     TEXT NOT NULL ,
    ofe_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE ,
    ofe_fecha_fin       DATE ,
    of_procentaje       INT NOT NULL ,
    
    CONSTRAINT ck_ofe_fecha_inicio
        CHECK (ofe_fecha_inicio <= CURRENT_DATE AND ofe_fecha_inicio >= '1900-01-01'),

    CONSTRAINT ck_ofe_fecha_fin
        CHECK (ofe_fecha_fin IS NULL OR ofe_fecha_fin >= ofe_fecha_inicio)
);

CREATE TABLE INVENTARIO
(
    inv_id SERIAL  PRIMARY KEY ,
    inv_cantidad INT NOT NULL ,
    fk_anaquel INT NOT NULL ,
    fk_presentacion INT NOT NULL ,
    fk_oferta INT ,

    CONSTRAINT fk_anaquel
        FOREIGN KEY (fk_anaquel) REFERENCES ANAQUEL (ana_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (prese_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_oferta
        FOREIGN KEY (fk_oferta) REFERENCES OFERTA (ofe_id)
            ON DELETE CASCADE

);

CREATE TABLE ALMACEN
(
    alm_id              SERIAL PRIMARY KEY ,
    alm_nombre          VARCHAR(100) NOT NULL ,
    alm_descripcion     TEXT NOT NULL ,
    fk_tienda           INT NOT NULL ,

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_alm_nombre
        CHECK (alm_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),

    CONSTRAINT ck_alm_descripcion
        CHECK (alm_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$')
);

CREATE TABLE PRE_ALM
(
    pre_alm_id SERIAL PRIMARY KEY ,
    pre_alm_precio DECIMAL(10, 2) NOT NULL ,
    pre_alm_cantidad INT NOT NULL ,
    fk_almacen INT NOT NULL ,
    fk_presentacion INT NOT NULL ,
    fk_oferta INT ,

    CONSTRAINT fk_almacen
        FOREIGN KEY (fk_almacen) REFERENCES ALMACEN (alm_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (prese_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_oferta
        FOREIGN KEY (fk_oferta) REFERENCES OFERTA (ofe_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_pre_alm_precio
        CHECK (pre_alm_precio > 0) -- Restricción para asegurar que el precio sea mayor a 0.
);   
-- Venta Física
CREATE TABLE VENTA_FISICA
(
    ven_fis_id          SERIAL PRIMARY KEY ,
    ven_fis_fecha       DATE NOT NULL DEFAULT CURRENT_DATE ,
    ven_fis_total       INT NOT NULL ,
    fk_tienda           INT NOT NULL ,
    fk_cliente          INT NOT NULL ,
    fk_oferta           INT ,

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id),

    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_oferta
        FOREIGN KEY (fk_oferta) REFERENCES OFERTA (ofe_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_ven_fis_fecha
        CHECK (ven_fis_fecha <= CURRENT_DATE AND ven_fis_fecha >= '1900-01-01'),

    CONSTRAINT ck_ven_fis_total
        CHECK (ven_fis_total > 0)
);

CREATE TABLE DETALLE_VENTA_FISICA
(
    det_ven_fis_id SERIAL NOT NULL ,
    det_ven_fis_cantidad INT NOT NULL ,
    det_ven_fis_precio_unitario DECIMAL(10, 2) NOT NULL ,
    fk_venta_fisica INT NOT NULL ,
    fk_inventario INT NOT NULL ,

    PRIMARY KEY (det_ven_fis_id, fk_venta_fisica, fk_inventario),
    
    CONSTRAINT fk_venta_fisica
        FOREIGN KEY (fk_venta_fisica) REFERENCES VENTA_FISICA (ven_fis_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_inventario
        FOREIGN KEY (fk_inventario) REFERENCES INVENTARIO (inv_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_det_ven_fis_cantidad
        CHECK (det_ven_fis_cantidad > 0) -- Restricción para asegurar que la cantidad sea mayor a 0.
);

-- Venta Online
CREATE TABLE VENTA_ONLINE
(
    ven_onl_id          SERIAL PRIMARY KEY ,
    ven_onl_fecha       DATE NOT NULL DEFAULT CURRENT_DATE ,
    ven_onl_total       INT NOT NULL ,
    fk_usuario          INT NOT NULL ,
    fk_oferta           INT ,
    fk_tienda           INT NOT NULL ,

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id),

    CONSTRAINT fk_usuario
        FOREIGN KEY (fk_usuario) REFERENCES USUARIO (usu_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_oferta
        FOREIGN KEY (fk_oferta) REFERENCES OFERTA (ofe_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_ven_onl_fecha
        CHECK (ven_onl_fecha <= CURRENT_DATE AND ven_onl_fecha >= '1900-01-01'),

    CONSTRAINT ck_ven_onl_total
        CHECK (ven_onl_total > 0)
);



CREATE TABLE DETALLE_VENTA_ONLINE
(
    det_ven_onl_cantidad INT NOT NULL ,
    det_ven_onl_precio DECIMAL(10, 2) NOT NULL ,
    fk_venta_online INT NOT NULL ,
    fk_pre_alm INT NOT NULL ,

    PRIMARY KEY (fk_venta_online, fk_pre_alm),

    CONSTRAINT fk_venta_online
        FOREIGN KEY (fk_venta_online) REFERENCES VENTA_ONLINE (ven_onl_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_pre_alm
        FOREIGN KEY (fk_pre_alm) REFERENCES PRE_ALM (pre_alm_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_det_ven_onl_cantidad
        CHECK (det_ven_onl_cantidad > 0)
);

--------------------------------------------------------------------------------
-- . EVENTO
--------------------------------------------------------------------------------

-- TIPO_EVENTO
CREATE TABLE TIPO_EVENTO 
(
    tip_eve_id          SERIAL PRIMARY KEY ,
    tip_eve_nombre      VARCHAR(255) NOT NULL ,
    tip_eve_descripcion VARCHAR(255) NOT NULL ,
    fk_tipo_evento      INT ,

    CONSTRAINT fk_tipo_evento
        FOREIGN KEY (fk_tipo_evento) REFERENCES TIPO_EVENTO (tip_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_tip_eve_nombre
        CHECK (tip_eve_nombre ~ '^[A-ZÁÉÍÓÚÑüÜ][a-zA-ZáéíóúñÁÉÍÓÚÑüÜ\s]+$'),
    
    CONSTRAINT ck_tip_eve_descripcion
        CHECK (tip_eve_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$')
);

-- Índice para optimizar consultas en fk_lug_id (relación jerárquica)
CREATE INDEX idx_tipo_evento_padre
    ON TIPO_EVENTO (fk_tipo_evento);


-- Tabla: EVENTO
CREATE TABLE EVENTO 
(
    eve_id          SERIAL PRIMARY KEY ,
    eve_nombre      VARCHAR(255) NOT NULL ,
    eve_descripcion VARCHAR(255) NOT NULL ,
    eve_fecha_hora  TIMESTAMP NOT NULL ,
    eve_nro_boletos INT NOT NULL ,
    fk_tip_eve      INT NOT NULL ,
    fk_lugar       INT NOT NULL ,

    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tipo_evento
        FOREIGN KEY (fk_tip_eve) REFERENCES TIPO_EVENTO (tip_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_eve_nombre
        CHECK (eve_nombre ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$'),

    CONSTRAINT ck_eve_descripcion
        CHECK (eve_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$'),  

    CONSTRAINT ck_eve_nro_boletos
        CHECK (eve_nro_boletos > 0)
);

-- Tabla: VENTA_EVENTO
CREATE TABLE VENTA_EVENTO
(
    ven_eve_id          SERIAL PRIMARY KEY ,
    ven_eve_fecha_hora  TIMESTAMP NOT NULL ,
    ven_eve_monto_total DECIMAL(18, 2) NOT NULL ,
    fk_evento           INT NOT NULL ,
    fk_cliente          INT NOT NULL ,

    CONSTRAINT fk_evento
        FOREIGN KEY (fk_evento) REFERENCES EVENTO (eve_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_ven_eve_monto_total
        CHECK (ven_eve_monto_total > 0)

);

-- Tabla: EVE_PRO
CREATE TABLE EVE_PRO 
(
    eve_pro_id      SERIAL PRIMARY KEY,
    fk_evento       INT NOT NULL ,
    fk_proveedor    INT NOT NULL ,

    CONSTRAINT uq_evento_proveedor UNIQUE (fk_evento, fk_proveedor),

    CONSTRAINT fk_evento
        FOREIGN KEY (fk_evento) REFERENCES EVENTO (eve_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE
);

CREATE TABLE EXISTENCIA_EVENTO
(
    exi_eve_id SERIAL PRIMARY KEY ,
    exi_eve_cantidad INT NOT NULL ,
    fk_presentacion INT NOT NULL ,
    fk_evento_proveedor INT NOT NULL ,

    CONSTRAINT fk_evento_proveedor
        FOREIGN KEY (fk_evento_proveedor) REFERENCES EVE_PRO (eve_pro_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (prese_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_exi_eve_cantidad
        CHECK (exi_eve_cantidad > 0)
);

CREATE TABLE DETALLE_VENTA_EVENTO
(
    det_ven_eve_id SERIAL NOT NULL ,
    det_ven_eve_cantidad INT NOT NULL ,
    det_ven_eve_precio_unitario DECIMAL(10, 2) NOT NULL ,
    fk_venta_evento INT NOT NULL ,
    fk_exi_eve INT NOT NULL ,

    CONSTRAINT fk_venta_evento
        FOREIGN KEY (fk_venta_evento) REFERENCES VENTA_EVENTO (ven_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_exi_eve
        FOREIGN KEY (fk_exi_eve) REFERENCES EXISTENCIA_EVENTO (exi_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_det_ven_eve_cantidad
        CHECK (det_ven_eve_cantidad > 0) -- Restricción para asegurar que la cantidad sea mayor a 0.


);

-- Tabla: VENTA_BOLETO_EVENTO
CREATE TABLE VENTA_BOLETO_EVENTO 
(
    ven_bol_eve_id          SERIAL PRIMARY KEY ,
    ven_bol_eve_fecha_hora  TIMESTAMP NOT NULL ,
    ven_bol_eve_monto_total DECIMAL(18, 2) NOT NULL ,
    ven_bol_eve_descripcion VARCHAR(255) NOT NULL ,


    CONSTRAINT ck_ven_bol_eve_descripcion
        CHECK (ven_bol_eve_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$') 
);

-- Tabla: ASISTENCIA_EVENTO
CREATE TABLE ASISTENCIA_EVENTO 
(
    asi_eve_id          SERIAL NOT NULL ,
    fk_evento           INT NOT NULL ,
    fk_cliente          INT NOT NULL ,
    asi_eve_fecha_hora  TIMESTAMP NOT NULL ,
    fk_ven_bol_eve      INT NOT NULL ,
    
    CONSTRAINT fk_evento
        FOREIGN KEY (fk_evento) REFERENCES EVENTO (eve_id)
            ON DELETE CASCADE,
            
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_ven_bol_eve
        FOREIGN KEY (fk_ven_bol_eve) REFERENCES VENTA_BOLETO_EVENTO (ven_bol_eve_id)
            ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- . solicitudes
--------------------------------------------------------------------------------

CREATE TABLE SOLICITUD_REPOSICION
(
    sol_rep_id SERIAL PRIMARY KEY ,
    sol_rep_fecha_hora TIMESTAMP NOT NULL ,
    sol_rep_descripcion VARCHAR(255) NOT NULL ,
    fk_usuario INT NOT NULL ,
    fk_inv INT NOT NULL ,
    fk_pre_alm INT NOT NULL ,

    CONSTRAINT fk_usuario
        FOREIGN KEY (fk_usuario) REFERENCES USUARIO (usu_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_inv
        FOREIGN KEY (fk_inv) REFERENCES INVENTARIO (inv_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_pre_alm
        FOREIGN KEY (fk_pre_alm) REFERENCES PRE_ALM (pre_alm_id)
            ON DELETE CASCADE
);

CREATE TABLE SOLICITUD_COMPRA
(
    sol_com_id SERIAL PRIMARY KEY ,
    sol_com_fecha TIMESTAMP NOT NULL ,
    sol_com_total DECIMAL(10, 2) NOT NULL ,
    fk_usuario INT NOT NULL ,
    fk_proveedor INT NOT NULL ,
    fk_pre_alm INT NOT NULL ,

    CONSTRAINT fk_usuario
        FOREIGN KEY (fk_usuario) REFERENCES USUARIO (usu_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_pre_alm
        FOREIGN KEY (fk_pre_alm) REFERENCES PRE_ALM (pre_alm_id)
            ON DELETE CASCADE
);

CREATE TABLE DETALLE_COMPRA 
(
    det_com_id SERIAL  NOT NULL ,
    det_com_cantidad INT NOT NULL ,
    det_com_precio_unitario DECIMAL(10, 2) NOT NULL ,
    fk_sol_com INT NOT NULL ,
    fk_presentacion INT NOT NULL ,

    PRIMARY KEY (det_com_id, fk_sol_com, fk_presentacion),

    CONSTRAINT fk_sol_com
        FOREIGN KEY (fk_sol_com) REFERENCES SOLICITUD_COMPRA (sol_com_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (prese_id)
            ON DELETE CASCADE,


    CONSTRAINT ck_det_com_precio_unitario
        CHECK (det_com_precio_unitario > 0)
);


--------------------------------------------------------------------------------
-- . PAGO
--------------------------------------------------------------------------------

-- Tabla: CUENTA_PUNTO
CREATE TABLE CUENTA_PUNTO
(
    cue_pun_id          SERIAL PRIMARY KEY ,
    cue_pun_cantidad    DECIMAL(12, 2) NOT NULL DEFAULT 0.00 ,
    fk_cliente          INT NOT NULL ,
    fk_venta_fisica     INT NOT NULL ,

    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_cue_pun_cantidad 
        CHECK (cue_pun_cantidad  >= 0)
);

-- Tabla: HISTORICO_PRECIO_PUNTO
CREATE TABLE HISTORICO_PRECIO_PUNTO
(
    his_pre_pun_id          SERIAL PRIMARY KEY ,
    his_pre_pun_fecha_hora  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP ,
    his_pre_pun_valor       INT NOT NULL ,

    CONSTRAINT ck_his_pre_pun_fecha_hora
        CHECK (his_pre_pun_fecha_hora <= CURRENT_TIMESTAMP AND his_pre_pun_fecha_hora >= '1900-01-01 00:00:00')
);

-- Tabla: METODO_PAGO
CREATE TABLE METODO_PAGO
(
    met_pag_id          SERIAL PRIMARY KEY ,
    efe_denominacion    INT ,
    che_num_cheque      INT ,
    tar_deb_numero      BIGINT ,
    tar_deb_vencimiento DATE ,
    tar_deb_banco       VARCHAR(50) ,
    tar_cre_numero      BIGINT ,
    tar_cre_vencimiento DATE ,
    met_pag_tipo_pago   VARCHAR(50) NOT NULL ,
    fk_his_pre_pun      INT ,

    CONSTRAINT fk_his_pre_pun
        FOREIGN KEY (fk_his_pre_pun) REFERENCES HISTORICO_PRECIO_PUNTO (his_pre_pun_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_met_pag_tipo_pago
        CHECK (UPPER(met_pag_tipo_pago) IN ('EFECTIVO', 'CHEQUE', 'TARJETA_DEBITO', 'TARJETA_CREDITO', 'PUNTO'))
);

CREATE TABLE MONEDA
(
    mon_id              SERIAL PRIMARY KEY ,
    mon_tipo            VARCHAR(50) NOT NULL UNIQUE ,

    CONSTRAINT ck_mon_tipo
        CHECK (UPPER(mon_tipo) IN ('BOLIVAR', 'DOLAR', 'EURO', 'YEN', 'LIBRA') OR
               mon_tipo ~ '^[A-Z]+$')
);

-- Tabla: PAGO
CREATE TABLE PAGO
(
    pag_id              SERIAL PRIMARY KEY ,
    pag_monto           DECIMAL(12, 2) NOT NULL ,
    pag_fecha           TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP ,
    fk_metodo_pago      INT NOT NULL ,
    fk_venta_fisica     INT NULL ,
    fk_venta_online     INT NULL ,
    fk_afiliacion       INT NULL ,
    fk_venta_evento     INT NULL ,
    fk_moneda           INT NOT NULL ,

    -- --- Restricciones de Clave Foránea ---
    CONSTRAINT fk_pago_a_venta_fisica
        FOREIGN KEY (fk_venta_fisica) REFERENCES VENTA_FISICA (ven_fis_id),
    
    CONSTRAINT fk_pago_a_venta_online
        FOREIGN KEY (fk_venta_online) REFERENCES VENTA_ONLINE (ven_onl_id),

    CONSTRAINT fk_pago_a_afiliacion
        FOREIGN KEY (fk_afiliacion) REFERENCES AFILIACION (afi_id),
        
    CONSTRAINT fk_pago_a_venta_evento
        FOREIGN KEY (fk_venta_evento) REFERENCES VENTA_EVENTO (ven_eve_id),

    CONSTRAINT fk_moneda
        FOREIGN KEY (fk_moneda) REFERENCES MONEDA (mon_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_metodo_pago
        FOREIGN KEY (fk_metodo_pago) REFERENCES METODO_PAGO (met_pag_id)
            ON DELETE CASCADE,

    CONSTRAINT chk_pago_origen_exclusivo
        CHECK (
            (fk_venta_fisica IS NOT NULL)::int +
            (fk_venta_online IS NOT NULL)::int +
            (fk_afiliacion  IS NOT NULL)::int +
            (fk_venta_evento IS NOT NULL)::int
            = 1
        )
);

CREATE TABLE HISTORICO_MONEDA
(
    his_mon_id          SERIAL PRIMARY KEY ,
    his_mon_fecha_hora  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP ,
    his_valor_cambio    DECIMAL(12, 2) NOT NULL ,
    fk_moneda           INT NOT NULL ,

    CONSTRAINT fk_moneda
        FOREIGN KEY (fk_moneda) REFERENCES MONEDA (mon_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_his_mon_fecha_hora
        CHECK (his_mon_fecha_hora <= CURRENT_TIMESTAMP AND his_mon_fecha_hora >= '1900-01-01 00:00:00'),

    CONSTRAINT ck_his_valor_cambio
        CHECK (his_valor_cambio > 0)
);

CREATE TABLE PAGO_EFECTIVO
(
    pag_efe_id SERIAL PRIMARY KEY ,
    pag_efe_monto DECIMAL(10, 2) NOT NULL ,
    pag_efe_fecha TIMESTAMP NOT NULL ,
    fk_sol_com INT NOT NULL ,
    fk_metodo_pago INT NOT NULL ,

    CONSTRAINT fk_metodo_pago
        FOREIGN KEY (fk_metodo_pago) REFERENCES METODO_PAGO (met_pag_id)
            ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- . ESTATUS
--------------------------------------------------------------------------------

CREATE TABLE ESTATUS
(
    est_id              SERIAL PRIMARY KEY ,
    est_tipo_estatus    VARCHAR(50) NOT NULL UNIQUE ,
    est_descripcion     VARCHAR(255) NOT NULL ,

    CONSTRAINT ck_est_tipo_estatus
        CHECK (est_tipo_estatus ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$'),

    CONSTRAINT ck_est_descripcion
        CHECK (est_descripcion ~ '^[-A-Za-z0-9ÁÉÍÓÚÑáéíóúñüÜ ,.%()]+$')
);

CREATE TABLE VEN_ONL_EST
(
    ven_onl_est_id              SERIAL PRIMARY KEY ,
    ven_onl_est_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE ,
    ven_onl_est_fecha_fin       DATE ,
    fk_venta_online             INT NOT NULL ,
    fk_estatus                  INT NOT NULL ,

    CONSTRAINT fk_venta_online
        FOREIGN KEY (fk_venta_online) REFERENCES VENTA_ONLINE (ven_onl_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_estatus
        FOREIGN KEY (fk_estatus) REFERENCES ESTATUS (est_id)
            ON DELETE CASCADE,
    
    CONSTRAINT ck_ven_onl_est_fecha_inicio
        CHECK (ven_onl_est_fecha_inicio <= CURRENT_DATE AND ven_onl_est_fecha_inicio >= '1900-01-01'),

    CONSTRAINT ck_ven_onl_est_fecha_fin
        CHECK (ven_onl_est_fecha_fin IS NULL OR ven_onl_est_fecha_fin >= ven_onl_est_fecha_inicio)
);

CREATE TABLE AFI_EST
(
    afi_est_id              SERIAL PRIMARY KEY,
    afi_est_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE ,
    afi_est_fecha_fin       DATE ,
    fk_afiliacion           INT NOT NULL ,
    fk_estatus              INT NOT NULL ,

    CONSTRAINT fk_afiliacion
        FOREIGN KEY (fk_afiliacion) REFERENCES AFILIACION (afi_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_estatus
        FOREIGN KEY (fk_estatus) REFERENCES ESTATUS (est_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_afi_est_fecha_inicio
        CHECK (afi_est_fecha_inicio <= CURRENT_DATE AND afi_est_fecha_inicio >= '1900-01-01'),

    CONSTRAINT ck_afi_est_fecha_fin
        CHECK (afi_est_fecha_fin IS NULL OR afi_est_fecha_fin >= afi_est_fecha_inicio)
);

CREATE TABLE SOL_REP_EST
(
    sol_rep_est_id SERIAL PRIMARY KEY ,
    sol_rep_est_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE ,
    sol_rep_est_fecha_fin DATE ,
    fk_sol_rep INT NOT NULL ,
    fk_estatus INT NOT NULL ,

    CONSTRAINT fk_sol_rep
        FOREIGN KEY (fk_sol_rep) REFERENCES SOLICITUD_REPOSICION (sol_rep_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_estatus
        FOREIGN KEY (fk_estatus) REFERENCES ESTATUS (est_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_sol_rep_est_fecha_inicio
        CHECK (sol_rep_est_fecha_inicio <= CURRENT_DATE AND sol_rep_est_fecha_inicio >= '1900-01-01')
);

CREATE TABLE SOL_COM_EST
(
    sol_com_est_id SERIAL PRIMARY KEY,
    sol_com_est_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE ,
    sol_com_est_fecha_fin DATE ,
    fk_sol_com INT NOT NULL ,
    fk_estatus INT NOT NULL ,

    CONSTRAINT fk_sol_com
        FOREIGN KEY (fk_sol_com) REFERENCES SOLICITUD_COMPRA (sol_com_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_estatus
        FOREIGN KEY (fk_estatus) REFERENCES ESTATUS (est_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_sol_com_est_fecha_inicio
        CHECK (sol_com_est_fecha_inicio <= CURRENT_DATE AND sol_com_est_fecha_inicio >= '1900-01-01')
);