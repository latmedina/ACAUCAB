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
-- COMENTARIOS Y DOCUMENTACIÓN
-- =====================================================
/*
DESCRIPCIÓN:
Este trigger se ejecuta automáticamente cada vez que se inserta un registro 
en la tabla detalle_venta_fisica (cuando se registra una venta física).

FUNCIONALIDAD:
1. Valida que la cantidad vendida sea positiva
2. Verifica que el inventario especificado existe
3. Comprueba que hay suficiente stock disponible
4. Descuenta automáticamente la cantidad vendida del inventario
5. Proporciona mensajes de error descriptivos en caso de problemas

VENTAJAS:
- Automático: No requiere intervención manual ni código en Django
- Consistente: Garantiza que el inventario siempre se actualice
- Atómico: Forma parte de la misma transacción de la venta
- Seguro: Valida antes de actualizar para evitar inventarios negativos

TABLA AFECTADA:
- inventario.inv_cantidad (se decrementa)

TABLA DISPARADORA:
- detalle_venta_fisica (AFTER INSERT)

CAMPOS UTILIZADOS:
- NEW.det_ven_fis_cantidad (cantidad vendida)
- NEW.fk_inventario (ID del inventario a actualizar)

EJEMPLO DE USO:
Cuando se ejecute:
INSERT INTO detalle_venta_fisica (det_ven_fis_cantidad, det_ven_fis_precio_unitario, fk_venta_fisica, fk_inventario) 
VALUES (5, 12.50, 1, 3);

El trigger automáticamente ejecutará:
UPDATE inventario SET inv_cantidad = inv_cantidad - 5 WHERE inv_id = 3;

MANTENIMIENTO:
- Para deshabilitar: DROP TRIGGER tr_descuento_inventario_venta_fisica ON detalle_venta_fisica;
- Para modificar: Alterar la función fn_descuento_inventario_venta_fisica()
*/
