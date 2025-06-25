# Sistema de Múltiples Métodos de Pago

## Descripción General

El sistema ha sido actualizado para permitir que los usuarios utilicen **múltiples métodos de pago** en una sola compra. Esto significa que pueden combinar diferentes métodos (efectivo, tarjetas, puntos, etc.) y diferentes monedas para completar una transacción.

## Características Principales

### 🔄 Múltiples Métodos y Monedas
- **Combinación flexible**: Mezcla efectivo, cheques, tarjetas de débito/crédito y puntos
- **Diferentes monedas**: Cada pago puede ser en una moneda distinta (USD, Bolívares, etc.)
- **Conversión automática**: El sistema convierte todo a Bolívares para calcular el total acreditado

### 📊 Control de Progreso en Tiempo Real
- **Barra de progreso visual**: Muestra el porcentaje del total que ha sido pagado
- **Montos dinámicos**: Actualización en tiempo real del monto restante
- **Validaciones automáticas**: Previene pagos que excedan el monto pendiente

### 🛡️ Gestión de Pagos Individuales
- **Agregar pagos**: Cada método se puede aplicar con su monto específico
- **Cancelar pagos**: Eliminar pagos individuales si es necesario
- **Vista detallada**: Lista completa de todos los pagos aplicados

## Flujo de Trabajo Técnico Detallado

### 1. Proceso Completo de Compra y Pago
```
Carrito → Checkout → Validación de Inventario → Múltiples Métodos de Pago → Finalización
```

#### 1.1 Flujo de Ejecución de Funciones
1. `update_cart_view()`: Actualiza el carrito con validaciones de inventario
2. `process_order_view()`: Valida la orden y prepara datos para pago (NO crea venta aún)
3. `payment_method_view()`: Muestra la interfaz de múltiples métodos de pago
4. `get_applied_payments()`: Carga pagos ya aplicados (llamada vía AJAX)
5. `add_partial_payment()`: Agrega pagos parciales (llamada vía AJAX)
6. `remove_partial_payment()`: Elimina pagos si es necesario (llamada vía AJAX)
7. `finalize_multiple_payment_purchase()`: Crea la venta y registra todos los pagos
8. `create_sale_from_order_data()`: Crea la venta física u online
9. `create_payment_method_from_partial_data()`: Crea cada método de pago
10. `registrar_pago()` o `procesar_pago_puntos()`: Funciones SQL para registrar pagos

### 2. Pantalla Principal
La nueva interfaz muestra:
- **Resumen de la compra**: Total original en USD y Bolívares
- **Progreso de pago**: Barra visual con porcentaje completado
- **Pagos aplicados**: Lista de métodos ya agregados
- **Formulario de nuevo pago**: Para agregar métodos adicionales

### 3. Agregar un Pago
Para cada pago individual:
1. **Seleccionar monto**: Especificar cuánto pagar con este método
2. **Elegir moneda**: USD, Bolívares, u otras monedas disponibles
3. **Método de pago**: Efectivo, cheque, tarjeta débito/crédito, o puntos
4. **Detalles específicos**: Información requerida según el método elegido

### 4. Restricciones y Validaciones
- **Montos máximos**: No puede exceder el monto restante
- **Puntos**: Solo se pueden usar en Bolívares
- **Conversiones**: Cálculo automático de equivalencias
- **Inventario**: Verificación continua de disponibilidad

### 5. Finalización
- **Verificación completa**: El total debe estar 100% cubierto
- **Registro múltiple**: Cada método se guarda como pago individual
- **Venta única**: Todos los pagos se asocian a la misma venta

## Ejemplos de Uso

### Ejemplo 1: Compra de $100 USD
```
Total: $100 USD = 4,000 Bs (tasa: 40 Bs/$)

Pago 1: 50% en efectivo
- Monto: 2,000 Bs
- Método: Efectivo
- Denominación: 200 Bs

Pago 2: 30% con tarjeta
- Monto: $30 USD = 1,200 Bs
- Método: Tarjeta de Crédito
- Número: **** **** **** 1234

Pago 3: 20% con puntos
- Monto: 800 Bs
- Método: Puntos
- Puntos usados: 80 puntos (10 Bs/punto)

Estado: ✅ COMPLETADO (100%)
```

### Ejemplo 2: Compra Mixta con Diferentes Monedas
```
Total: $75 USD = 3,000 Bs

Pago 1: En dólares
- Monto: $25 USD
- Método: Efectivo USD
- Equivalente: 1,000 Bs

Pago 2: En bolívares
- Monto: 1,500 Bs
- Método: Tarjeta de Débito
- Banco: Banco Venezuela

Pago 3: Resto con puntos
- Monto: 500 Bs
- Método: Puntos
- Puntos usados: 50 puntos

Estado: ✅ COMPLETADO (100%)
```

