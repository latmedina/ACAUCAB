--------------------------------------------------------------------------------
-- 1. LUGAR
--------------------------------------------------------------------------------

CREATE TABLE LUGAR
(
    lug_id     SERIAL PRIMARY KEY COMMENT 'Identificador único del lugar.',
    lug_nombre VARCHAR(90) NOT NULL COMMENT 'Nombre del lugar.',
    lug_tipo   VARCHAR(20) COMMENT 'Tipo de lugar.',
    fk_lugar  INT COMMENT 'Identificador del lugar padre.',
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
    tie_id              SERIAL PRIMARY KEY COMMENT 'Identificador único de la tienda.',
    tie_nombre          VARCHAR(150) NOT NULL COMMENT 'Nombre de la tienda.',
    tie_direccion       VARCHAR(255) NOT NULL COMMENT 'Dirección de la tienda.',
    tie_tipo            VARCHAR(20)  NOT NULL COMMENT 'Tipo de tienda.',
    fk_lugar            INT          NOT NULL COMMENT 'Identificador del lugar.',

    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id)
            ON DELETE CASCADE,
    
    CONSTRAINT ck_tie_nombre
        CHECK (tie_nombre ~ '^[A-Z][a-zA-Z\s]+$'),    

    CONSTRAINT ck_tie_direccion
        CHECK (tie_direccion ~ '^[A-Za-z0-9\s,.-]+$'),

    CONSTRAINT ck_tie_tipo
        CHECK (tie_tipo IN ('FISICA', 'ONLINE')) -- Restricción para asegurar que el tipo de tienda sea FISICA o ONLINE.

);

CREATE TABLE LUGAR_TIENDA
(
    lug_tie_id SERIAL PRIMARY KEY COMMENT 'Identificador único de la relación entre lugar y tienda.',
    lug_tie_nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del lugar de la tienda.',
    lug_tie_tipo VARCHAR(255) NOT NULL COMMENT 'Tipo de lugar de la tienda.',
    fk_tienda INT NOT NULL COMMENT 'Identificador de la tienda.',
    fk_lugar_tienda INT COMMENT 'Identificador del lugar de la tienda.',

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_lugar_tienda
        FOREIGN KEY (fk_lugar_tienda) REFERENCES LUGAR (lug_id)
            ON DELETE CASCADE,

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
            ON DELETE CASCADE,

);


--------------------------------------------------------------------------------
-- . CERVEZA
--------------------------------------------------------------------------------

-- Tabla: TIPO_CERVEZA
CREATE TABLE TIPO_CERVEZA 
(
    tip_cer_id      SERIAL       PRIMARY KEY COMMENT 'Identificador único del tipo de cerveza.',
    tip_cer_familia VARCHAR(255) NOT NULL COMMENT 'Familia o clasificación del tipo de cerveza.',

    CONSTRAINT ck_tip_cer_familia
        CHECK (tip_cer_familia IN ('Lager', 'Ale', 'Wheat Beer')) -- Restricción para asegurar que la familia de cerveza sea una de las opciones válidas.
);

