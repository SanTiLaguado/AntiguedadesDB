# Proyecto de Base de Datos para el Negocio de Antigüedades

## Descripción

Este proyecto se centra en el desarrollo de una base de datos para un negocio de antigüedades. La solución incluye la gestión de usuarios, catálogo de antigüedades, transacciones, inventario, visitas, y pagos. La base de datos está diseñada para ser eficiente, segura y escalable, con datos normalizados hasta la Cuarta Forma Normal (4NF).

## Estructura de la Base de Datos

### Tablas

- **roles**: Almacena los diferentes roles de usuario (vendedor, comprador, administrador).
- **usuarios**: Contiene información sobre los usuarios del sistema.
- **usuarios_roles**: Relaciona usuarios con roles.
- **categorias**: Define las categorías disponibles para las antigüedades.
- **estados_conservacion**: Define los estados de conservación de las antigüedades.
- **estatus**: Indica el estatus de las antigüedades (en venta, vendido, retirado).
- **antiguedades**: Almacena información sobre las antigüedades, incluyendo su estado, precio, y vendedor.
- **fotos_antiguedades**: Contiene URLs de las fotos asociadas a cada antigüedad.
- **transacciones**: Registra las transacciones de compra y venta de antigüedades.
- **historial_precios**: Guarda el historial de precios de las antigüedades.
- **visitas_antiguedades**: Registra las visitas a las antigüedades por los usuarios.
- **inventario**: Gestiona el inventario de antigüedades disponible.
- **estatus_pagos**: Define los estatus de los pagos (pendiente, completado).
- **pagos**: Registra los pagos asociados a las transacciones.

### Procedimientos Almacenados

1. **ListarAntiguedadesDisponibles**: Obtiene una lista de todas las antigüedades disponibles para la venta.
2. **BuscarAntiguedadesPorCategoriaYRango**: Busca antigüedades dentro de una categoría específica y rango de precio.
3. **MostrarHistorialVentasCliente**: Muestra el historial de ventas de un cliente específico.
4. **ObtenerTotalVentas**: Calcula el total de ventas realizadas en un periodo específico.
5. **ClientesMasActivos**: Identifica los clientes con mayor cantidad de compras.
6. **ListarAntiguedadesPopulares**: Muestra las antigüedades más populares por número de visitas.
7. **ListarAntiguedadesVendidas**: Obtiene una lista de antigüedades vendidas en un rango de fechas específico.
8. **ObtenerInformeInventario**: Genera un informe del inventario actual de antigüedades.

## Instalación

1. **Clonar el repositorio**:

2. **Crear la base de datos**:

    Ejecuta el archivo `DDL.sql` en tu servidor MySQL para crear la base de datos y las tablas.

3. **Insertar datos iniciales y Crear Procedimientos Almacenados**:

    Ejecuta el archivo `DML.sql` para agregar datos de ejemplo y crear los procedimientos Almacenados.

## Uso

Para invocar los procedimientos almacenados y consultar la base de datos, usa las siguientes consultas SQL:

```sql
-- Listar todas las antigüedades disponibles para la venta
CALL ListarAntiguedadesDisponibles();

-- Buscar antigüedades por categoría y rango de precio
CALL BuscarAntiguedadesPorCategoriaYRango('Muebles', 500.00, 2000.00);

-- Mostrar el historial de ventas de un cliente específico
CALL MostrarHistorialVentasCliente(2);

-- Obtener el total de ventas realizadas en un periodo de tiempo
CALL ObtenerTotalVentas('2024-09-01 00:00:00', '2024-09-30 23:59:59');

-- Encontrar los clientes más activos
CALL ClientesMasActivos();

-- Listar las antigüedades más populares por número de visitas
CALL ListarAntiguedadesPopulares();

-- Listar las antigüedades vendidas en un rango de fechas específico
CALL ListarAntiguedadesVendidas('2024-09-01 00:00:00', '2024-09-30 23:59:59');

-- Obtener un informe de inventario actual
CALL ObtenerInformeInventario();