## Arquitectura Técnica Detallada

### 1. URLs y Endpoints
```python
# Sistema de Múltiples Métodos de Pago
path('payment-method/', views.payment_method_view, name='payment_method'),
path('get-applied-payments/', views.get_applied_payments, name='get_applied_payments'),
path('add-partial-payment/', views.add_partial_payment, name='add_partial_payment'),
path('remove-partial-payment/', views.remove_partial_payment, name='remove_partial_payment'),
path('finalize-multiple-payment-purchase/', views.finalize_multiple_payment_purchase, name='finalize_multiple_payment_purchase'),
```

### 2. Funciones Backend y su Flujo de Ejecución

#### 2.1 `payment_method_view(request)`
**Propósito**: Renderiza la interfaz principal de pagos múltiples.
**Cuándo se llama**: Después de validar el carrito y procesar la orden.
**Parámetros de entrada**:
- `request`: Objeto HttpRequest con datos de sesión
**Acciones**:
1. Obtiene datos de la orden pendiente de la sesión
2. Calcula el total en bolívares
3. Carga todas las monedas disponibles con sus tasas
4. Obtiene puntos disponibles del usuario
5. Inicializa la sesión de pagos parciales
6. Renderiza el template con todos los datos necesarios

#### 2.2 `get_applied_payments(request)`
**Propósito**: Obtiene los pagos parciales ya aplicados.
**Cuándo se llama**: Al cargar la página de pagos y después de cada modificación.
**Parámetros de entrada**:
- `request`: Objeto HttpRequest con datos de sesión
**Acciones**:
1. Recupera la lista de pagos parciales de la sesión
2. Calcula el total pagado
3. Devuelve JSON con pagos y total

#### 2.3 `add_partial_payment(request)`
**Propósito**: Agrega un nuevo pago parcial a la sesión.
**Cuándo se llama**: Cuando el usuario completa el formulario de pago.
**Parámetros de entrada**:
- `request`: Objeto HttpRequest con datos POST en JSON
**Acciones**:
1. Valida los datos del pago (monto, moneda, método)
2. Verifica que no exceda el total restante
3. Prepara los datos del pago según el tipo
4. Valida campos específicos del método de pago
5. Agrega el pago a la lista en sesión
6. Devuelve JSON con estado y datos del pago

#### 2.4 `remove_partial_payment(request)`
**Propósito**: Elimina un pago parcial de la sesión.
**Cuándo se llama**: Cuando el usuario hace clic en eliminar pago.
**Parámetros de entrada**:
- `request`: Objeto HttpRequest con índice del pago a eliminar
**Acciones**:
1. Obtiene el índice del pago a eliminar
2. Elimina el pago de la lista en sesión
3. Devuelve JSON con estado y datos del pago eliminado

#### 2.5 `finalize_multiple_payment_purchase(request)`
**Propósito**: Finaliza la compra creando la venta y registrando todos los pagos.
**Cuándo se llama**: Cuando el usuario hace clic en "Finalizar Compra".
**Parámetros de entrada**:
- `request`: Objeto HttpRequest con datos de sesión
**Acciones**:
1. Verifica que el total esté completamente cubierto
2. Inicia una transacción atómica en la base de datos
3. Crea la venta (física u online) usando `create_sale_from_order_data()`
4. Para cada pago parcial:
   a. Crea el método de pago con `create_payment_method_from_partial_data()`
   b. Registra el pago usando funciones SQL
5. Limpia la sesión (orden pendiente, pagos parciales, carrito)
6. Devuelve JSON con estado y URL de redirección

#### 2.6 `create_payment_method_from_partial_data(user, payment_data)`
**Propósito**: Crea un objeto de método de pago a partir de datos parciales.
**Cuándo se llama**: Durante la finalización de compra para cada pago.
**Parámetros de entrada**:
- `user`: Usuario actual
- `payment_data`: Diccionario con datos del pago
**Acciones**:
1. Verifica si se debe usar un método guardado o crear uno nuevo
2. Prepara los parámetros específicos según el tipo de pago
3. Llama a la función SQL `registrar_metodo_pago()`
4. Devuelve un objeto con el ID del método de pago creado

