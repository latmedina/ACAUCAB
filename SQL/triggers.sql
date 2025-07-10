-- =====================================================
-- TRIGGER: DESCUENTO AUTOMÁTICO DE INVENTARIO EN VENTAS FÍSICAS
-- =====================================================
-- Este trigger se ejecuta automáticamente cuando se inserta un registro 
-- en la tabla detalle_venta_fisica y descuenta la cantidad correspondiente
-- del inventario

-- Función para procesar el descuento de inventario
CREATE OR REPLACE FUNCTION fn_descuento_inventario_venta_fisica()
RETURNS TRIGGER AS $$
DECLARE
    v_cantidad_disponible INTEGER;
    v_producto_nombre VARCHAR(255);
BEGIN
    -- Validar que la cantidad a vender sea positiva
    IF NEW.det_ven_fis_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad vendida debe ser mayor a cero. Cantidad recibida: %', NEW.det_ven_fis_cantidad;
    END IF;

    -- Obtener la cantidad disponible actual en inventario
    SELECT inv_cantidad 
    INTO v_cantidad_disponible
    FROM inventario 
    WHERE inv_id = NEW.fk_inventario;
    
    -- Verificar que el inventario existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró el inventario con ID: %', NEW.fk_inventario;
    END IF;
    
    -- Obtener nombre del producto para mensajes más descriptivos
    SELECT p.prese_nombre
    INTO v_producto_nombre
    FROM inventario i
    INNER JOIN presentacion p ON i.fk_presentacion = p.prese_id
    WHERE i.inv_id = NEW.fk_inventario;
    
    -- Verificar que hay suficiente inventario disponible
    IF v_cantidad_disponible < NEW.det_ven_fis_cantidad THEN
        RAISE EXCEPTION 'Inventario insuficiente para el producto "%" (ID: %). Disponible: %, Solicitado: %', 
            COALESCE(v_producto_nombre, 'Producto'), 
            NEW.fk_inventario, 
            v_cantidad_disponible, 
            NEW.det_ven_fis_cantidad;
    END IF;
    
    -- Descontar la cantidad vendida del inventario
    UPDATE inventario 
    SET inv_cantidad = inv_cantidad - NEW.det_ven_fis_cantidad
    WHERE inv_id = NEW.fk_inventario;
    
    -- Verificar que el update fue exitoso
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error al actualizar el inventario con ID: %', NEW.fk_inventario;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger que se ejecuta después de cada INSERT en detalle_venta_fisica
DROP TRIGGER IF EXISTS tr_descuento_inventario_venta_fisica ON detalle_venta_fisica;

CREATE TRIGGER tr_descuento_inventario_venta_fisica
    AFTER INSERT ON detalle_venta_fisica
    FOR EACH ROW
    EXECUTE FUNCTION fn_descuento_inventario_venta_fisica();

-- =====================================================
-- TRIGGER: OTORGAR PUNTOS AUTOMÁTICAMENTE EN VENTAS FÍSICAS
-- =====================================================
-- Este trigger se ejecuta automáticamente cuando se inserta un registro 
-- en la tabla venta_fisica y otorga puntos al cliente basándose en el 10% del monto total

-- Función para otorgar puntos por venta física
CREATE OR REPLACE FUNCTION fn_otorgar_puntos_venta_fisica()
RETURNS TRIGGER AS $$
DECLARE
    v_monto_puntos DECIMAL(12,2);
    v_valor_punto INTEGER;
    v_puntos_otorgados INTEGER;
    v_puntos_actuales INTEGER;
