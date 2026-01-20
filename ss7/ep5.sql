USE test;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO customers (name, email) VALUES
('Anna', 'anna@example.com'),
('Ben', 'ben@example.com'),
('Chris', 'chris@example.com'),
('David', 'david@example.com'),
('Emma', 'emma@example.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-01', 150.00),
(2, '2024-01-03', 300.00),
(1, '2024-01-05', 120.00),
(4, '2024-01-06', 500.00),
(2, '2024-01-07', 250.00);

SELECT name, (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.id) AS total_orders 
FROM customers;