#### 2.7 `create_sale_from_order_data(order_data, user)`
**Propósito**: Crea la venta física u online según los datos de la orden.
**Cuándo se llama**: Durante la finalización de compra, antes de registrar pagos.
**Parámetros de entrada**:
- `order_data`: Diccionario con datos de la orden
- `user`: Usuario actual
**Acciones**:
1. Determina si es venta física u online
2. Para venta física:
   a. Llama a `ejecutar_registro_venta_fisica()`
   b. Crea los detalles de venta física
3. Para venta online:
   a. Crea objeto `venta_online`
   b. Crea los detalles de venta online
4. Devuelve los objetos de venta creados

### 3. Gestión de Sesión
```python
# Estructura de datos en la sesión
request.session['pending_order_data'] = {
    'tipo': 'fisica',                # Tipo de venta (física/online)
    'detalles': [...],               # Lista de detalles de productos
    'total': 100.00,                 # Total en USD
    'cart_key': 'cart_fisica'        # Clave del carrito en sesión
}

request.session['partial_payments'] = [
    {
        'monto_original': 25.0,      # Monto en la moneda original
        'monto_bolivares': 1000.0,   # Monto convertido a bolívares
        'moneda_id': 2,              # ID de la moneda
        'moneda_tipo': 'DOLAR',      # Tipo de moneda
        'tipo_pago': 'efectivo',     # Método de pago
        'denominacion': 20,          # Campo específico según método
        'timestamp': '2024-01-15T10:30:00'  # Marca temporal
    },
    # ... más pagos
]
```

### 4. Flujo Frontend (JavaScript)

#### 4.1 Carga Inicial
1. `document.addEventListener('DOMContentLoaded', function() {...})`: Inicializa la página
2. `loadSavedMethods()`: Carga métodos de pago guardados
3. `loadAppliedPayments()`: Carga pagos ya aplicados

#### 4.2 Interacción con Métodos de Pago
1. Usuario selecciona método → `paymentMethodBtns.forEach(btn => {...})`
2. Sistema muestra campos específicos → `showPaymentFields(selectedPaymentMethod)`
3. Para tarjetas, muestra métodos guardados → `showSavedMethods(selectedPaymentMethod)`

#### 4.3 Gestión de Monedas y Montos
1. Usuario selecciona moneda → `monedaSelect.addEventListener('change', onCurrencyChange)`
2. Sistema actualiza conversiones → `updateCurrencyConversion()`
3. Sistema actualiza controles → `updatePaymentControls(currencyType, exchangeRate, true)`

#### 4.4 Agregar Pagos
1. Usuario envía formulario → `form.addEventListener('submit', function(e) {...})`
2. Sistema valida datos → validaciones en `addPartialPayment(e)`
3. Sistema envía datos al backend → `fetch('/add-partial-payment/', {...})`
4. Backend procesa y responde → Frontend actualiza interfaz

#### 4.5 Eliminar Pagos
1. Usuario hace clic en eliminar → `window.removePayment = function(index) {...}`
2. Sistema confirma y envía al backend → `fetch('/remove-partial-payment/', {...})`
3. Backend elimina y responde → Frontend actualiza interfaz

#### 4.6 Finalizar Compra
1. Usuario hace clic en finalizar → `finalizeBtn.addEventListener('click', finalizePurchase)`
2. Sistema confirma y envía al backend → `fetch('/finalize-multiple-payment-purchase/', {...})`
3. Backend procesa, crea venta, registra pagos → Frontend redirige al usuario

## Interacción con la Base de Datos

### 1. Registro de Venta
```sql
-- Función SQL llamada por ejecutar_registro_venta_fisica()
CREATE OR REPLACE FUNCTION registrar_venta_fisica(
    p_cliente_id INTEGER,
    p_tienda_id INTEGER,
    p_total DECIMAL
) RETURNS INTEGER AS $$
DECLARE
    v_venta_id INTEGER;
BEGIN
    INSERT INTO venta_fisica (ven_fis_fecha, ven_fis_total, fk_cliente, fk_tienda)
    VALUES (NOW(), p_total, p_cliente_id, p_tienda_id)
    RETURNING ven_fis_id INTO v_venta_id;
    
    RETURN v_venta_id;
END;
$$ LANGUAGE plpgsql;
```

