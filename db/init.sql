CREATE DATABASE IF NOT EXISTS appdb;

USE appdb;

CREATE TABLE IF NOT EXISTS prueba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(255)
);

INSERT INTO prueba (mensaje) VALUES ('Hola desde Docker!'), ('Prueba JDBC');