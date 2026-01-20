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

-- CREATE TABLE Customers (
--     customer_id INT PRIMARY KEY,
--     full_name VARCHAR(50) NOT NULL,
--     email VARCHAR(50) UNIQUE NOT NULL,
--     city VARCHAR(100),
--     status VARCHAR(50)
-- );

-- INSERT INTO Customers VALUES
-- (1, 'Nguyen Van A', 'a@gmail.com', 'TP.HCM', 'active'),
-- (2, 'Tran Thi B', 'b@gmail.com', 'Ha Noi', 'active'),
-- (3, 'Le Van C', 'c@gmail.com', 'TP.HCM', 'inactive'),
-- (4, 'Pham Thi D', 'd@gmail.com', 'Ha Noi', 'active'),
-- (5, 'Hoang Van E', 'e@gmail.com', 'Da Nang', 'inactive');

-- SELECT * 
-- FROM customers;

-- SELECT * 
-- FROM customers
-- WHERE city = 'TP.HCM';

-- SELECT * 
-- FROM customers
-- WHERE status = 'active'
--   AND city = 'Ha Noi';

-- SELECT * 
-- FROM customers
-- ORDER BY full_name ASC;

CREATE TABLE Orders (
	order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL
);

INSERT INTO orders VALUES
(1, 101, 3000000, '2025-01-01', 'pending'),
(2, 102, 7500000, '2025-01-03', 'completed'),
(3, 103, 12000000, '2025-01-05', 'completed'),
(4, 104, 4500000, '2025-01-07', 'cancelled'),
(5, 105, 9000000, '2025-01-10', 'completed'),
(6, 106, 2000000, '2025-01-12', 'pending');

SELECT *
FROM orders
WHERE status = 'completed';

SELECT *
FROM orders
WHERE total_amount > 5000000;

SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;

SELECT *
FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;