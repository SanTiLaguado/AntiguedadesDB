-- Creación de la base de datos
CREATE DATABASE antiguedadesdb;
USE antiguedadesdb;

-- Tabla de roles
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación entre usuarios y roles
CREATE TABLE usuarios_roles (
    usuario_id INT NOT NULL,
    rol_id INT NOT NULL,
    CONSTRAINT fk_usuarios_roles_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_usuarios_roles_rol FOREIGN KEY (rol_id) REFERENCES roles(id),
    PRIMARY KEY (usuario_id, rol_id)
);

-- Tabla de categorías
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de estados de conservación
CREATE TABLE estados_conservacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de estatus de antigüedades
CREATE TABLE estatus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de antigüedades
CREATE TABLE antiguedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria_id INT NOT NULL,
    epoca VARCHAR(50),
    origen VARCHAR(100),
    estado_conservacion_id INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    estatus_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_antiguedades_categorias FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    CONSTRAINT fk_antiguedades_estados_conservacion FOREIGN KEY (estado_conservacion_id) REFERENCES estados_conservacion(id),
    CONSTRAINT fk_antiguedades_estatus FOREIGN KEY (estatus_id) REFERENCES estatus(id),
    CONSTRAINT fk_antiguedades_usuarios FOREIGN KEY (vendedor_id) REFERENCES usuarios(id)
);

-- Tabla de fotos de antigüedades
CREATE TABLE fotos_antiguedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    antiguedad_id INT NOT NULL,
    url_foto VARCHAR(255) NOT NULL,
    CONSTRAINT fk_fotos_antiguedades FOREIGN KEY (antiguedad_id) REFERENCES antiguedades(id)
);

-- Tabla de transacciones
CREATE TABLE transacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    antiguedad_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    comprador_id INT NOT NULL,
    precio_venta DECIMAL(10, 2) NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transacciones_antiguedades FOREIGN KEY (antiguedad_id) REFERENCES antiguedades(id),
    CONSTRAINT fk_transacciones_usuarios_vendedor FOREIGN KEY (vendedor_id) REFERENCES usuarios(id),
    CONSTRAINT fk_transacciones_usuarios_comprador FOREIGN KEY (comprador_id) REFERENCES usuarios(id)
);

-- Tabla del historial de precios
CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    antiguedad_id INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_precios_antiguedades FOREIGN KEY (antiguedad_id) REFERENCES antiguedades(id)
);

-- Tabla de visitas a las antigüedades
CREATE TABLE visitas_antiguedades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    antiguedad_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_visita DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_visitas_antiguedades_antiguedades FOREIGN KEY (antiguedad_id) REFERENCES antiguedades(id),
    CONSTRAINT fk_visitas_antiguedades_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla de inventario
CREATE TABLE inventario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    antiguedad_id INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventario_antiguedades FOREIGN KEY (antiguedad_id) REFERENCES antiguedades(id)
);

-- Tabla de estatus de pagos
CREATE TABLE estatus_pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de pagos
CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaccion_id INT NOT NULL,
    metodo_pago VARCHAR(50),
    estatus_pago_id INT NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pagos_transacciones FOREIGN KEY (transaccion_id) REFERENCES transacciones(id),
    CONSTRAINT fk_pagos_estatus_pagos FOREIGN KEY (estatus_pago_id) REFERENCES estatus_pagos(id)
);

-- Índices para optimizar consultas frecuentes
CREATE INDEX idx_antiguedades_categoria ON antiguedades(categoria_id);
CREATE INDEX idx_antiguedades_precio ON antiguedades(precio);
CREATE INDEX idx_transacciones_fecha ON transacciones(fecha_venta);
CREATE INDEX idx_visitas_antiguedades_fecha ON visitas_antiguedades(fecha_visita);
