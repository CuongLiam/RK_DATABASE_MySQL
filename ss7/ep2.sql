CREATE DATABASE IF NOT EXISTS test;
USE test;

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (name, email) VALUES
('Anna', 'anna@example.com'),
('Ben', 'ben@example.com'),
('Chris', 'chris@example.com'),
('David', 'david@example.com'),
('Emma', 'emma@example.com'),
('Frank', 'frank@example.com'),
('Grace', 'grace@example.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-05', 120.50),
(2, '2024-01-10', 300.00),
(1, '2024-01-11', 80.00),
(4, '2024-01-12', 150.75),
(5, '2024-01-13', 40.99),
(3, '2024-01-14', 210.10),
(2, '2024-01-15', 99.99);

SELECT * FROM customers
WHERE id IN (
	SELECT customer_id
    FROM orders
);