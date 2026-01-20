CREATE DATABASE Ecomerce_DB;
USE Ecomerce_DB;

CREATE TABLE Customers (
	customer_id INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE Orders (
	order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id)
		REFERENCES Customers(customer_id)
);

INSERT INTO Customers VALUES
(1, 'Nguyen Van A', 'TP.HCM'),
(2, 'Tran Thi B', 'Ha Noi'),
(3, 'Le Van C', 'Da Nang'),
(4, 'Pham Thi D', 'TP.HCM'),
(5, 'Hoang Van E', 'Can Tho');

INSERT INTO Orders VALUES
(101, 1, '2024-01-10', 'completed'),
(102, 1, '2024-01-15', 'pending'),
(103, 2, '2024-02-01', 'completed'),
(104, 3, '2024-02-05', 'cancelled'),
(105, 1, '2024-02-10', 'completed');

SELECT o.order_id, o.order_date, o.status, c.full_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

SELECT c.full_name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.full_name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;