BEGIN
    -- Validar que la venta tiene un cliente asociado
    IF NEW.fk_cliente IS NULL THEN
        -- No hay cliente, no se otorgan puntos pero no es un error
        RETURN NEW;
    END IF;
    
    -- Validar que el monto total sea positivo
    IF NEW.ven_fis_total <= 0 THEN
        -- Monto inválido, no se otorgan puntos pero no es un error
        RETURN NEW;
    END IF;
    
    -- Calcular el 10% del monto total de la venta
    v_monto_puntos := NEW.ven_fis_total * 0.10;
    
    -- Obtener el último valor histórico del punto
    SELECT his_pre_pun_valor 
    INTO v_valor_punto
    FROM historico_precio_punto 
    ORDER BY his_pre_pun_fecha_hora DESC 
    LIMIT 1;
    
    -- Verificar que existe un precio histórico de puntos
    IF NOT FOUND OR v_valor_punto IS NULL OR v_valor_punto <= 0 THEN
        -- No hay precio de puntos configurado, no se otorgan puntos pero no es un error
        RETURN NEW;
    END IF;
    
    -- Calcular los puntos a otorgar (dividir monto entre valor del punto)
    v_puntos_otorgados := FLOOR(v_monto_puntos / v_valor_punto);
    
    -- Solo otorgar puntos si el resultado es mayor a 0
    IF v_puntos_otorgados > 0 THEN
        -- Obtener puntos actuales del cliente
        SELECT COALESCE(cli_cantidad_puntos, 0) 
        INTO v_puntos_actuales
        FROM cliente 
        WHERE cli_id = NEW.fk_cliente;
        
        -- Actualizar los puntos del cliente
        UPDATE cliente 
        SET cli_cantidad_puntos = v_puntos_actuales + v_puntos_otorgados
        WHERE cli_id = NEW.fk_cliente;

        -- Actualizar el historico de puntos del cliente
        INSERT INTO cuenta_punto (cue_pun_cantidad, fk_venta_fisica, fk_cliente)
        VALUES (v_puntos_otorgados, NEW.ven_fis_id, NEW.fk_cliente);

        -- Verificar que el update fue exitoso
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Error al actualizar puntos del cliente con ID: %', NEW.fk_cliente;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger que se ejecuta después de cada INSERT en venta_fisica
DROP TRIGGER IF EXISTS tr_otorgar_puntos_venta_fisica ON venta_fisica;
CREATE TRIGGER tr_otorgar_puntos_venta_fisica
    AFTER INSERT ON venta_fisica
    FOR EACH ROW
    EXECUTE FUNCTION fn_otorgar_puntos_venta_fisica();

-- =====================================================
-- TRIGGER: GENERAR SOLICITUD DE REPOSICIÓN DESDE INVENTARIO
-- =====================================================
-- Este trigger se ejecuta automáticamente cuando se actualiza la cantidad de un inventario
-- y genera una solicitud de reposición si el stock baja de 20 unidades.

CREATE OR REPLACE FUNCTION public.fn_generar_reposicion_desde_inventario()
RETURNS TRIGGER AS $$
DECLARE
    -- Variable para guardar el ID de la tabla pre_alm correspondiente.
    v_id_pre_alm INTEGER;
    -- Variable para guardar el ID de la nueva solicitud creada.
    v_nueva_solicitud_id INTEGER;
    -- Variable para el ID del estatus "Pendiente". ¡Ajustar si es diferente!
    v_id_estatus_pendiente INTEGER := 1; -- ASUNCIÓN: El ID 1 corresponde a "Pendiente".
    -- Variable para verificar si ya existe una solicitud pendiente.
    v_solicitud_existente INTEGER;
BEGIN
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- PASO CLAVE: BLOQUEO DE TRANSACCIÓN POR ID DE INVENTARIO
    -- Se adquiere un bloqueo exclusivo para el ID de este inventario. Si otra transacción
    -- intenta adquirir el mismo bloqueo, esperará hasta que esta transacción termine (COMMIT o ROLLBACK).
    -- Esto serializa las operaciones para un mismo producto y previene condiciones de carrera.
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    PERFORM pg_advisory_xact_lock(NEW.inv_id);

    -- La lógica principal de validación (WHEN) ya está en el trigger, pero este IF
    -- sirve como doble chequeo y ahora está protegido por el bloqueo.
    IF NEW.inv_cantidad <= 20 AND NEW.inv_cantidad < OLD.inv_cantidad THEN

        -- PASO 1: VERIFICAR SI YA EXISTE UNA SOLICITUD PENDIENTE (AHORA DE FORMA SEGURA)
        SELECT sr.sol_rep_id INTO v_solicitud_existente
        FROM public.solicitud_reposicion sr
        JOIN public.sol_rep_est sre ON sr.sol_rep_id = sre.fk_sol_rep
        WHERE sr.fk_inv = NEW.inv_id
          AND sre.fk_estatus = v_id_estatus_pendiente
          AND sre.sol_rep_est_fecha_fin IS NULL
        LIMIT 1;

        -- PASO 2: SI NO HAY SOLICITUDES PENDIENTES, PROCEDER A CREAR UNA NUEVA
        IF v_solicitud_existente IS NULL THEN
            -- Buscar el 'pre_alm_id' correspondiente para completar la información.
            SELECT pre_alm_id INTO v_id_pre_alm
            FROM public.pre_alm
            WHERE fk_presentacion = NEW.fk_presentacion
            LIMIT 1;

            -- Si se encontró el registro en pre_alm, crear la solicitud y su estatus.
            IF FOUND THEN
                -- Insertar la nueva solicitud de reposición.
                INSERT INTO public.solicitud_reposicion (
                    sol_rep_fecha_hora,
                    sol_rep_descripcion,
                    fk_inv,
                    fk_pre_alm,
                    fk_usuario
                )
                VALUES (
                    NOW(),
                    CONCAT('Stock bajo en inventario ID: ', NEW.inv_id),
                    NEW.inv_id,
                    v_id_pre_alm,
                    NULL
                )
                RETURNING sol_rep_id INTO v_nueva_solicitud_id;

                IF NOT EXISTS (
                    SELECT 1 FROM public.sol_rep_est
                    WHERE fk_sol_rep = v_nueva_solicitud_id
                    AND fk_estatus = v_id_estatus_pendiente
                    AND sol_rep_est_fecha_fin IS NULL
                ) THEN
                    INSERT INTO public.sol_rep_est (
                        sol_rep_est_fecha_inicio,
                        sol_rep_est_fecha_fin,
                        fk_estatus,
                        fk_sol_rep
                    )
                    VALUES (
                        CURRENT_DATE,
                        NULL,
                        v_id_estatus_pendiente,
                        v_nueva_solicitud_id
                    );
                END IF;
            END IF; -- Fin de la creación de la solicitud
        END IF; -- Fin de la verificación de solicitud existente
    END IF;

    -- Para triggers AFTER, el valor de retorno se ignora, pero se recomienda devolver NEW.
    -- El bloqueo adquirido con pg_advisory_xact_lock se libera automáticamente al final de la transacción.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ========= TRIGGER (VERSIÓN 2 - CORREGIDO) =========