CREATE TABLE ESTILO_CERVEZA 
(
    est_cer_id          SERIAL       PRIMARY KEY COMMENT 'Identificador único del estilo de cerveza.',
    est_cer_nombre      VARCHAR(255) NOT NULL COMMENT 'Nombre del estilo de cerveza.',
    est_cer_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción del estilo de cerveza.',

    CONSTRAINT ck_est_cer_nombre
        CHECK (est_cer_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_est_cer_descripcion
        CHECK (est_cer_descripcion ~ '^[A-Za-z0-9\s,.-]+$')
);

CREATE TABLE TIPO_ESTILO_CERVEZA
(
    tip_est_cer_id          SERIAL       PRIMARY KEY COMMENT 'Identificador único del tipo de estilo de cerveza.',
    tip_est_cer_nombre      VARCHAR(255) NOT NULL COMMENT 'Nombre del tipo de estilo de cerveza.',
    tip_est_cer_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción del tipo de estilo de cerveza.',
    fk_estilo_cerveza       INT          NOT NULL COMMENT 'Clave foránea que referencia el estilo de cerveza.',
    fk_tipo_cerveza         INT          NOT NULL COMMENT 'Clave foránea que referencia el tipo de cerveza.',

    CONSTRAINT fk_estilo_cerveza
        FOREIGN KEY (fk_estilo_cerveza) REFERENCES ESTILO_CERVEZA (est_cer_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tipo_cerveza
        FOREIGN KEY (fk_tipo_cerveza) REFERENCES TIPO_CERVEZA (tip_cer_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_tip_est_cer_nombre
        CHECK (tip_est_cer_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_tip_est_cer_descripcion
        CHECK (tip_est_cer_descripcion ~ '^[A-Za-z0-9\s,.-]+$')
);

-- Tabla: RECETA
CREATE TABLE RECETA
(
    rec_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la receta.',
    rec_nombre      VARCHAR(255) NOT NULL COMMENT 'Nombre de la receta.',
    rec_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción de la receta.',

    CONSTRAINT ck_rec_nombre
        CHECK (rec_nombre ~ '^[A-Z][a-zA-Z\s]+$'), -- Restricción para asegurar que el nombre de la receta tenga un formato válido.

    CONSTRAINT ck_rec_descripcion
        CHECK (rec_descripcion ~ '^[A-Za-z0-9\s,.-]+$') -- Restricción para asegurar que la descripción de la receta tenga un formato válido.
);

-- Tabla: CERVEZA
CREATE TABLE CERVEZA 
(
    cer_id                 SERIAL        PRIMARY KEY COMMENT 'Identificador único de la cerveza.',
    cer_nombre             VARCHAR(255)  NOT NULL COMMENT 'Nombre de la cerveza.',
    cer_descripcion        VARCHAR(255)  NOT NULL COMMENT 'Descripción de la cerveza.',
    cer_grado_alcohol      DECIMAL(5, 2) NOT NULL COMMENT 'Grado de alcohol de la cerveza.',
    fk_tipo_estilo_cerveza INT           NOT NULL COMMENT 'Clave foránea que referencia el tipo de cerveza.',
    
    CONSTRAINT fk_tipo_estilo_cerveza
        FOREIGN KEY (fk_tipo_estilo_cerveza) REFERENCES TIPO_ESTILO_CERVEZA (tip_est_cer_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_cer_nombre
        CHECK (cer_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_cer_descripcion
        CHECK (cer_descripcion ~ '^[A-Za-z0-9\s,.-]+$'),  

    CONSTRAINT ck_cer_grado_alcohol
        CHECK (cer_grado_alcohol >= 0.0 AND cer_grado_alcohol <= 100.0) -- Restricción para asegurar que el grado de alcohol esté entre 0 y 100.
);

-- Tabla: PRESENTACION
CREATE TABLE PRESENTACION 
(
    prese_id         SERIAL         PRIMARY KEY COMMENT 'Identificador único de la presentación.',
    prese_volumen    DECIMAL(10, 2) NOT NULL COMMENT 'Volumen de la presentación.',
    prese_recipiente VARCHAR(255)   NOT NULL COMMENT 'Tipo de recipiente de la presentación.',
    fk_cerveza       INT COMMENT 'Clave foránea que referencia la cerveza asociada a la presentación.',
    prese_imagen     VARCHAR(255)   NOT NULL COMMENT 'Imagen de la presentación del producto.',
    prese_alto       DECIMAL(10, 2) COMMENT 'Alto del recipiente de la presentación.',
    prese_ancho      DECIMAL(10, 2) COMMENT 'Ancho del recipiente de la presentación.',

    CONSTRAINT fk_cerveza
        FOREIGN KEY (fk_cerveza) REFERENCES CERVEZA (cer_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_prese_volumen
        CHECK (prese_volumen > 0), -- Restricción para asegurar que el volumen sea mayor a 0.

    CONSTRAINT ck_prese_recipiente
        CHECK (prese_recipiente ~ '^[A-Z][a-zA-Z\s]+$'), -- Restricción para asegurar que el recipiente tenga un formato válido.

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
    ing_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del ingrediente.',
    ing_nombre      VARCHAR(255) NOT NULL COMMENT 'Nombre del ingrediente.',
    ing_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción del ingrediente.',

    CONSTRAINT ck_ing_nombre
        CHECK (ing_nombre ~ '^[A-Z][a-zA-Z\s]+$'), -- Restricción para asegurar que el nombre del ingrediente tenga un formato válido.
    CONSTRAINT ck_ing_descripcion
        CHECK (ing_descripcion ~ '^[A-Za-z0-9\s,.-]+$') -- Restricción para asegurar que la descripción del ingrediente tenga un formato válido.
);

-- Tabla: REC_ING
CREATE TABLE REC_ING 
(
    rec_ing_id       SERIAL NOT NULL COMMENT 'Identificador único.',
    fk_receta        INT NOT NULL COMMENT 'Clave foránea que referencia a la receta.',
    fk_ingrediente   INT NOT NULL COMMENT 'Clave foránea que referencia al ingrediente.',
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
    ins_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la instrucción.',
    ins_descripcion VARCHAR(1000) NOT NULL COMMENT 'Descripción detallada de la instrucción.',

    CONSTRAINT ck_ins_descripcion
        CHECK (ins_descripcion ~ '^[A-Za-z0-9\s,.-]+$') -- Restricción para asegurar que la descripción tenga un formato válido.
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
    car_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la característica.',
    car_nombre      VARCHAR(255) NOT NULL COMMENT 'Nombre de la característica.',
    car_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción de la característica.',

    CONSTRAINT ck_car_nombre
        CHECK (car_nombre ~ '^[A-Z][a-zA-Z\s]+$'), -- Restricción para asegurar que el nombre tenga un formato válido.

    CONSTRAINT ck_car_descripcion
        CHECK (car_descripcion ~ '^[A-Za-z0-9\s,.-]+$') -- Restricción para asegurar que la descripción tenga un formato válido.
);

CREATE TABLE CERV_CAR
(
    fk_cerveza        INT NOT NULL COMMENT 'Clave foránea que referencia a la cerveza.',
    fk_caracteristica INT NOT NULL COMMENT 'Clave foránea que referencia a la característica.',
    carac_cer_valor   VARCHAR(255) NOT NULL COMMENT 'Valor de la característica asociada a la cerveza.',
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
    fk_caracteristica INT NOT NULL COMMENT 'Clave foránea que referencia a la característica.',
    fk_tipo_cerveza  INT NOT NULL COMMENT 'Clave foránea que referencia al tipo de cerveza.',
    carac_tip_cer_valor   VARCHAR(255) NOT NULL COMMENT 'Valor de la característica asociada al tipo de cerveza.',
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
    cli_id                  SERIAL PRIMARY KEY COMMENT 'Identificador único del cliente.',
    cli_rif                 VARCHAR(12)  NOT NULL UNIQUE COMMENT 'RIF del cliente.',
    cli_direccion_fisica    VARCHAR(255) NOT NULL COMMENT 'Dirección física del cliente.',
    cli_tipo_cliente        VARCHAR(10)  NOT NULL COMMENT 'Tipo de cliente.',
    cli_nat_ci              VARCHAR(12)  UNIQUE COMMENT 'Cédula de identidad del cliente.',
    cli_nat_pnombre         VARCHAR(50) COMMENT 'Primer nombre del cliente.',
    cli_nat_snombre         VARCHAR(50) COMMENT 'Segundo nombre del cliente.',
    cli_nat_papellido       VARCHAR(50) COMMENT 'Primer apellido del cliente.',
    cli_nat_sapellido       VARCHAR(50) COMMENT 'Segundo apellido del cliente.',
    cli_nat_sexo            CHAR(1) COMMENT 'Sexo del cliente.',
    cli_jur_denom_comercial VARCHAR(70) COMMENT 'Denominación comercial del cliente.',
    cli_jur_razon_social    VARCHAR(70) COMMENT 'Razón social del cliente.',
    cli_jur_url_web         VARCHAR(255) COMMENT 'URL web del cliente.',
    cli_jur_capital         INT COMMENT 'Capital del cliente.',
    cli_jur_dir_fiscal      VARCHAR(255) COMMENT 'Dirección fiscal del cliente.',
    fk_lugar                INT          NOT NULL COMMENT 'Identificador del lugar.',
    cli_cantidad_puntos     INT          DEFAULT 0 COMMENT 'Cantidad de puntos del cliente.',

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
        CHECK (cli_nat_ci ~ '^[VEJP]{1}[0-9]{7,10}$'),

        CONSTRAINT ck_cli_rif
        CHECK (cli_rif ~ '^[J]{1}[0-9]{9}$'),

    CONSTRAINT ck_cli_nat_pnombre
        CHECK (cli_nat_pnombre IS NULL OR cli_nat_pnombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_cli_nat_snombre
        CHECK (cli_nat_snombre IS NULL OR cli_nat_snombre ~ '^[A-Z][a-zA-Z\s]+$'),
        
    CONSTRAINT ck_cli_nat_papellido
        CHECK (cli_nat_papellido IS NULL OR cli_nat_papellido ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_cli_nat_sapellido 
        CHECK (cli_nat_sapellido IS NULL OR cli_nat_sapellido ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_cli_jur_denom_comercial
        CHECK (cli_jur_denom_comercial IS NULL OR cli_jur_denom_comercial ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_cli_jur_razon_social
        CHECK (cli_jur_razon_social IS NULL OR cli_jur_razon_social ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_cli_jur_url_web
        CHECK (cli_jur_url_web IS NULL OR cli_jur_url_web ~ '^(https?://)?([a-zA-Z0-9.-]+)(:[0-9]+)?(/.*)?$'),

    CONSTRAINT ck_cli_jur_dir_fiscal
        CHECK (cli_jur_dir_fiscal IS NULL OR cli_jur_dir_fiscal ~ '^[A-Za-z0-9\s,.-]+$')    
);

CREATE TABLE CONTACTO_CLIENTE
(
    con_cli_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del contacto del cliente.',
    con_cli_nombre     VARCHAR(50) NOT NULL COMMENT 'Nombre del contacto del cliente.',
    con_cli_apellido   VARCHAR(50) NOT NULL COMMENT 'Apellido del contacto del cliente.',
    fk_cliente          INT NOT NULL COMMENT 'Identificador del cliente.',

    CONSTRAINT fk_contacto_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_con_cli_nombre
        CHECK (con_cli_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_con_cli_apellido
        CHECK (con_cli_apellido ~ '^[A-Z][a-zA-Z\s]+$')
);

--------------------------------------------------------------------------------
-- . PROVEEDOR
--------------------------------------------------------------------------------

CREATE TABLE PROVEEDOR
(
    pro_id                      SERIAL PRIMARY KEY COMMENT 'Identificador único del proveedor.',
    pro_rif                     VARCHAR(12)  NOT NULL UNIQUE COMMENT 'RIF del proveedor.',
    pro_denominacion_comercial  VARCHAR(70) COMMENT 'Denominación comercial del proveedor.',
    pro_razon_social            VARCHAR(70) COMMENT 'Razón social del proveedor.',
    pro_url_web                 VARCHAR(255) COMMENT 'URL web del proveedor.',
    pro_direccion_fiscal        VARCHAR(255) COMMENT 'Dirección fiscal del proveedor.',
    fk_lugar                    INT          NOT NULL COMMENT 'Identificador del lugar.',
    
    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id),

    CONSTRAINT ck_pro_rif
        CHECK (pro_rif ~ '^[J]{1}[0-9]{9}$'),

    CONSTRAINT ck_pro_denominacion_comercial
        CHECK (pro_denominacion_comercial ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_pro_razon_social
        CHECK (pro_razon_social ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_pro_url_web
        CHECK (pro_url_web ~ '^(https?://)?([a-zA-Z0-9.-]+)(:[0-9]+)?(/.*)?$'),

    CONSTRAINT ck_pro_direccion_fiscal
        CHECK (pro_direccion_fiscal ~ '^[A-Za-z0-9\s,.-]+$')  
);

CREATE TABLE CONTACTO_PROVEEDOR
(
    con_pro_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del contacto del proveedor.',
    con_pro_nombre     VARCHAR(50) NOT NULL COMMENT 'Nombre del contacto del proveedor.',
    con_pro_apellido   VARCHAR(50) NOT NULL COMMENT 'Apellido del contacto del proveedor.',
    fk_proveedor       INT NOT NULL COMMENT 'Identificador del proveedor.',

    CONSTRAINT fk_contacto_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_con_pro_nombre
        CHECK (con_pro_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_con_pro_apellido
        CHECK (con_pro_apellido ~ '^[A-Z][a-zA-Z\s]+$')
);

CREATE TABLE AFILIACION
(
    afi_id         SERIAL PRIMARY KEY COMMENT 'Identificador único de la afiliación.',
    afi_nombre     VARCHAR(50) NOT NULL COMMENT 'Nombre de la afiliación.',
    afi_monto      INT NOT NULL COMMENT 'Monto de la afiliación.',
    fk_proveedor   INT NOT NULL COMMENT 'Identificador del proveedor.',
    fk_tienda      INT NOT NULL COMMENT 'Identificador de la tienda.',

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
    emp_id                 SERIAL        PRIMARY KEY COMMENT 'Identificador único del empleado.',
    emp_ci                 VARCHAR(12)   NOT NULL UNIQUE COMMENT 'Cédula de identidad del empleado.',
    emp_pnombre            VARCHAR(30)   NOT NULL COMMENT 'Primer nombre del empleado.',
    emp_snombre            VARCHAR(30)   COMMENT 'Segundo nombre del empleado.',
    emp_papellido          VARCHAR(30)   NOT NULL COMMENT 'Primer apellido del empleado.',
    emp_sapellido          VARCHAR(30)   COMMENT 'Segundo apellido del empleado.',
    emp_direccion          VARCHAR(70)   NOT NULL COMMENT 'Dirección del empleado.',
    emp_fecha_nacimiento   DATE          NOT NULL COMMENT 'Fecha de nacimiento del empleado.',
    emp_sexo               CHAR(1)       NOT NULL COMMENT 'Sexo del empleado.',
    fk_lugar               INT           NOT NULL COMMENT 'Identificador del lugar.',
    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id),

	CONSTRAINT ck_emp_ci
        CHECK (emp_ci ~ '^[VEJP]{1}[0-9]{7,10}$'),

    CONSTRAINT ck_emp_sexo
        CHECK (emp_sexo IN ('M', 'F')),

    CONSTRAINT ck_emp_fecha_nacimiento
        CHECK (emp_fecha_nacimiento <= CURRENT_DATE AND emp_fecha_nacimiento >= '1900-01-01'),

    CONSTRAINT ck_emp_pnombre
        CHECK (emp_pnombre ~ '^[A-Z][a-zA-Z\s]+$' AND emp_papellido ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_emp_papellido
        CHECK (emp_papellido ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_emp_snombre
        CHECK (emp_snombre IS NULL OR emp_snombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_emp_sapellido
        CHECK (emp_sapellido IS NULL OR emp_sapellido ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_emp_direccion
        CHECK (emp_direccion ~ '^[A-Za-z0-9\s,.-]+$')
);

CREATE TABLE CARGO
(
    car_id              SERIAL PRIMARY KEY COMMENT 'Identificador único del cargo.',
    car_nombre          VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nombre del cargo.',
    car_descripcion     TEXT NOT NULL COMMENT 'Descripción del cargo.',
    car_salario         INT NOT NULL COMMENT 'Salario del cargo.',

    CONSTRAINT ck_car_nombre
        CHECK (car_nombre ~ '^[A-Z][a-zA-Z0-9\s]+$'),

    CONSTRAINT ck_car_salario
        CHECK (car_salario > 0) 
);

CREATE TABLE DEPARTAMENTO
(
    dep_id              SERIAL PRIMARY KEY COMMENT 'Identificador único del departamento.',
    dep_nombre          VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nombre del departamento.',
    dep_descripcion     TEXT NOT NULL COMMENT 'Descripción del departamento.',

    CONSTRAINT ck_dep_nombre
        CHECK (dep_nombre ~ '^[A-Z][a-zA-Z0-9\s]+$')
);

CREATE TABLE DEP_TIE 
(
    fk_departamento INT NOT NULL COMMENT 'Identificador del departamento.',
    fk_tienda       INT NOT NULL COMMENT 'Identificador de la tienda.',
    dep_tie_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio de la relación entre departamento y tienda.',
    dep_tie_fecha_fin    DATE COMMENT 'Fecha de fin de la relación entre departamento y tienda.',

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
    fk_empleado          INT NOT NULL COMMENT 'Identificador del empleado.',
    fk_cargo             INT NOT NULL COMMENT 'Identificador del cargo.',
    fk_departamento      INT NOT NULL COMMENT 'Identificador del departamento.',
    fk_tienda            INT NOT NULL COMMENT 'Identificador de la tienda.',
    emp_car_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio de la relación entre empleado y cargo.',
    emp_car_fecha_fin    DATE COMMENT 'Fecha de fin de la relación entre empleado y cargo.',

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
    asi_id               SERIAL PRIMARY KEY COMMENT 'Identificador único de la asistencia.',
    asi_fecha_hora_inico TIMESTAMP NOT NULL COMMENT 'Fecha y hora de inicio de la asistencia.',
    asi_fecha_hora_fin   TIMESTAMP COMMENT 'Fecha y hora de fin de la asistencia.',
    fk_empleado          INT NOT NULL COMMENT 'Identificador del empleado.',

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
    hor_id              SERIAL PRIMARY KEY COMMENT 'Identificador único del horario.',
    hor_dia            VARCHAR(10) NOT NULL COMMENT 'Día de la semana.',
    hor_hora_inicio     TIME NOT NULL COMMENT 'Hora de inicio del horario.',
    hor_hora_fin        TIME NOT NULL COMMENT 'Hora de fin del horario.',

    CONSTRAINT ck_hor_dia
        CHECK (hor_dia IN ('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo')),

    CONSTRAINT ck_hor_hora_inicio
        CHECK (hor_hora_inicio >= '00:00:00' AND hor_hora_inicio <= '23:59:59'),

    CONSTRAINT ck_hor_hora_fin
        CHECK (hor_hora_fin >= '00:00:00' AND hor_hora_fin <= '23:59:59' AND hor_hora_fin > hor_hora_inicio)
);

CREATE TABLE EMP_CAR_HOR 
(
    fk_empleado          INT NOT NULL COMMENT 'Identificador del empleado.',
    fk_cargo             INT NOT NULL COMMENT 'Identificador del cargo.',
    fk_departamento      INT NOT NULL COMMENT 'Identificador del departamento.',
    fk_tienda            INT NOT NULL COMMENT 'Identificador de la tienda.',
    fk_horario           INT NOT NULL COMMENT 'Identificador del horario.',

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
    vac_id              SERIAL PRIMARY KEY COMMENT 'Identificador único de la vacación.',
    vac_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio de la vacación.',
    vac_fecha_fin       DATE COMMENT 'Fecha de fin de la vacación.',
    fk_empleado         INT NOT NULL COMMENT 'Identificador del empleado.',

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
    tip_ben_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del tipo de beneficio.',
    tip_ben_nombre      VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nombre del tipo de beneficio.',
    tip_ben_descripcion TEXT NOT NULL COMMENT 'Descripción del tipo de beneficio.',

    CONSTRAINT ck_tip_ben_nombre
        CHECK (tip_ben_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_tip_ben_descripcion
        CHECK (tip_ben_descripcion ~ '^[A-Za-z0-9\s,.-]+$')
);

CREATE TABLE EMP_TIP_BEN
(
    fk_empleado         INT NOT NULL COMMENT 'Identificador del empleado.',
    fk_tipo_beneficio   INT NOT NULL COMMENT 'Identificador del tipo de beneficio.',
    emp_tip_ben_monto   INT NOT NULL COMMENT 'Monto del beneficio.',

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
    tel_id                  SERIAL PRIMARY KEY COMMENT 'Identificador único del teléfono.',
    tel_codigo_area         VARCHAR(30) NOT NULL COMMENT 'Código de área del teléfono.',
    tel_numero              INT NOT NULL COMMENT 'Número del teléfono.',
    fk_empleado             INT COMMENT 'Identificador del empleado.',
    fk_cliente              INT COMMENT 'Identificador del cliente.',
    fk_contacto_cliente     INT COMMENT 'Identificador del contacto del cliente.',
    fk_contacto_proveedor   INT COMMENT 'Identificador del contacto del proveedor.',
    fk_proveedor            INT COMMENT 'Identificador del proveedor.',
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
        CHECK (tel_numero >= 1000000 AND tel_numero <= 9999999),

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
    cor_ele_id         SERIAL PRIMARY KEY COMMENT 'Identificador único del correo electrónico.',
    cor_ele_direccion  VARCHAR(70) NOT NULL COMMENT 'Dirección de correo electrónico.',
    fk_empleado             INT COMMENT 'Identificador del empleado.',
    fk_cliente              INT COMMENT 'Identificador del cliente.',
    fk_contacto_cliente     INT COMMENT 'Identificador del contacto del cliente.',
    fk_contacto_proveedor   INT COMMENT 'Identificador del contacto del proveedor.',
    fk_proveedor            INT COMMENT 'Identificador del proveedor.',
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
    rol_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del rol.',
    rol_nombre      VARCHAR(30) NOT NULL COMMENT 'Nombre del rol.',
    rol_descripcion VARCHAR(255) COMMENT 'Descripción del rol.',

    CONSTRAINT ck_rol_nombre
        CHECK (UPPER(rol_nombre) in ('EMPLEADO', 'CLIENTE', 'PROVEEDOR', 'ADMINISTRADOR') OR
               UPPER(rol_nombre) ~ '^[A-Z]+$')
);

--  Privilegio
CREATE TABLE PRIVILEGIO
(
    pri_id     SERIAL PRIMARY KEY COMMENT 'Identificador único del privilegio.',
    pri_accion VARCHAR(30) NOT NULL COMMENT 'Acción del privilegio.',
    pri_vista  VARCHAR(30) NOT NULL COMMENT 'Vista del privilegio.',
    CONSTRAINT ck_pri_accion
        CHECK (UPPER(pri_accion) in ('CREATE', 'DELETE', 'UPDATE', 'READ'))
);

--  Privilegio Rol (relación)
CREATE TABLE PRI_ROL
(
    fk_rol INT NOT NULL COMMENT 'Identificador del rol.',
    fk_privilegio INT NOT NULL COMMENT 'Identificador del privilegio.',
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
    usu_id             SERIAL PRIMARY KEY COMMENT 'Identificador único del usuario.',
    usu_nombre_usuario VARCHAR(30) NOT NULL COMMENT 'Nombre de usuario.',
    usu_contrasena     VARCHAR(30) NOT NULL COMMENT 'Contraseña del usuario.',
    usu_email          VARCHAR(60) NOT NULL COMMENT 'Correo electrónico del usuario.',
    fk_rol             INT         NOT NULL COMMENT 'Identificador del rol.',
    fk_empleado        INT COMMENT 'Identificador del empleado.',
    fk_cargo           INT COMMENT 'Identificador del cargo.',
    fk_departamernto   INT COMMENT 'Identificador del departamento.',
    fk_tienda          INT COMMENT 'Identificador de la tienda.',
    fk_cliente         INT COMMENT 'Identificador del cliente.',
    fk_proveedor       INT COMMENT 'Identificador del proveedor.',

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
    ofe_id              SERIAL PRIMARY KEY COMMENT 'Identificador único de la oferta.',
    ofe_nombre          VARCHAR(100) NOT NULL COMMENT 'Nombre de la oferta.',
    ofe_descripcion     TEXT NOT NULL COMMENT 'Descripción de la oferta.',
    ofe_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio de la oferta.',
    ofe_fecha_fin       DATE COMMENT 'Fecha de fin de la oferta.',
    of_procentaje       INT NOT NULL COMMENT 'Porcentaje de descuento de la oferta.',
    
    CONSTRAINT ck_ofe_fecha_inicio
        CHECK (ofe_fecha_inicio <= CURRENT_DATE AND ofe_fecha_inicio >= '1900-01-01'),

    CONSTRAINT ck_ofe_fecha_fin
        CHECK (ofe_fecha_fin IS NULL OR ofe_fecha_fin >= ofe_fecha_inicio)
);

CREATE TABLE INVENTARIO
(
    inv_id SERIAL PRIMARY KEY COMMENT 'Identificador único del inventario.',
    inv_cantidad INT NOT NULL COMMENT 'Cantidad de inventario.',
    fk_anaquel INT NOT NULL COMMENT 'Identificador del anaquel.',
    fk_presentacion INT NOT NULL COMMENT 'Identificador de la presentación.',
    fk_oferta INT COMMENT 'Identificador de la oferta.',

    PRIMARY KEY (inv_id, fk_anaquel, fk_presentacion),

    CONSTRAINT fk_anaquel
        FOREIGN KEY (fk_anaquel) REFERENCES ANAQUEL (ana_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (pre_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_oferta
        FOREIGN KEY (fk_oferta) REFERENCES OFERTA (ofe_id)
            ON DELETE CASCADE,

);

CREATE TABLE ALMACEN
(
    alm_id              SERIAL PRIMARY KEY COMMENT 'Identificador único del almacén.',
    alm_nombre          VARCHAR(100) NOT NULL COMMENT 'Nombre del almacén.',
    alm_descripcion     TEXT NOT NULL COMMENT 'Descripción del almacén.',
    fk_tienda           INT NOT NULL COMMENT 'Identificador de la tienda.',

    CONSTRAINT fk_tienda
        FOREIGN KEY (fk_tienda) REFERENCES TIENDA (tie_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_alm_nombre
        CHECK (alm_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_alm_descripcion
        CHECK (alm_descripcion ~ '^[A-Za-z0-9\s,.-]+$')
);

CREATE TABLE PRE_ALM
(
    pre_alm_id SERIAL PRIMARY KEY COMMENT 'Identificador único de la presentación en el almacén.',
    pre_alm_precio DECIMAL(10, 2) NOT NULL COMMENT 'Precio de la presentación en el almacén.',
    pre_alm_cantidad INT NOT NULL COMMENT 'Cantidad de la presentación en el almacén.',
    fk_almacen INT NOT NULL COMMENT 'Identificador del almacén.',
    fk_presentacion INT NOT NULL COMMENT 'Identificador de la presentación.',
    fk_oferta INT COMMENT 'Identificador de la oferta.',
    PRIMARY KEY (pre_alm_id, fk_almacen, fk_presentacion)

    CONSTRAINT fk_almacen
        FOREIGN KEY (fk_almacen) REFERENCES ALMACEN (alm_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (pre_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_oferta
        FOREIGN KEY (fk_oferta) REFERENCES OFERTA (ofe_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_pre_alm_precio
        CHECK (pre_alm_precio > 0), -- Restricción para asegurar que el precio sea mayor a 0.
);  
-- Venta Física
CREATE TABLE VENTA_FISICA
(
    ven_fis_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la venta física.',
    ven_fis_fecha       DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de la venta física.',
    ven_fis_total       INT NOT NULL COMMENT 'Total de la venta física.',
    fk_tienda           INT NOT NULL COMMENT 'Identificador de la tienda.',
    fk_cliente          INT NOT NULL COMMENT 'Identificador del cliente.',
    fk_oferta           INT COMMENT 'Identificador de la oferta.',

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
    det_ven_fis_id SERIAL PRIMARY KEY COMMENT 'Identificador único del detalle de la venta física.',
    det_ven_fis_cantidad INT NOT NULL COMMENT 'Cantidad de la venta física.',
    det_ven_fis_precio_unitario DECIMAL(10, 2) NOT NULL COMMENT 'Precio unitario de la venta física.',
    fk_venta_fisica INT NOT NULL COMMENT 'Identificador de la venta física.',
    fk_inventario INT NOT NULL COMMENT 'Identificador de la presentación.',

    PRIMARY KEY (det_ven_fis_id, fk_venta_fisica, fk_inventario),
    
    CONSTRAINT fk_venta_fisica
        FOREIGN KEY (fk_venta_fisica) REFERENCES VENTA_FISICA (ven_fis_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_inventario
        FOREIGN KEY (fk_inventario) REFERENCES INVENTARIO (inv_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_det_ven_fis_cantidad
        CHECK (det_ven_fis_cantidad > 0), -- Restricción para asegurar que la cantidad sea mayor a 0.
);

-- Venta Online
CREATE TABLE VENTA_ONLINE
(
    ven_onl_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la venta online.',
    ven_onl_fecha       DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de la venta online.',
    ven_onl_total       INT NOT NULL COMMENT 'Total de la venta online.',
    fk_usuario          INT NOT NULL COMMENT 'Identificador del usuario.',
    fk_oferta           INT COMMENT 'Identificador de la oferta.',
    fk_tienda           INT NOT NULL COMMENT 'Identificador de la tienda.',

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
    det_ven_onl_cantidad INT NOT NULL COMMENT 'Cantidad de la venta online.',
    det_ven_onl_precio DECIMAL(10, 2) NOT NULL COMMENT 'Precio de la venta online.',
    fk_venta_online INT NOT NULL COMMENT 'Identificador de la venta online.',
    fk_pre_alm INT NOT NULL COMMENT 'Identificador de la presentación en el almacén.',

    PRIMARY KEY (fk_venta_online, fk_pre_alm),

    CONSTRAINT fk_venta_online
        FOREIGN KEY (fk_venta_online) REFERENCES VENTA_ONLINE (ven_onl_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_pre_alm
        FOREIGN KEY (fk_pre_alm) REFERENCES PRE_ALM (pre_alm_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_det_ven_onl_cantidad
        CHECK (det_ven_onl_cantidad > 0),
);

--------------------------------------------------------------------------------
-- . EVENTO
--------------------------------------------------------------------------------

-- TIPO_EVENTO
CREATE TABLE TIPO_EVENTO 
(
    tip_eve_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del tipo de evento.',
    tip_eve_nombre      VARCHAR(255) NOT NULL COMMENT 'Nombre del tipo de evento.',
    tip_eve_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción del tipo de evento.',
    fk_tipo_evento      INT COMMENT 'Identificador del tipo de evento padre (para jerarquías).',

    CONSTRAINT fk_tipo_evento
        FOREIGN KEY (fk_tipo_evento) REFERENCES TIPO_EVENTO (tip_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_tip_eve_nombre
        CHECK (tip_eve_nombre ~ '^[A-Z][a-zA-Z\s]+$'),
    
    CONSTRAINT ck_tip_eve_descripcion
        CHECK (tip_eve_descripcion ~ '^[A-Za-z0-9\s,.-]+$')
);

-- Índice para optimizar consultas en fk_lug_id (relación jerárquica)
CREATE INDEX idx_tipo_evento_padre
    ON TIPO_EVENTO (fk_tipo_evento);


-- Tabla: EVENTO
CREATE TABLE EVENTO 
(
    eve_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del evento.',
    eve_nombre      VARCHAR(255) NOT NULL COMMENT 'Nombre del evento.',
    eve_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción detallada del evento.',
    eve_fecha_hora  TIMESTAMP NOT NULL COMMENT 'Fecha y hora en que el evento tendrá lugar.',
    eve_nro_boletos INT NOT NULL COMMENT 'Número total de boletos disponibles para el evento.',
    fk_tip_eve      INT NOT NULL COMMENT 'Identificador del tipo de evento.',
    fk_lugar       INT NOT NULL COMMENT 'Identificador del lugar donde se llevará a cabo el evento.',

    CONSTRAINT fk_lugar
        FOREIGN KEY (fk_lugar) REFERENCES LUGAR (lug_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_tipo_evento
        FOREIGN KEY (fk_tip_eve) REFERENCES TIPO_EVENTO (tip_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_eve_nombre
        CHECK (eve_nombre ~ '^[A-Z][a-zA-Z\s]+$'),

    CONSTRAINT ck_eve_descripcion
        CHECK (eve_descripcion ~ '^[A-Za-z0-9\s,.-]+$'),  

    CONSTRAINT ck_eve_fecha_hora
        CHECK (eve_fecha_hora >= CURRENT_DATE AND eve_fecha_hora <= '2100-12-31 23:59:59'),

    CONSTRAINT ck_eve_nro_boletos
        CHECK (eve_nro_boletos > 0)
);

-- Tabla: VENTA_EVENTO
CREATE TABLE VENTA_EVENTO
(
    ven_eve_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la venta del evento.',
    ven_eve_fecha_hora  TIMESTAMP NOT NULL COMMENT 'Fecha y hora en que se realizó la venta del evento.',
    ven_eve_monto_total DECIMAL(18, 2) NOT NULL COMMENT 'Monto total de la venta del evento.',
    ven_eve_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción de la venta del evento.',
    fk_evento           INT NOT NULL COMMENT 'Identificador del evento asociado a la venta.',
    fk_cliente          INT NOT NULL COMMENT 'Identificador del cliente que realizó la compra.',

    CONSTRAINT fk_evento
        FOREIGN KEY (fk_evento) REFERENCES EVENTO (eve_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_ven_eve_fecha_hora
        CHECK (ven_eve_fecha_hora >= CURRENT_DATE AND ven_eve_fecha_hora <= '2100-12-31 23:59:59'),

    CONSTRAINT ck_ven_eve_monto_total
        CHECK (ven_eve_monto_total > 0),

    CONSTRAINT ck_ven_eve_descripcion
        CHECK (ven_eve_descripcion ~ '^[A-Za-z0-9\s,.-]+$')
);

CREATE TABLE EXISTENCIA_EVENTO
(
    exi_eve_id SERIAL PRIMARY KEY COMMENT 'Identificador único de la existencia del evento.',
    exi_eve_cantidad INT NOT NULL COMMENT 'Cantidad de la existencia del evento.',
    fk_eve_pro INT NOT NULL COMMENT 'Identificador del evento asociado a la existencia.',
    fk_presentacion INT NOT NULL COMMENT 'Identificador de la presentación.',

    PRIMARY KEY (exi_eve_id, fk_eve_pro, fk_presentacion),

    CONSTRAINT fk_eve_pro
        FOREIGN KEY (fk_eve_pro) REFERENCES EVE_PRO (eve_pro_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (pre_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_exi_eve_cantidad
        CHECK (exi_eve_cantidad > 0)
);

CREATE TABLE DETALLE_VENTA_EVENTO
(
    det_ven_eve_id SERIAL PRIMARY KEY COMMENT 'Identificador único del detalle de la venta del evento.',
    det_ven_eve_cantidad INT NOT NULL COMMENT 'Cantidad de la venta del evento.',
    det_ven_eve_precio_unitario DECIMAL(10, 2) NOT NULL COMMENT 'Precio unitario de la venta del evento.',
    fk_venta_evento INT NOT NULL COMMENT 'Identificador de la venta del evento.',
    fk_exi_eve INT NOT NULL COMMENT 'Identificador de la existencia del evento.',

    PRIMARY KEY (det_ven_eve_id, fk_venta_evento, fk_exi_eve),

    CONSTRAINT fk_venta_evento
        FOREIGN KEY (fk_venta_evento) REFERENCES VENTA_EVENTO (ven_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_exi_eve
        FOREIGN KEY (fk_exi_eve) REFERENCES EXISTENCIA_EVENTO (exi_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_det_ven_eve_cantidad
        CHECK (det_ven_eve_cantidad > 0), -- Restricción para asegurar que la cantidad sea mayor a 0.


);

-- Tabla: VENTA_BOLETO_EVENTO
CREATE TABLE VENTA_BOLETO_EVENTO 
(
    ven_bol_eve_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la venta del boleto del evento.',
    ven_bol_eve_fecha_hora  TIMESTAMP NOT NULL COMMENT 'Fecha y hora en que se realizó la venta del boleto del evento.',
    ven_bol_eve_monto_total DECIMAL(18, 2) NOT NULL COMMENT 'Monto total de la venta del boleto del evento.',
    ven_bol_eve_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción de la venta del boleto del evento.',

    CONSTRAINT ck_ven_bol_eve_fecha_hora
        CHECK (ven_bol_eve_fecha_hora >= CURRENT_DATE AND ven_bol_eve_fecha_hora <= '2100-12-31 23:59:59'),

    CONSTRAINT ck_ven_bol_eve_descripcion
        CHECK (ven_bol_eve_descripcion ~ '^[A-Za-z0-9\s,.-]+$') 
);

-- Tabla: ASISTENCIA_EVENTO
CREATE TABLE ASISTENCIA_EVENTO 
(
    asi_eve_id          SERIAL NOT NULL COMMENT 'Identificador único de la asistencia al evento.',
    fk_evento           INT NOT NULL COMMENT 'Identificador del evento al que se asistió.',
    fk_cliente          INT NOT NULL COMMENT 'Identificador del cliente que asistió al evento.',
    asi_eve_fecha_hora  TIMESTAMP NOT NULL COMMENT 'Fecha y hora en que el cliente asistió al evento.',
    fk_ven_bol_eve      INT NOT NULL COMMENT 'Identificador de la venta del boleto del evento.',

    PRIMARY KEY (asi_eve_id, fk_evento, fk_cliente, fk_ven_bol_eve), -- Clave primaria compuesta por el ID de asistencia, evento y cliente.

    CONSTRAINT fk_evento
        FOREIGN KEY (fk_evento) REFERENCES EVENTO (eve_id)
            ON DELETE CASCADE,
            
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_ven_bol_eve
        FOREIGN KEY (fk_ven_bol_eve) REFERENCES VENTA_BOLETO_EVENTO (ven_bol_eve_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_asi_eve_fecha_hora
        CHECK (asi_eve_fecha_hora >= CURRENT_DATE AND asi_eve_fecha_hora <= '2100-12-31 23:59:59') 
);

-- Tabla: EVE_PRO
CREATE TABLE EVE_PRO 
(
    eve_pro_id      SERIAL COMMENT 'Identificador único de EVE_PRO.',
    fk_evento       INT NOT NULL COMMENT 'Identificador del evento asociado a EVE_PRO.',
    fk_proveedor    INT NOT NULL COMMENT 'Identificador del proveedor asociado a EVE_PRO.',
    
    PRIMARY KEY (eve_pro_id, fk_evento, fk_proveedor), -- Clave primaria compuesta por eve_pro_id, fk_evento y fk_proveedor.

    CONSTRAINT fk_evento
        FOREIGN KEY (fk_evento) REFERENCES EVENTO (eve_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- . solicitudes
--------------------------------------------------------------------------------

CREATE TABLE SOLICITUD_REPOSICION
(
    sol_rep_id SERIAL PRIMARY KEY COMMENT 'Identificador único de la solicitud de reposición.',
    sol_rep_fecha_hora TIMESTAMP NOT NULL COMMENT 'Fecha y hora de la solicitud de reposición.',
    sol_rep_descripcion VARCHAR(255) NOT NULL COMMENT 'Descripción de la solicitud de reposición.',
    fk_usuario INT NOT NULL COMMENT 'Identificador del usuario que realizó la solicitud de reposición.',
    fk_inv INT NOT NULL COMMENT 'Identificador del inventario.',
    fk_pre_alm INT NOT NULL COMMENT 'Identificador de la presentación en el almacén.',

    CONSTRAINT fk_usuario
        FOREIGN KEY (fk_usuario) REFERENCES USUARIO (usu_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_inv
        FOREIGN KEY (fk_inv) REFERENCES INVENTARIO (inv_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_pre_alm
        FOREIGN KEY (fk_pre_alm) REFERENCES PRE_ALM (pre_alm_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_sol_rep_fecha_hora
        CHECK (sol_rep_fecha_hora >= CURRENT_DATE AND sol_rep_fecha_hora <= '2100-12-31 23:59:59')
);

CREATE TABLE SOLICITUD_COMPRA
(
    sol_com_id SERIAL PRIMARY KEY COMMENT 'Identificador único de la solicitud de compra.',
    sol_com_fecha TIMESTAMP NOT NULL COMMENT 'Fecha de la solicitud de compra.',
    sol_com_total DECIMAL(10, 2) NOT NULL COMMENT 'Total de la solicitud de compra.',
    fk_usuario INT NOT NULL COMMENT 'Identificador del usuario que realizó la solicitud de compra.',
    fk_proveedor INT NOT NULL COMMENT 'Identificador del proveedor.',
    fk_pre_alm INT NOT NULL COMMENT 'Identificador de la presentación en el almacén.',

    CONSTRAINT fk_usuario
        FOREIGN KEY (fk_usuario) REFERENCES USUARIO (usu_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_proveedor
        FOREIGN KEY (fk_proveedor) REFERENCES PROVEEDOR (pro_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_pre_alm
        FOREIGN KEY (fk_pre_alm) REFERENCES PRE_ALM (pre_alm_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_sol_com_fecha
        CHECK (sol_com_fecha >= CURRENT_DATE AND sol_com_fecha <= '2100-12-31 23:59:59')
);

CREATE TABLE DETALLE_COMPRA 
(
    det_com_id SERIAL PRIMARY KEY COMMENT 'Identificador único del detalle de la compra.',
    det_com_cantidad INT NOT NULL COMMENT 'Cantidad de la compra.',
    det_com_precio_unitario DECIMAL(10, 2) NOT NULL COMMENT 'Precio unitario de la compra.',
    fk_sol_com INT NOT NULL COMMENT 'Identificador de la solicitud de compra.',
    fk_presentacion INT NOT NULL COMMENT 'Identificador de la presentación.',

    PRIMARY KEY (det_com_id, fk_sol_com, fk_presentacion),

    CONSTRAINT fk_sol_com
        FOREIGN KEY (fk_sol_com) REFERENCES SOLICITUD_COMPRA (sol_com_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_presentacion
        FOREIGN KEY (fk_presentacion) REFERENCES PRESENTACION (pre_id)
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
    cue_pun_id          SERIAL PRIMARY KEY COMMENT 'Identificador único de la cuenta de punto.',
    cue_pun_cantidad    DECIMAL(12, 2) NOT NULL DEFAULT 0.00 COMMENT 'Cantidad de la cuenta de punto.',
    fk_cliente          INT NOT NULL COMMENT 'Identificador del cliente.',
    fk_venta_fisica     INT NOT NULL COMMENT 'Identificador de la venta física.',

    CONSTRAINT fk_cliente
        FOREIGN KEY (fk_cliente) REFERENCES CLIENTE (cli_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_cue_pun_cantidad 
        CHECK (cue_pun_cantidad  >= 0)
);

-- Tabla: HISTORICO_PRECIO_PUNTO
CREATE TABLE HISTORICO_PRECIO_PUNTO
(
    his_pre_pun_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del historico de precio de punto.',
    his_pre_pun_fecha_hora  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del historico de precio de punto.',
    his_pre_pun_valor       INT NOT NULL COMMENT 'Valor del historico de precio de punto.',

    CONSTRAINT ck_his_pre_pun_fecha
        CHECK (his_pre_pun_fecha <= CURRENT_TIMESTAMP AND his_pre_pun_fecha >= '1900-01-01 00:00:00')
);

-- Tabla: METODO_PAGO
CREATE TABLE METODO_PAGO
(
    met_pag_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del metodo de pago.',
    efe_denominacion    INT COMMENT 'Denominacion del metodo de pago.',
    che_num_cheque      INT COMMENT 'Numero de cheque del metodo de pago.',
    tar_deb_numero      INT COMMENT 'Numero de tarjeta de debito del metodo de pago.',
    tar_deb_vencimiento DATE COMMENT 'Vencimiento de la tarjeta de debito.',
    tar_deb_banco       VARCHAR(50) COMMENT 'Banco de la tarjeta de debito.',
    tar_cre_numero      INT COMMENT 'Numero de tarjeta de credito.',
    tar_cre_vencimiento DATE COMMENT 'Vencimiento de la tarjeta de credito.',
    met_pag_tipo_pago   VARCHAR(50) NOT NULL COMMENT 'Tipo de pago.',
    fk_his_pre_pun      INT COMMENT 'Identificador del historico de precio de punto.',

    CONSTRAINT fk_his_pre_pun
        FOREIGN KEY (fk_his_pre_pun) REFERENCES HISTORICO_PRECIO_PUNTO (his_pre_pun_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_met_pag_tipo_pago
        CHECK (UPPER(met_pag_tipo_pago) IN ('EFECTIVO', 'CHEQUE', 'TARJETA_DEBITO', 'TARJETA_CREDITO', 'PUNTO'))
);

CREATE TABLE MONEDA
(
    mon_id              SERIAL PRIMARY KEY COMMENT 'Identificador único de la moneda.',
    mon_tipo            VARCHAR(50) NOT NULL UNIQUE COMMENT 'Tipo de moneda.',

    CONSTRAINT ck_mon_tipo
        CHECK (UPPER(mon_tipo) IN ('BOLIVAR', 'DOLAR', 'EURO', 'YEN', 'LIBRA') OR
               mon_tipo ~ '^[A-Z]+$')
);

-- Tabla: PAGO
CREATE TABLE PAGO
(
    pag_id              SERIAL PRIMARY KEY COMMENT 'Identificador único del pago.',
    pag_monto           DECIMAL(12, 2) NOT NULL COMMENT 'Monto del pago.',
    pag_fecha           TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha del pago.',
    fk_metodo_pago      INT NOT NULL COMMENT 'Identificador del metodo de pago.',
    fk_venta_fisica     INT NULL COMMENT 'Identificador de la venta física.',
    fk_venta_online     INT NULL COMMENT 'Identificador de la venta online.',
    fk_afiliacion       INT NULL COMMENT 'Identificador de la afiliación.',
    fk_venta_evento     INT NULL COMMENT 'Identificador de la venta del evento.',
    fk_moneda           INT NOT NULL COMMENT 'Identificador de la moneda.',

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
    his_mon_id          SERIAL PRIMARY KEY COMMENT 'Identificador único del historico de moneda.',
    his_mon_fecha_hora  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del historico de moneda.',
    his_valor_cambio    DECIMAL(12, 2) NOT NULL COMMENT 'Valor de cambio de la moneda.',
    fk_moneda           INT NOT NULL COMMENT 'Identificador de la moneda.',

    CONSTRAINT fk_moneda
        FOREIGN KEY (fk_moneda) REFERENCES MONEDA (mon_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_his_mon_fecha
        CHECK (his_mon_fecha <= CURRENT_TIMESTAMP AND his_mon_fecha >= '1900-01-01 00:00:00'),

    CONSTRAINT ck_his_valor_cambio
        CHECK (his_valor_cambio > 0)
);

CREATE TABLE PAGO_EFECTIVO
(
    pag_efe_id SERIAL PRIMARY KEY COMMENT 'Identificador único del pago efectivo.',
    pag_efe_monto DECIMAL(10, 2) NOT NULL COMMENT 'Monto del pago efectivo.',
    pag_efe_fecha TIMESTAMP NOT NULL COMMENT 'Fecha del pago efectivo.',
    fk_sol_com INT NOT NULL COMMENT 'Identificador de la solicitud de compra.',
    fk_metodo_pago INT NOT NULL COMMENT 'Identificador del metodo de pago.',

    CONSTRAINT fk_metodo_pago
        FOREIGN KEY (fk_metodo_pago) REFERENCES METODO_PAGO (met_pag_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_pag_efe_fecha
        CHECK (pag_efe_fecha >= CURRENT_DATE AND pag_efe_fecha <= '2100-12-31 23:59:59')
);

--------------------------------------------------------------------------------
-- . ESTATUS
--------------------------------------------------------------------------------

CREATE TABLE ESTATUS
(
    est_id              SERIAL PRIMARY KEY COMMENT 'Identificador único del estatus.',
    est_tipo_estatus    VARCHAR(50) NOT NULL UNIQUE COMMENT 'Tipo de estatus.',
    est_descripcion     VARCHAR(255) NOT NULL COMMENT 'Descripción del estatus.',

    CONSTRAINT ck_est_tipo_estatus
        CHECK (UPPER(est_tipo_estatus) IN ('PENDIENTE', 'APROBADO', 'RECHAZADO', 'EN_PROCESO', 'FINALIZADO') OR
               est_tipo_estatus ~ '^[A-Z]+$'),

    CONSTRAINT ck_est_descripcion
        CHECK (est_descripcion ~ '^[A-Za-z0-9\s,.-]+$')
);

CREATE TABLE VEN_ONL_EST
(
    ven_onl_est_id              SERIAL PRIMARY KEY COMMENT 'Identificador único del estatus de la venta online.',
    ven_onl_est_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio del estatus de la venta online.',
    ven_onl_est_fecha_fin       DATE COMMENT 'Fecha de fin del estatus de la venta online.',
    fk_venta_online             INT NOT NULL COMMENT 'Identificador de la venta online.',
    fk_estatus                  INT NOT NULL COMMENT 'Identificador del estatus.',

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
    afi_est_id              SERIAL NOT NULL COMMENT 'Identificador único del estatus de la afiliación.',
    afi_est_fecha_inicio    DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio del estatus de la afiliación.',
    afi_est_fecha_fin       DATE COMMENT 'Fecha de fin del estatus de la afiliación.',
    fk_afiliacion           INT NOT NULL COMMENT 'Identificador de la afiliación.',
    fk_estatus              INT NOT NULL COMMENT 'Identificador del estatus.',

    PRIMARY KEY (afi_est_id, fk_afiliacion, fk_estatus), -- Clave primaria compuesta por afi_est_id, fk_afiliacion y fk_estatus.

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
    sol_rep_est_id SERIAL PRIMARY KEY COMMENT 'Identificador único del estatus de la solicitud de reposición.',
    sol_rep_est_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio del estatus de la solicitud de reposición.',
    sol_rep_est_fecha_fin DATE COMMENT 'Fecha de fin del estatus de la solicitud de reposición.',
    fk_sol_rep INT NOT NULL COMMENT 'Identificador de la solicitud de reposición.',
    fk_estatus INT NOT NULL COMMENT 'Identificador del estatus.',

    PRIMARY KEY (sol_rep_est_id, fk_sol_rep, fk_estatus),

    CONSTRAINT fk_sol_rep
        FOREIGN KEY (fk_sol_rep) REFERENCES SOLICITUD_REPOSICION (sol_rep_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_estatus
        FOREIGN KEY (fk_estatus) REFERENCES ESTATUS (est_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_sol_rep_est_fecha_inicio
        CHECK (sol_rep_est_fecha_inicio <= CURRENT_DATE AND sol_rep_est_fecha_inicio >= '1900-01-01'),
);

CREATE TABLE SOL_COM_EST
(
    sol_com_est_id SERIAL PRIMARY KEY COMMENT 'Identificador único del estatus de la solicitud de compra.',
    sol_com_est_fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE COMMENT 'Fecha de inicio del estatus de la solicitud de compra.',
    sol_com_est_fecha_fin DATE COMMENT 'Fecha de fin del estatus de la solicitud de compra.',
    fk_sol_com INT NOT NULL COMMENT 'Identificador de la solicitud de compra.',
    fk_estatus INT NOT NULL COMMENT 'Identificador del estatus.',

    PRIMARY KEY (sol_com_est_id, fk_sol_com, fk_estatus),

    CONSTRAINT fk_sol_com
        FOREIGN KEY (fk_sol_com) REFERENCES SOLICITUD_COMPRA (sol_com_id)
            ON DELETE CASCADE,

    CONSTRAINT fk_estatus
        FOREIGN KEY (fk_estatus) REFERENCES ESTATUS (est_id)
            ON DELETE CASCADE,

    CONSTRAINT ck_sol_com_est_fecha_inicio
        CHECK (sol_com_est_fecha_inicio <= CURRENT_DATE AND sol_com_est_fecha_inicio >= '1900-01-01'),
);

--DROP A TODA LAS TABLAS 
DROP TABLE IF EXISTS VEN_ONL_EST CASCADE;
DROP TABLE IF EXISTS EVE_PRO CASCADE;
DROP TABLE IF EXISTS ASISTENCIA_EVENTO CASCADE; 
DROP TABLE IF EXISTS VENTA_BOLETO_EVENTO CASCADE;
DROP TABLE IF EXISTS VENTA_EVENTO CASCADE;
DROP TABLE IF EXISTS EVENTO CASCADE;
DROP TABLE IF EXISTS TIPO_EVENTO CASCADE;   
DROP TABLE IF EXISTS VENTA_ONLINE CASCADE;
DROP TABLE IF EXISTS VENTA_FISICA CASCADE;
DROP TABLE IF EXISTS OFERTA CASCADE;
DROP TABLE IF EXISTS USUARIO CASCADE;
DROP TABLE IF EXISTS PRI_ROL CASCADE;
DROP TABLE IF EXISTS PRIVILEGIO CASCADE;
DROP TABLE IF EXISTS ROL CASCADE;
DROP TABLE IF EXISTS CORREO_ELECTRONICO CASCADE;
DROP TABLE IF EXISTS TELEFONO CASCADE;
DROP TABLE IF EXISTS VACACION CASCADE;
DROP TABLE IF EXISTS EMP_CAR CASCADE;
DROP TABLE IF EXISTS CARGO CASCADE;
DROP TABLE IF EXISTS EMPLEADO CASCADE;
DROP TABLE IF EXISTS CONTACTO_PROVEEDOR CASCADE;
DROP TABLE IF EXISTS PROVEEDOR CASCADE;
DROP TABLE IF EXISTS CONTACTO_CLIENTE CASCADE;
DROP TABLE IF EXISTS CLIENTE CASCADE;
DROP TABLE IF EXISTS INGREDIENTE CASCADE;
DROP TABLE IF EXISTS REC_INS CASCADE;
DROP TABLE IF EXISTS INSTRUCCION CASCADE;
DROP TABLE IF EXISTS REC_ING CASCADE;
DROP TABLE IF EXISTS CERVEZA CASCADE;
DROP TABLE IF EXISTS PRESENTACION CASCADE;
DROP TABLE IF EXISTS TIPO_ESTILO_CERVEZA CASCADE;
DROP TABLE IF EXISTS RECETA CASCADE;
DROP TABLE IF EXISTS ESTILO_CERVEZA CASCADE;
DROP TABLE IF EXISTS TIPO_CERVEZA CASCADE;
DROP TABLE IF EXISTS LUGAR CASCADE;
DROP TABLE IF EXISTS TIENDA CASCADE;
DROP TABLE IF EXISTS TIPO_ESTILO_CERVEZA CASCADE;
DROP TABLE IF EXISTS TIPO_CERVEZA CASCADE;
DROP TABLE IF EXISTS ESTILO_CERVEZA CASCADE;
DROP TABLE IF EXISTS LUGAR CASCADE;
DROP TABLE IF EXISTS TIENDA CASCADE;
DROP TABLE IF EXISTS ESTATUS CASCADE;
DROP TABLE IF EXISTS PAGO CASCADE;
DROP TABLE IF EXISTS METODO_PAGO CASCADE;
DROP TABLE IF EXISTS HISTORICO_PRECIO_PUNTO CASCADE;
DROP TABLE IF EXISTS CUENTA_PUNTO CASCADE;
DROP TABLE IF EXISTS EMP_TIP_BEN CASCADE;
DROP TABLE IF EXISTS TIPO_BENEFICIO CASCADE;
DROP TABLE IF EXISTS EMP_CAR_HOR CASCADE;
DROP TABLE IF EXISTS HORARIO CASCADE;
DROP TABLE IF EXISTS ASISTENCIA CASCADE;
DROP TABLE IF EXISTS DEP_TIE CASCADE;
DROP TABLE IF EXISTS DEPARTAMENTO CASCADE;
DROP TABLE IF EXISTS AFI_EST CASCADE;
DROP TABLE IF EXISTS AFILIACION CASCADE;
DROP TABLE IF EXISTS CAR_TIP_CER CASCADE;
DROP TABLE IF EXISTS CARACTERISTICA CASCADE;
DROP TABLE IF EXISTS CERV_CAR CASCADE;


