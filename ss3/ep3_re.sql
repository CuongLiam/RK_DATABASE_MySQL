CREATE DATABASE ss3ep3;
USE ss3ep3;

CREATE TABLE Student(
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(10) NOT NULL,
    email VARCHAR(255) UNIQUE,
    dob DATE NOT NULL
);

INSERT INTO Student (full_name, email, dob) VALUES 
('Nguyen Van A', 'abc1@example.com', '2005-12-31'),
('Nguyen Van B', 'abc2@example.com', '2005-12-31'),
('Nguyen Van C', 'abc3@example.com', '2005-12-31');

-- Cập nhật email cho một sinh viên cụ thể
UPDATE Student
SET email = 'updatedEmail@gmail.com'
WHERE student_id = 3;

-- Cập nhật ngày sinh cho một sinh viên khác
UPDATE Student
SET dob = '1999-12-31'
WHERE student_id = 2;

-- Xóa một sinh viên đã nhập nhầm
DELETE Student
WHERE student_id = 5;


-- Kiểm tra lại dữ liệu bằng SELECT
SELECT * FROM Student;
