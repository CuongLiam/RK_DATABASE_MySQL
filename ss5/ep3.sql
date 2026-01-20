CREATE DATABASE IF NOT EXISTS Ecomerce;
USE Ecomerce;

-- CREATE TABLE Products (
-- 	product_id VARCHAR(10) PRIMARY KEY,
--     product_name VARCHAR(50) NOT NULL,
-- 	price DECIMAL(10,2) NOT NULL,
--     stock INT NOT NULL,
--     status VARCHAR(20) NOT NULL
-- );

-- INSERT INTO Products VALUES
-- (1, 'Laptop Dell', 15000000, 10, 'active'),
-- (2, 'Chuột Logitech', 500000, 50, 'active'),
-- (3, 'Bàn phím cơ', 1200000, 20, 'active'),
-- (4, 'Màn hình Samsung', 3500000, 5, 'inactive'),
-- (5, 'Tai nghe Sony', 900000, 30, 'active');

-- SELECT * FROM Products;

-- SELECT * FROM Products WHERE status = 'active';

-- SELECT * FROM Products WHERE price > 1000000;

-- SELECT * FROM Products WHERE status = 'active'
-- ORDER BY price ASC;

CREATE TABLE Customers (
	customer_id INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    city VARCHAR(100),
    status VARCHAR(50)
);

INSERT INTO Customers VALUES
(1, 'Nguyen Van A', 'a@gmail.com', 'TP.HCM', 'active'),
(2, 'Tran Thi B', 'b@gmail.com', 'Ha Noi', 'active'),
(3, 'Le Van C', 'c@gmail.com', 'TP.HCM', 'inactive'),
(4, 'Pham Thi D', 'd@gmail.com', 'Ha Noi', 'active'),
(5, 'Hoang Van E', 'e@gmail.com', 'Da Nang', 'inactive');

SELECT * 
FROM customers;

SELECT * 
FROM customers
WHERE city = 'TP.HCM';

SELECT * 
FROM customers
WHERE status = 'active'
  AND city = 'Ha Noi';

SELECT * 
FROM customers
ORDER BY full_name ASC;