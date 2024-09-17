-- Insertar datos iniciales
INSERT INTO roles (nombre) 
VALUES 
('vendedor'),
('comprador'),
('administrador');

-- Inserción en la tabla categorias
INSERT INTO categorias (nombre) 
VALUES 
('Muebles'), 
('Joyería'), 
('Pintura'), 
('Escultura');

-- Inserción en la tabla estados_conservacion
INSERT INTO estados_conservacion (nombre) 
VALUES 
('excelente'), 
('bueno'), 
('regular'), 
('malo');

-- Inserción en la tabla estatus
INSERT INTO estatus (nombre) 
VALUES 
('en venta'), 
('vendido'), 
('retirado');

-- Inserción en la tabla estatus_pagos
INSERT INTO estatus_pagos (nombre) 
VALUES 
('pendiente'), 
('completado');


-- Insertar usuarios de ejemplo
INSERT INTO usuarios (nombre, email, password) 
VALUES 
('Juan Pérez', 'juan.perez@example.com', 'password123'),
('Ana Gómez', 'ana.gomez@example.com', 'password123'),
('Luis Martínez', 'luis.martinez@example.com', 'password123');

-- Asignar roles a usuarios
INSERT INTO usuarios_roles (usuario_id, rol_id) 
VALUES 
(1, 1),
(2, 2),
(3, 2); 

-- Insertar antigüedades de ejemplo
INSERT INTO antiguedades (nombre, descripcion, categoria_id, epoca, origen, estado_conservacion_id, precio, estatus_id, vendedor_id) 
VALUES 
('Silla Victoriana', 'Silla antigua del estilo victoriano, en buen estado.', 1, 'Siglo XIX', 'Reino Unido', 2, 1500.00, 1, 1),
('Collar de Rubíes', 'Collar antiguo con rubíes incrustados.', 2, 'Siglo XX', 'Francia', 1, 3000.00, 1, 1),
('Retrato de la Familia Real', 'Pintura del siglo XVIII de la familia real.', 3, 'Siglo XVIII', 'España', 3, 5000.00, 1, 1);

-- Insertar fotos de antigüedades de ejemplo
INSERT INTO fotos_antiguedades (antiguedad_id, url_foto) 
VALUES 
(1, 'http://antiguedadescampus.com/fotos/silla_victoriana.jpg'),
(2, 'http://antiguedadescampus.com/fotos/collar_rubies.jpg'),
(3, 'http://antiguedadescampus.com/fotos/retrato_familia_real.jpg');

-- Insertar transacciones de ejemplo
INSERT INTO transacciones (antiguedad_id, vendedor_id, comprador_id, precio_venta, fecha_venta) 
VALUES 
(1, 1, 2, 1500.00, '2024-09-15 10:00:00'),
(2, 1, 3, 3000.00, '2024-09-16 15:00:00');

-- Insertar historial de precios de ejemplo
INSERT INTO historial_precios (antiguedad_id, precio, fecha_cambio) 
VALUES 
(1, 1500.00, '2024-09-01 00:00:00'),
(2, 3200.00, '2024-09-05 00:00:00');

-- Insertar visitas a antigüedades de ejemplo
INSERT INTO visitas_antiguedades (antiguedad_id, usuario_id, fecha_visita) 
VALUES 
(1, 2, '2024-09-14 14:00:00'),
(2, 3, '2024-09-16 16:00:00'),
(3, 2, '2024-09-17 09:00:00');

-- Insertar inventario de ejemplo
INSERT INTO inventario (antiguedad_id, cantidad, fecha_actualizacion) 
VALUES 
(1, 5, '2024-09-01 00:00:00'),
(2, 2, '2024-09-01 00:00:00'),
(3, 1, '2024-09-01 00:00:00');

-- Insertar pagos de ejemplo
INSERT INTO pagos (transaccion_id, metodo_pago, estatus_pago_id, fecha_pago) 
VALUES 
(1, 'tarjeta de crédito', 2, '2024-09-15 10:05:00'),
(2, 'transferencia bancaria', 2, '2024-09-16 15:10:00');

-- Consultas (Procedimientos Almacenados)