-- Este trigger no necesita cambios. Su lógica sigue siendo correcta.
-- Es importante asegurarse de que solo exista UN trigger para esta acción en la tabla.

-- Primero, eliminamos el trigger si ya existe para evitar errores al volver a ejecutar el script.
DROP TRIGGER IF EXISTS trg_verificar_stock_inventario ON public.inventario;

-- Creamos el trigger en la tabla correcta ('inventario')
CREATE TRIGGER trg_verificar_stock_inventario
    AFTER UPDATE ON public.inventario
    FOR EACH ROW
    WHEN (NEW.inv_cantidad < OLD.inv_cantidad AND NEW.inv_cantidad <= 20)
    EXECUTE FUNCTION public.fn_generar_reposicion_desde_inventario();



-- Trigger para crear solicitud de compra cuando stock baja de 100
CREATE OR REPLACE FUNCTION crear_solicitud_compra()
RETURNS TRIGGER AS $$
DECLARE
    v_proveedor_id INTEGER;
    v_solicitud_id INTEGER;
BEGIN
    -- Solo actuar si la cantidad bajó de 100
    IF NEW.pre_alm_cantidad < 100 AND OLD.pre_alm_cantidad >= 100 THEN
        
        -- Obtener un proveedor (tomar el primero disponible)
        SELECT pro_id INTO v_proveedor_id 
        FROM proveedor 
        LIMIT 1;
        
        -- Crear la solicitud de compra
        INSERT INTO solicitud_compra (
            sol_com_fecha,
            sol_com_total,
            fk_proveedor,
            fk_pre_alm,
            fk_usuario
        ) VALUES (
            NOW(),
            NEW.pre_alm_precio * 1000,  -- total = precio unitario * cantidad
            v_proveedor_id,
            NEW.pre_alm_id,
            NULL  -- sin usuario específico
        ) RETURNING sol_com_id INTO v_solicitud_id;
        
        -- Crear el detalle de compra
        INSERT INTO detalle_compra (
            det_com_cantidad,
            det_com_precio_unitario,
            fk_sol_com,
            fk_presentacion
        ) VALUES (
            1000,
            NEW.pre_alm_precio,
            v_solicitud_id,
            NEW.fk_presentacion
        );
        
        -- Asignar estatus PENDIENTE (id = 1)
        INSERT INTO sol_com_est (
            sol_com_est_fecha_inicio,
            sol_com_est_fecha_fin,
            fk_sol_com,
            fk_estatus
        ) VALUES (
            CURRENT_DATE,
            NULL,
            v_solicitud_id,
            1  -- PENDIENTE
        );
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para pre_alm
CREATE OR REPLACE TRIGGER trigger_stock_bajo
    AFTER UPDATE ON pre_alm
    FOR EACH ROW
    EXECUTE FUNCTION crear_solicitud_compra();

-- Trigger para actualizar stock cuando se entrega la solicitud
CREATE OR REPLACE FUNCTION actualizar_stock_entrega()
RETURNS TRIGGER AS $$
DECLARE
    v_presentacion_id INTEGER;
    v_cantidad INTEGER;
    v_pre_alm_id INTEGER;
    v_almacen_id INTEGER;
    v_precio_unitario DECIMAL(10,2);
    detalle_record RECORD;