### 2. Registro de Método de Pago
```sql
-- Función SQL llamada por create_payment_method_from_partial_data()
CREATE OR REPLACE FUNCTION registrar_metodo_pago(
    p_usuario_id INTEGER,
    p_tipo_pago VARCHAR,
    p_tar_deb_numero BIGINT,
    p_tar_deb_vencimiento DATE,
    p_tar_deb_banco VARCHAR,
    p_tar_cre_numero BIGINT,
    p_tar_cre_vencimiento DATE,
    p_efe_denominacion INTEGER,
    p_che_num_cheque VARCHAR,
    p_his_pre_pun_id INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_metodo_id INTEGER;
BEGIN
    INSERT INTO metodo_pago (
        fk_usuario, met_pag_tipo_pago, tar_deb_numero, tar_deb_vencimiento, tar_deb_banco,
        tar_cre_numero, tar_cre_vencimiento, efe_denominacion, che_num_cheque, fk_his_pre_pun
    )
    VALUES (
        p_usuario_id, p_tipo_pago, p_tar_deb_numero, p_tar_deb_vencimiento, p_tar_deb_banco,
        p_tar_cre_numero, p_tar_cre_vencimiento, p_efe_denominacion, p_che_num_cheque, p_his_pre_pun_id
    )
    RETURNING met_pag_id INTO v_metodo_id;
    
    RETURN v_metodo_id;
END;
$$ LANGUAGE plpgsql;
```

### 3. Registro de Pago
```sql
-- Función SQL llamada por finalize_multiple_payment_purchase()
CREATE OR REPLACE FUNCTION registrar_pago(
    p_monto DECIMAL,
    p_metodo_pago_id INTEGER,
    p_venta_fisica_id INTEGER,
    p_venta_online_id INTEGER,
    p_moneda_id INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_pago_id INTEGER;
BEGIN
    INSERT INTO pago (
        pag_fecha, pag_monto, fk_metodo_pago, fk_venta_fisica, fk_venta_online, fk_moneda
    )
    VALUES (
        NOW(), p_monto, p_metodo_pago_id, p_venta_fisica_id, p_venta_online_id, p_moneda_id
    )
    RETURNING pag_id INTO v_pago_id;
    
    RETURN v_pago_id;
END;
$$ LANGUAGE plpgsql;
```

### 4. Procesamiento de Pagos con Puntos
```sql
-- Función SQL llamada por finalize_multiple_payment_purchase() para pagos con puntos
CREATE OR REPLACE FUNCTION procesar_pago_puntos(
    p_usuario_id INTEGER,
    p_puntos_utilizados INTEGER,
    p_venta_fisica_id INTEGER,
    p_venta_online_id INTEGER
) RETURNS TABLE (
    pago_id INTEGER,
    metodo_pago_id INTEGER,
    puntos_utilizados INTEGER,
    puntos_restantes INTEGER,
    monto_pago DECIMAL
) AS $$
DECLARE
    v_cliente_id INTEGER;
    v_puntos_disponibles INTEGER;
    v_valor_punto DECIMAL;
    v_monto_pago DECIMAL;
    v_metodo_pago_id INTEGER;
    v_pago_id INTEGER;
BEGIN
    -- Obtener cliente_id del usuario
    SELECT fk_cliente_id INTO v_cliente_id FROM usuario WHERE id = p_usuario_id;
    
    -- Obtener puntos disponibles y valor del punto
    SELECT puntos_disponibles, valor_punto INTO v_puntos_disponibles, v_valor_punto
    FROM obtener_info_puntos_usuario(p_usuario_id);
    
    -- Validar puntos disponibles
    IF v_puntos_disponibles < p_puntos_utilizados THEN
        RAISE EXCEPTION 'Puntos insuficientes: % disponibles, % solicitados', 
                        v_puntos_disponibles, p_puntos_utilizados;
    END IF;
    
    -- Calcular monto del pago
    v_monto_pago := p_puntos_utilizados * v_valor_punto;
    
    -- Crear método de pago tipo puntos
    INSERT INTO metodo_pago (fk_usuario, met_pag_tipo_pago)
    VALUES (p_usuario_id, 'puntos')
    RETURNING met_pag_id INTO v_metodo_pago_id;
    
    -- Registrar el pago
    INSERT INTO pago (pag_fecha, pag_monto, fk_metodo_pago, fk_venta_fisica, fk_venta_online, fk_moneda)
    VALUES (NOW(), v_monto_pago, v_metodo_pago_id, p_venta_fisica_id, p_venta_online_id, 1) -- Moneda 1 = Bolívares
    RETURNING pag_id INTO v_pago_id;
    
    -- Descontar puntos del cliente
    UPDATE cliente SET cli_puntos = cli_puntos - p_puntos_utilizados
    WHERE cli_id = v_cliente_id;
    
    -- Retornar resultados
    RETURN QUERY SELECT 
        v_pago_id, 
        v_metodo_pago_id, 
        p_puntos_utilizados, 
        (v_puntos_disponibles - p_puntos_utilizados),
        v_monto_pago;
END;
$$ LANGUAGE plpgsql;
```

