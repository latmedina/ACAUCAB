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
    p_username VARCHAR,
    p_password VARCHAR,
    p_email VARCHAR,
    p_first_name VARCHAR DEFAULT '',
    p_last_name VARCHAR DEFAULT '',
    p_is_superuser BOOLEAN DEFAULT FALSE,
    p_is_staff BOOLEAN DEFAULT FALSE,
    p_fk_cliente INTEGER DEFAULT NULL,
    p_fk_proveedor INTEGER DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO usuario (
        username, password, email,
        first_name, last_name,
        is_active, is_superuser, is_staff,
        date_joined, fk_cliente, fk_proveedor
    ) VALUES (
        p_username, p_password, p_email,
        p_first_name, p_last_name,
        TRUE, p_is_superuser, p_is_staff,
        NOW(), p_fk_cliente, p_fk_proveedor
    );
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- Puedes seguir agregando más funciones aquí
-- ===========================================