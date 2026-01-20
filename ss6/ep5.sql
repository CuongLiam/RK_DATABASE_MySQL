CREATE DATABASE sales_db;
USE sales_db;

CREATE TABLE products (
	product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE order_items (
	order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products VALUES
(1, 'Laptop', 15000000),
(2, 'Mouse', 300000),
(3, 'Keyboard', 700000),
(4, 'Monitor', 4000000),
(5, 'Headphone', 1200000);

INSERT INTO order_items VALUES
(101, 1, 2),
(101, 2, 3),
(102, 3, 1),
(103, 4, 2),
(104, 5, 4);

SELECT p.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT p.product_name, SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT p.product_name, SUM(p.price * oi.quantity) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(p.price * oi.quantity) > 5000000