## Validaciones y Seguridad

### 1. Validaciones Implementadas
- **Montos**: No exceder el total pendiente
- **Inventario**: Verificación continua de disponibilidad
- **Sesión**: Datos temporales que se limpian después del pago
- **Transacciones**: Operaciones atómicas en base de datos

### 2. Manejo de Errores
- **Rollback automático**: Si falla cualquier pago, se revierten todos
- **Validación previa**: Verificaciones antes de procesar
- **Mensajes claros**: Información específica sobre errores
- **Estado consistente**: El sistema nunca queda en estado inconsistente

### 3. Validaciones Específicas por Método
```python
def validate_payment_data(tipo_pago, data):
    """Valida los datos del método de pago"""
    errors = []
    
    if tipo_pago == 'efectivo':
        denominacion = data.get('denominacion')
        if not denominacion:
            errors.append('Denominación requerida para efectivo')
        else:
            try:
                denom_int = int(denominacion)
                if denom_int <= 0:
                    errors.append('La denominación debe ser mayor a 0')
            except (ValueError, TypeError):
                errors.append('Denominación inválida')
                
    elif tipo_pago == 'cheque':
        num_cheque = data.get('num_cheque', '').strip()
        if not num_cheque:
            errors.append('Número de cheque requerido')
        elif len(num_cheque) < 1:
            errors.append('El número de cheque debe tener al menos 1 carácter')
        elif len(num_cheque) > 50:
            errors.append('El número de cheque no puede exceder 50 caracteres')
                
    elif tipo_pago == 'tarjeta_debito':
        numero = data.get('numero', '').replace(' ', '')
        vencimiento = data.get('vencimiento')
        banco = data.get('banco', '').strip()
        
        if not numero:
            errors.append('Número de tarjeta de débito requerido')
            
        if not vencimiento:
            errors.append('Fecha de vencimiento requerida para tarjeta de débito')
        elif not validate_expiration_date(vencimiento):
            errors.append('La fecha de vencimiento de la tarjeta de débito no puede ser anterior a la fecha actual')
            
        if not banco or len(banco) < 2:
            errors.append('Nombre del banco requerido para tarjeta de débito')
            
    elif tipo_pago == 'tarjeta_credito':
        numero = data.get('numero', '').replace(' ', '')
        vencimiento = data.get('vencimiento')
        
        if not numero:
            errors.append('Número de tarjeta de crédito requerido')
            
        if not vencimiento:
            errors.append('Fecha de vencimiento requerida para tarjeta de crédito')
        elif not validate_expiration_date(vencimiento):
            errors.append('La fecha de vencimiento de la tarjeta de crédito no puede ser anterior a la fecha actual')
    
    return errors
```

## Compatibilidad y Mantenimiento

### 1. Sistema Original Mantenido
- **URL alternativa**: `/payment-method-original/` para un solo pago
- **Funciones legacy**: Todas las funciones originales se mantienen
- **Templates separados**: `payment_method_original.html` para compatibilidad

### 2. Migración Gradual
- **Por defecto**: El sistema usa múltiples métodos de pago
- **Fallback**: Disponible el sistema original si es necesario
- **Sin pérdida de funcionalidad**: Todo el código anterior sigue funcionando

## Instrucciones para Desarrolladores

### 1. Estructura de Archivos Clave
```
store/
  ├── views.py                    # Todas las funciones de backend
  ├── urls.py                     # Definición de rutas
  ├── templates/
  │   ├── payment_method.html     # Template principal (múltiples pagos)
  │   └── payment_method_original.html  # Template legacy (un solo pago)
  └── static/
      └── css/
          └── payment.css         # Estilos específicos para pagos
```

### 2. Implementación de Nuevas Funcionalidades
1. Mantener compatibilidad con ambos sistemas (múltiple y único)
2. Respetar la estructura de datos en sesión
3. Validar siempre antes de procesar
4. Usar transacciones atómicas para operaciones en BD
5. Documentar cambios en este archivo

### 3. Pruebas Recomendadas
1. **Prueba de combinaciones**: Diferentes monedas y métodos
2. **Prueba de límites**: Montos exactos y excedentes
3. **Prueba de errores**: Validar manejo de casos extremos
4. **Prueba de concurrencia**: Múltiples usuarios simultáneos

---

¡El sistema de múltiples métodos de pago está completamente implementado y listo para usar! 🎉 