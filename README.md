# 🍺 ACAUCAB · Sistema de gestión para cerveceros artesanales

Sistema web para la **Asociación de Cerveceros Artesanales**: tienda online y física, eventos, inventario, compras a proveedores y un panel de indicadores para la gerencia. Proyecto universitario de bases de datos en la UCAB, con buena parte de la lógica de negocio escrita directamente en **PostgreSQL** (funciones, triggers y procedimientos).

Hecho en equipo por [@latmedina](https://github.com/latmedina), [@DanCas03](https://github.com/DanCas03) y [@LevinJimenez](https://github.com/LevinJimenez).

## Qué hace

**Ventas**
- Tienda online y tienda física con carrito, más un modo **autopago** para que el cliente compre solo en tienda.
- **Pagos combinados**: una misma compra se puede pagar mezclando efectivo, cheque, tarjeta de débito o crédito y puntos, cada uno en su moneda. El sistema convierte todo a bolívares con el histórico de tasas y muestra en tiempo real cuánto falta. Detalle en [MULTIPLE_PAYMENTS_GUIDE.md](MULTIPLE_PAYMENTS_GUIDE.md).
- **Programa de puntos**: los clientes acumulan puntos con cada compra y los usan como método de pago.
- **Eventos** cerveceros con venta de entradas y de productos dentro del evento.
- Historial de compras por cliente y factura de cada venta.

**Operaciones**
- **Inventario** por tienda, almacén y anaquel. Cada venta descuenta stock con triggers y, cuando un producto baja del mínimo, se genera sola una **solicitud de reposición**.
- **Órdenes de compra** a proveedores con flujo de estados: pendiente, aprobada, entregada.
- **Roles y privilegios** configurables para empleados, más registro de clientes, empleados y proveedores.

**Gerencia**
- **Dashboard de KPIs**: ventas por tienda y por estilo de cerveza, ticket promedio, crecimiento, clientes nuevos vs. recurrentes, retención, rotación de inventario, ruptura de stock y productos más vendidos.
- **Reportes en PDF** con jsreport: facturas, órdenes de compra, eficiencia de despacho, histórico de ofertas, incumplimiento de horarios y más.

## Stack

| | |
|---|---|
| Backend | Python · Django 5 |
| Base de datos | PostgreSQL: unas 80 tablas, más de 50 funciones en PL/pgSQL y triggers |
| Frontend | Plantillas de Django · JavaScript · CSS |
| Reportes | jsreport (Node.js) |

## Estructura

```
.
├── BD/               # create.sql, insert.sql y drop.sql del modelo
├── SQL/              # funciones, procedimientos y triggers (inicializar.sql los carga todos)
├── store/            # tienda, carrito, pagos, usuarios y eventos
├── empleados/        # dashboard, KPIs, reportes, roles, inventario y compras
├── ecommerce/        # configuración de Django
└── jsreport-server/  # servidor de plantillas para los PDF
```

## Correr en local

Requisitos: Python 3.12+, PostgreSQL y Node.js (solo para los reportes).

**1. Base de datos**

```bash
createdb ACAUCAB
psql -d ACAUCAB -f BD/create.sql
psql -d ACAUCAB -f BD/insert.sql
cd SQL && psql -d ACAUCAB -f inicializar.sql   # funciones, procedimientos y triggers
```

**2. Variables de entorno**

```bash
export DB_NAME=ACAUCAB
export DB_USER=postgres
export DB_PASSWORD=tu_contraseña
export DJANGO_SECRET_KEY=$(python -c "import secrets; print(secrets.token_urlsafe(50))")
```

**3. Django**

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python manage.py runserver        # http://localhost:8000
```

**4. Reportes (opcional)**

```bash
npm install
npm start                         # jsreport en http://localhost:5488
```
