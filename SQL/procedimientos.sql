-- ===========================================
-- PROCEDIMIENTOS SQL PARA EL SISTEMA
-- Incluye funciones para registrar usuarios y ventas físicas
-- ===========================================

-- ===========================================
-- FUNCION: registrar_venta_fisica
-- ===========================================

CREATE OR REPLACE FUNCTION registrar_venta_fisica(
    cliente_id INTEGER,
    tienda_id INTEGER,
    total NUMERIC
) RETURNS INTEGER AS $$
DECLARE
    nueva_venta_id INTEGER;
BEGIN
    INSERT INTO venta_fisica (ven_fis_fecha, ven_fis_total, fk_cliente, fk_tienda)
    VALUES (CURRENT_DATE, total, cliente_id, tienda_id)
    RETURNING ven_fis_id INTO nueva_venta_id;

    RETURN nueva_venta_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: registrar_usuario
-- ===========================================

CREATE OR REPLACE FUNCTION registrar_usuario(
    p_username TEXT,
    p_email TEXT,
    p_password TEXT,
    p_tipo TEXT,
    p_id_entidad INTEGER,
    p_emp_car_id INTEGER,
    p_first_name TEXT,
    p_last_name TEXT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO usuario (
        username,
        email,
        password,
        is_active,
        is_staff,
        is_superuser,
        date_joined,
        fk_cliente,
        fk_proveedor,
        fk_emp_car,
        first_name,
        last_name
    )
    VALUES (
        p_username,
        p_email,
        p_password,
        TRUE, FALSE, FALSE, NOW(),
        CASE WHEN p_tipo = 'cliente' THEN p_id_entidad ELSE NULL END,
        CASE WHEN p_tipo = 'proveedor' THEN p_id_entidad ELSE NULL END,
        CASE WHEN p_tipo = 'empleado' THEN p_emp_car_id ELSE NULL END,
        p_first_name,
        p_last_name
    );
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: modificar_usuario
-- ===========================================

CREATE OR REPLACE FUNCTION modificar_usuario(
    p_id_usuario INTEGER,
    p_username TEXT,
    p_email TEXT,
    p_password TEXT,
    p_first_name TEXT,
    p_last_name TEXT
)
RETURNS VOID AS $$
BEGIN
    UPDATE usuario
    SET 
        username = p_username,
        email = p_email,
        first_name = p_first_name,
        last_name = p_last_name,
        password = CASE 
                    WHEN p_password IS NOT NULL AND p_password != '' 
                    THEN crypt(p_password, gen_salt('bf')) 
                    ELSE password 
                END
    WHERE id = p_id_usuario;
END;
$$ LANGUAGE plpgsql;