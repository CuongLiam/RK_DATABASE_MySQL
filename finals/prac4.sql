CREATE DATABASE IF NOT EXISTS Company_Management_prac4;
USE Company_Management_prac4;

-- Cleanup for re-run
DROP TRIGGER IF EXISTS trg_check_employee_limit;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Country;

-- =============================================================================
-- Câu 1 (2 điểm): Tạo các bảng và thêm dữ liệu
-- =============================================================================

-- Bảng Country
CREATE TABLE Country (
    country_id      INT PRIMARY KEY AUTO_INCREMENT,
    country_name    VARCHAR(100) NOT NULL UNIQUE
);

-- Bảng Location
CREATE TABLE Location (
    location_id     INT PRIMARY KEY AUTO_INCREMENT,
    street_address  VARCHAR(255) NOT NULL,
    postal_code     VARCHAR(20),
    country_id      INT NOT NULL,
    CONSTRAINT fk_location_country FOREIGN KEY (country_id) REFERENCES Country(country_id)
);

-- Bảng Employee
CREATE TABLE Employee (
    employee_id     INT PRIMARY KEY AUTO_INCREMENT,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    location_id     INT,
    CONSTRAINT fk_employee_location FOREIGN KEY (location_id) 
        REFERENCES Location(location_id) ON DELETE SET NULL
);

-- Thêm dữ liệu cho bảng Country
INSERT INTO Country (country_name) VALUES
('Viet Nam'),
('Thailand'),
('Singapore'),
('Japan');

-- Thêm dữ liệu cho bảng Location
INSERT INTO Location (street_address, postal_code, country_id) VALUES
('123 Le Loi, District 1', '700000', 1),      -- Viet Nam
('456 Nguyen Hue, District 1', '700001', 1),  -- Viet Nam
('789 Sukhumvit Road', '10110', 2),           -- Thailand
('321 Orchard Road', '238867', 3),            -- Singapore
('654 Shibuya', '150-0002', 4);               -- Japan

-- Thêm dữ liệu cho bảng Employee
INSERT INTO Employee (full_name, email, location_id) VALUES
('Nguyen Van A', 'nva@gmail.com', 1),
('Tran Thi B', 'ttb@gmail.com', 1),
('Le Van C', 'nn03@gmail.com', 2),
('Pham Thi D', 'ptd@gmail.com', 2),
('Hoang Van E', 'hve@gmail.com', 3),
('Vo Thi F', 'vtf@gmail.com', 4),
('Doan Van G', 'dvg@gmail.com', 5);

-- =============================================================================
-- Câu 2 (3 điểm): Truy vấn SQL
-- =============================================================================

-- a) Lấy tất cả nhân viên thuộc Việt Nam
SELECT e.employee_id, e.full_name, e.email, l.street_address
FROM Employee e
JOIN Location l ON e.location_id = l.location_id
JOIN Country c ON l.country_id = c.country_id
WHERE c.country_name = 'Viet Nam';

-- b) Lấy tên quốc gia của nhân viên có email "nn03@gmail.com"
SELECT c.country_name
FROM Employee e
JOIN Location l ON e.location_id = l.location_id
JOIN Country c ON l.country_id = c.country_id
WHERE e.email = 'nn03@gmail.com';

-- c) Thống kê mỗi quốc gia, mỗi location có bao nhiêu employee đang làm việc
SELECT 
    c.country_name AS Country,
    l.location_id AS LocationID,
    l.street_address AS Location,
    COUNT(e.employee_id) AS EmployeeCount
FROM Country c
LEFT JOIN Location l ON c.country_id = l.country_id
LEFT JOIN Employee e ON l.location_id = e.location_id
GROUP BY c.country_id, c.country_name, l.location_id, l.street_address
ORDER BY c.country_name, l.location_id;

-- =============================================================================
-- Câu 3 (2 điểm): Tạo TRIGGER
-- =============================================================================

DELIMITER $$

-- Trigger kiểm tra số lượng employee tối đa cho mỗi quốc gia
CREATE TRIGGER trg_check_employee_limit
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    DECLARE v_country_id INT;
    DECLARE v_employee_count INT;
    
    -- Lấy country_id từ location_id
    SELECT country_id INTO v_country_id
    FROM Location
    WHERE location_id = NEW.location_id;
    
    -- Đếm số employee hiện tại trong quốc gia đó
    SELECT COUNT(*) INTO v_employee_count
    FROM Employee e
    JOIN Location l ON e.location_id = l.location_id
    WHERE l.country_id = v_country_id;
    
    -- Kiểm tra nếu vượt quá 10 employee
    IF v_employee_count >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mỗi quốc gia chỉ được phép có tối đa 10 employee';
    END IF;
END $$

DELIMITER ;

-- =============================================================================
-- Câu 4 (3 điểm): Cấu hình CASCADE SET NULL
-- =============================================================================
-- Đã cấu hình ON DELETE SET NULL trong bảng Employee tại Câu 1
-- Khi xóa location, location_id của employee sẽ tự động được set NULL

-- =============================================================================
-- TEST CÁC CHỨC NĂNG
-- =============================================================================

-- Test Trigger (thêm nhiều employee vào cùng 1 quốc gia)
-- INSERT INTO Employee (full_name, email, location_id) VALUES
-- ('Test 1', 'test1@gmail.com', 1),
-- ('Test 2', 'test2@gmail.com', 1),
-- ('Test 3', 'test3@gmail.com', 1),
-- ('Test 4', 'test4@gmail.com', 1),
-- ('Test 5', 'test5@gmail.com', 1),
-- ('Test 6', 'test6@gmail.com', 1),
-- ('Test 7', 'test7@gmail.com', 1),
-- ('Test 8', 'test8@gmail.com', 1);  -- Sẽ báo lỗi nếu tổng > 10

-- Test SET NULL (xóa location và kiểm tra employee)
-- DELETE FROM Location WHERE location_id = 1;
-- SELECT * FROM Employee;  -- Kiểm tra location_id của các employee trước đó có = 1

-- End of script
