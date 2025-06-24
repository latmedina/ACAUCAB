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

CREATE OR REPLACE FUNCTION public.obtener_datos_reporte_venta(p_venta_id INT)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
    v_venta_count INT;
BEGIN
    -- --- PASO DE DEPURACIÓN 1 ---
    -- Vamos a verificar si la fila es visible DENTRO de la función.
    RAISE NOTICE 'Iniciando obtener_datos_reporte_venta para p_venta_id: %', p_venta_id;

    SELECT count(*)
    INTO v_venta_count
    FROM public.venta_fisica
    WHERE ven_fis_id = p_venta_id;

    RAISE NOTICE 'Conteo de ventas encontradas con el id %: %', p_venta_id, v_venta_count;

    -- Si el conteo es 0, el problema es que la función no puede ver la fila.
    -- No es necesario continuar con la consulta principal.
    IF v_venta_count = 0 THEN
        RAISE NOTICE 'La consulta de conteo no encontró la venta. La fila podría no estar confirmada (committed) o no ser visible para el usuario actual.';
        RETURN json_build_object(
            'error', 'Venta no encontrada durante la verificación interna',
            'status', 404,
            'venta_id_buscado', p_venta_id,
            'debug_info', 'El conteo inicial fue 0'
        );
    END IF;

    -- --- FIN DEL PASO DE DEPURACIÓN ---

    -- El bloque principal de la consulta. Solo se ejecuta si la venta fue encontrada en el conteo.
    SELECT
        json_build_object(
            'venta', json_build_object(
                'id', vf.ven_fis_id,
                'fecha', TO_CHAR(vf.ven_fis_fecha, 'DD/MM/YYYY'),
                'subtotal', ROUND(vf.ven_fis_total / 1.16, 2), -- Asumiendo IVA del 16%
                'iva', ROUND(vf.ven_fis_total - (vf.ven_fis_total / 1.16), 2),
                'total', ROUND(vf.ven_fis_total, 2)
            ),
            'cliente', json_build_object(
                'nombre', COALESCE(c.cli_nat_pnombre || ' ' || c.cli_nat_papellido, c.cli_jur_razon_social, 'No disponible'),
                'rif', COALESCE(c.cli_rif, 'N/A'),
                'direccion', COALESCE(c.cli_direccion_fisica, 'N/A'),
                'telefono', (SELECT tel_numero::text FROM public.telefono WHERE fk_cliente = c.cli_id LIMIT 1)
            ),
            'tienda', json_build_object(
                'nombre', COALESCE(t.tie_nombre, 'No disponible'),
                'direccion', COALESCE(t.tie_direccion, 'N/A')
            ),
            'detalles', (
                SELECT COALESCE(json_agg(
                    json_build_object(
                        'id', p.prese_id,
                        'producto', p.prese_nombre,
                        'cantidad', dvf.det_ven_fis_cantidad,
                        'precio_unitario', dvf.det_ven_fis_precio_unitario,
                        'total_linea', dvf.det_ven_fis_cantidad * dvf.det_ven_fis_precio_unitario
                    )
                ), '[]'::json)
                FROM public.detalle_venta_fisica dvf
                JOIN public.inventario i ON dvf.fk_inventario = i.inv_id
                JOIN public.presentacion p ON i.fk_presentacion = p.prese_id
                WHERE dvf.fk_venta_fisica = vf.ven_fis_id
            )
        )
    INTO v_reporte_data
    FROM public.venta_fisica vf
    LEFT JOIN public.cliente c ON vf.fk_cliente = c.cli_id
    LEFT JOIN public.tienda t ON vf.fk_tienda = t.tie_id
    WHERE vf.ven_fis_id = p_venta_id;

    -- Verificación final por si algo más falló.
    IF v_reporte_data IS NULL THEN
        RAISE NOTICE 'v_reporte_data es NULL después del SELECT principal, a pesar de que el conteo inicial fue > 0. Esto podría indicar un problema en los JOINs.';
        RETURN json_build_object(
            'error', 'Venta encontrada pero los datos no se pudieron construir (posible problema con JOINs)',
            'status', 500,
            'venta_id_buscado', p_venta_id
        );
    END IF;

    -- Si se encontraron datos, se devuelve el JSON construido.
    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;
