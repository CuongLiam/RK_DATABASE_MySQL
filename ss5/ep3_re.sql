CREATE DATABASE ss5ep3;
USE ss5ep3;

CREATE TABLE statusTable (
    status_id INT PRIMARY KEY,
    status VARCHAR(10) NOT NULL UNIQUE
);

INSERT INTO statusTable (status_id, status) VALUES
(0, 'inactive'),
(1, 'active');

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255),
    status INT NOT NULL DEFAULT 0,

    CONSTRAINT fk_customers_statusTable FOREIGN KEY (status) REFERENCES statusTable(status_id)
);

INSERT INTO customers (full_name, email, city, status) VALUES
('David brown', 'david@gmail.com', 'TP.HCM', 1),
('alice robinson', 'alice@gmail.com', 'texas', 0),
('marques downey', 'ok@gmail.com', 'washington dc', 1);

SELECT *
FROM customers;

SELECT c.full_name, c.email, c.city, s.status
FROM customers c
JOIN statusTable s ON c.status = s.status_id
WHERE c.city = 'TP.HCM';

SELECT *
FROM customers
WHERE city = 'texas' AND status = 1;

SELECT *
FROM customers
ORDER BY full_name ASC;

