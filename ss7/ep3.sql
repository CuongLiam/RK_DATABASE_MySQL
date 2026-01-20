USE test;

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-01', 150.00),
(2, '2024-01-03', 300.00),
(3, '2024-01-05', 120.00),
(4, '2024-01-06', 500.00),
(2, '2024-01-07', 250.00);

SELECT * FROM orders 
WHERE total_amount > (
	SELECT AVG(total_amount)
    FROM orders
);