CREATE DATABASE Ecomerce_DB;
USE Ecomerce_DB;

-- CREATE TABLE Customers (
-- 	customer_id INT PRIMARY KEY,
--     full_name VARCHAR(50) NOT NULL,
--     city VARCHAR(100) NOT NULL
-- );

-- CREATE TABLE Orders (
-- 	order_id INT PRIMARY KEY,
--     customer_id INT,
--     order_date DATE,
--     status VARCHAR(20),
--     FOREIGN KEY (customer_id)
-- 		REFERENCES Customers(customer_id)
-- );

-- INSERT INTO Customers VALUES
-- (1, 'Nguyen Van A', 'TP.HCM'),
-- (2, 'Tran Thi B', 'Ha Noi'),
-- (3, 'Le Van C', 'Da Nang'),
-- (4, 'Pham Thi D', 'TP.HCM'),
-- (5, 'Hoang Van E', 'Can Tho');

-- INSERT INTO Orders VALUES
-- (101, 1, '2024-01-10', 'completed'),
-- (102, 1, '2024-01-15', 'pending'),
-- (103, 2, '2024-02-01', 'completed'),
-- (104, 3, '2024-02-05', 'cancelled'),
-- (105, 1, '2024-02-10', 'completed');

-- SELECT o.order_id, o.order_date, o.status, c.full_name
-- FROM Orders o
-- JOIN Customers c ON o.customer_id = c.customer_id;

-- SELECT c.full_name, COUNT(o.order_id) AS total_orders
-- FROM Customers c
-- LEFT JOIN Orders o ON c.customer_id = o.customer_id
-- GROUP BY c.customer_id, c.full_name;

-- SELECT c.full_name, COUNT(o.order_id) AS total_orders
-- FROM Customers c
-- JOIN Orders o ON c.customer_id = o.customer_id
-- GROUP BY c.customer_id, c.full_name
-- HAVING COUNT(o.order_id) >= 1;

-- ALTER TABLE Orders
-- ADD total_amount DECIMAL(10,2);

-- UPDATE orders SET total_amount = 1500000 WHERE order_id = 101;
-- UPDATE orders SET total_amount = 800000  WHERE order_id = 102;
-- UPDATE orders SET total_amount = 1200000 WHERE order_id = 103;
-- UPDATE orders SET total_amount = 500000  WHERE order_id = 104;
-- UPDATE orders SET total_amount = 2000000 WHERE order_id = 105;

SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.full_name, MAX(o.total_amount) AS max_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;