-- 1. Listar todas las antigüedades disponibles para la venta
DELIMITER //
CREATE PROCEDURE ListarAntiguedadesDisponibles()
BEGIN
    SELECT 
        a.nombre AS nombre_antiguedad, 
        c.nombre AS categoria, 
        a.precio, 
        e.nombre AS estado_conservacion
    FROM 
        antiguedades a
    JOIN 
        categorias c ON a.categoria_id = c.id
    JOIN 
        estados_conservacion e ON a.estado_conservacion_id = e.id
    WHERE 
        a.estatus_id = 1;
END //
DELIMITER ;

-- 2. Buscar antigüedades por categoría y rango de precio
DELIMITER //
CREATE PROCEDURE BuscarAntiguedadesPorCategoriaYRango(
    IN categoria_nombre VARCHAR(50),
    IN precio_min DECIMAL(10, 2),
    IN precio_max DECIMAL(10, 2)
)
BEGIN
    SELECT 
        a.nombre AS nombre_antiguedad, 
        a.precio
    FROM 
        antiguedades a
    JOIN 
        categorias c ON a.categoria_id = c.id
    WHERE 
        c.nombre = categoria_nombre
        AND a.precio BETWEEN precio_min AND precio_max;
END //
DELIMITER ;

-- 3. Mostrar el historial de ventas de un cliente específico
DELIMITER //
CREATE PROCEDURE MostrarHistorialVentasCliente(
    IN cliente_id INT
)
BEGIN
    SELECT 
        a.nombre AS nombre_antiguedad, 
        t.fecha_venta, 
        t.precio_venta, 
        u.nombre AS comprador
    FROM 
        transacciones t
    JOIN 
        antiguedades a ON t.antiguedad_id = a.id
    JOIN 
        usuarios u ON t.comprador_id = u.id
    WHERE 
        u.id = cliente_id;
END //
DELIMITER ;

-- 4. Obtener el total de ventas realizadas en un periodo de tiempo
DELIMITER //
CREATE PROCEDURE ObtenerTotalVentas(
    IN fecha_inicio DATETIME,
    IN fecha_fin DATETIME
)
BEGIN
    SELECT 
        SUM(t.precio_venta) AS total_ventas
    FROM 
        transacciones t
    WHERE 
        t.fecha_venta BETWEEN fecha_inicio AND fecha_fin;
END //
DELIMITER ;

-- 5. Encontrar los clientes más activos
DELIMITER //
CREATE PROCEDURE ClientesMasActivos()
BEGIN
    SELECT 
        u.nombre AS cliente, 
        COUNT(t.id) AS cantidad_compras
    FROM 
        transacciones t
    JOIN 
        usuarios u ON t.comprador_id = u.id
    GROUP BY 
        u.id
    ORDER BY 
        cantidad_compras DESC;
END //
DELIMITER ;

-- 6. Listar las antigüedades más populares por número de visitas
DELIMITER //
CREATE PROCEDURE ListarAntiguedadesPopulares()
BEGIN
    SELECT 
        a.nombre AS nombre_antiguedad, 
        COUNT(v.id) AS cantidad_visitas
    FROM 
        visitas_antiguedades v
    JOIN 
        antiguedades a ON v.antiguedad_id = a.id
    GROUP BY 
        a.id
    ORDER BY 
        cantidad_visitas DESC;
END //
DELIMITER ;

-- 7. Listar las antigüedades vendidas en un rango de fechas específico
DELIMITER //
CREATE PROCEDURE ListarAntiguedadesVendidas(
    IN fecha_inicio DATETIME,
    IN fecha_fin DATETIME
)
BEGIN
    SELECT 
        a.nombre AS nombre_antiguedad, 
        t.fecha_venta, 
        u_v.nombre AS vendedor, 
        u_c.nombre AS comprador
    FROM 
        transacciones t
    JOIN 
        antiguedades a ON t.antiguedad_id = a.id
    JOIN 
        usuarios u_v ON t.vendedor_id = u_v.id
    JOIN 
        usuarios u_c ON t.comprador_id = u_c.id
    WHERE 
        t.fecha_venta BETWEEN fecha_inicio AND fecha_fin;
END //
DELIMITER ;

-- 8. Obtener un informe de inventario actual
DELIMITER //
CREATE PROCEDURE ObtenerInformeInventario()
BEGIN
    SELECT 
        a.nombre AS nombre_antiguedad, 
        i.cantidad
    FROM 
        inventario i
    JOIN 
        antiguedades a ON i.antiguedad_id = a.id;
END //
DELIMITER ;
