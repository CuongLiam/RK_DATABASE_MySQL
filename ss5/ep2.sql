CREATE DATABASE IF NOT EXISTS Ecomerce;
USE Ecomerce;

CREATE TABLE Products (
	product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
	price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    status VARCHAR(20) NOT NULL
);

INSERT INTO Products VALUES
(1, 'Laptop Dell', 15000000, 10, 'active'),
(2, 'Chuột Logitech', 500000, 50, 'active'),
(3, 'Bàn phím cơ', 1200000, 20, 'active'),
(4, 'Màn hình Samsung', 3500000, 5, 'inactive'),
(5, 'Tai nghe Sony', 900000, 30, 'active');

SELECT * FROM Products;

SELECT * FROM Products WHERE status = 'active';

SELECT * FROM Products WHERE price > 1000000;

SELECT * FROM Products WHERE status = 'active'
ORDER BY price ASC;