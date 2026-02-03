CREATE DATABASE ss5ep2;
USE ss5ep2;

CREATE TABLE statusTable (
    status_id INT PRIMARY KEY,
    status VARCHAR(10) NOT NULL UNIQUE
);

INSERT INTO statusTable (status_id, status) VALUES
(0, 'inactive'),
(1, 'active');

CREATE TABLE products(
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    status INT NOT NULL DEFAULT 0,
    
    CONSTRAINT fk_products_status FOREIGN KEY (status) REFERENCES statusTable(status_id)
);

INSERT INTO products (product_name, price, stock, status) VALUES
('iphone 15', 999.99, 200, 1),
('gg pixel', 888.99, 100, 1),
('galaxy z', 900.99, 600, 0);

SELECT *
FROM products;

SELECT p.product_name, price, s.status
FROM products p
JOIN statusTable s ON s.status_id = p.status;

SELECT * 
FROM products
WHERE status = 1;

SELECT *
FROM products
WHERE price > 900;

SELECT * 
FROM products
WHERE status = 1
ORDER BY price ASC;