BEGIN
    -- Solo actuar si el nuevo registro tiene estatus ENTREGADO (id = 7)
    IF NEW.fk_estatus = 7 THEN
        
        -- Obtener el almacén de la solicitud original
        SELECT pa.fk_almacen INTO v_almacen_id
        FROM solicitud_compra sc
        JOIN pre_alm pa ON sc.fk_pre_alm = pa.pre_alm_id
        WHERE sc.sol_com_id = NEW.fk_sol_com;
        
        -- Recorrer todos los detalles de compra de esta solicitud
        FOR detalle_record IN 
            SELECT dc.fk_presentacion, dc.det_com_cantidad, dc.det_com_precio_unitario
            FROM detalle_compra dc
            WHERE dc.fk_sol_com = NEW.fk_sol_com
        LOOP
            v_presentacion_id := detalle_record.fk_presentacion;
            v_cantidad := detalle_record.det_com_cantidad;
            v_precio_unitario := detalle_record.det_com_precio_unitario;
            
            -- Buscar el pre_alm correspondiente a esta presentación en el mismo almacén
            SELECT pa.pre_alm_id INTO v_pre_alm_id
            FROM pre_alm pa
            WHERE pa.fk_presentacion = v_presentacion_id
            AND pa.fk_almacen = v_almacen_id;
            
            -- Si encontramos el pre_alm, actualizar la cantidad
            IF v_pre_alm_id IS NOT NULL THEN
                UPDATE pre_alm
                SET pre_alm_cantidad = pre_alm_cantidad + v_cantidad
                WHERE pre_alm_id = v_pre_alm_id;
            ELSE
                -- Si no existe el registro, crearlo
                INSERT INTO pre_alm (
                    pre_alm_precio,
                    pre_alm_cantidad,
                    fk_almacen,
                    fk_presentacion,
                    fk_oferta
                ) VALUES (
                    v_precio_unitario,
                    v_cantidad,
                    v_almacen_id,
                    v_presentacion_id,
                    NULL  -- sin oferta por defecto
                );
            END IF;
            
        END LOOP;
        
        -- Cerrar el estatus anterior poniendo fecha fin
        UPDATE sol_com_est
        SET sol_com_est_fecha_fin = CURRENT_DATE
        WHERE fk_sol_com = NEW.fk_sol_com 
        AND fk_estatus != 7 
        AND sol_com_est_fecha_fin IS NULL;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para sol_com_est
CREATE OR REPLACE TRIGGER trigger_entrega_completada
    AFTER INSERT ON sol_com_est
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_stock_entrega();

-- ===========================================
-- TRIGGER: Descuento de stock en venta online
-- Descuenta automáticamente el stock de pre_alm 
-- cuando se registra un detalle de venta online
-- ===========================================

CREATE OR REPLACE FUNCTION fn_descuento_stock_venta_online()
RETURNS TRIGGER AS $$
DECLARE
    v_cantidad_disponible INTEGER;
    v_producto_nombre VARCHAR(255);
BEGIN
    -- Validar que la cantidad a vender sea positiva
    IF NEW.det_ven_onl_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad vendida debe ser mayor a cero. Cantidad recibida: %', NEW.det_ven_onl_cantidad;
    END IF;

    -- Obtener la cantidad disponible actual en pre_alm
    SELECT pre_alm_cantidad 
    INTO v_cantidad_disponible
    FROM pre_alm 
    WHERE pre_alm_id = NEW.fk_pre_alm;
    
    -- Verificar que el registro de pre_alm existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró el registro de pre_alm con ID: %', NEW.fk_pre_alm;
    END IF;
    
    -- Obtener nombre del producto para mensajes más descriptivos
    SELECT p.prese_nombre
    INTO v_producto_nombre
    FROM pre_alm pa
    INNER JOIN presentacion p ON pa.fk_presentacion = p.prese_id
    WHERE pa.pre_alm_id = NEW.fk_pre_alm;
    
    -- Verificar que hay suficiente stock disponible
    IF v_cantidad_disponible < NEW.det_ven_onl_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto "%" (ID: %). Disponible: %, Solicitado: %', 
            COALESCE(v_producto_nombre, 'Producto'), 
            NEW.fk_pre_alm, 
            v_cantidad_disponible, 
            NEW.det_ven_onl_cantidad;
    END IF;
    
    -- Descontar la cantidad vendida del stock de pre_alm
    UPDATE pre_alm 
    SET pre_alm_cantidad = pre_alm_cantidad - NEW.det_ven_onl_cantidad
    WHERE pre_alm_id = NEW.fk_pre_alm;
    
    -- Verificar que el update fue exitoso
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error al actualizar el stock de pre_alm con ID: %', NEW.fk_pre_alm;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger que se ejecuta después de cada INSERT en detalle_venta_online
DROP TRIGGER IF EXISTS tr_descuento_stock_venta_online ON detalle_venta_online;

CREATE TRIGGER tr_descuento_stock_venta_online
    AFTER INSERT ON detalle_venta_online
    FOR EACH ROW
    EXECUTE FUNCTION fn_descuento_stock_venta_online();
