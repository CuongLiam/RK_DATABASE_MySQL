CREATE DATABASE IF NOT EXISTS Hakathon_Students_prac1;
USE Hakathon_Students_prac1;

-- Cleanup for re-run
DROP VIEW IF EXISTS vw_enrollment_stats;
DROP TRIGGER IF EXISTS trg_enrollment_completed_log;
DROP TRIGGER IF EXISTS trg_enrollment_completed_credits;
DROP TABLE IF EXISTS Course_Log;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Student_Profiles;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;

-- PHẦN 1: THIẾT KẾ CSDL & DỮ LIỆU ------------------------------------------------
-- 1.1 Tạo bảng
CREATE TABLE Students (
	student_id      VARCHAR(10) PRIMARY KEY,
	full_name       VARCHAR(100) NOT NULL,
	email           VARCHAR(100) NOT NULL UNIQUE,
	phone           VARCHAR(20),
	total_credits   INT NOT NULL DEFAULT 0,
	CONSTRAINT chk_students_total_credits CHECK (total_credits >= 0)
);

CREATE TABLE Student_Profiles (
	profile_id   INT AUTO_INCREMENT PRIMARY KEY,
	student_id   VARCHAR(10) NOT NULL,
	address      VARCHAR(255),
	birthday     DATE,
	citizen_id   VARCHAR(20) UNIQUE,
	CONSTRAINT fk_profiles_student FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE Courses (
	course_id       VARCHAR(10) PRIMARY KEY,
	course_name     VARCHAR(150) NOT NULL,
	fee             DECIMAL(12,2) NOT NULL,
	duration_hours  INT NOT NULL,
	status          VARCHAR(20) NOT NULL,
	CONSTRAINT chk_courses_fee CHECK (fee > 0),
	CONSTRAINT chk_courses_duration CHECK (duration_hours > 0),
	CONSTRAINT chk_courses_status CHECK (status IN ('Active', 'Inactive', 'Closed'))
);

CREATE TABLE Enrollments (
	enrollment_id   INT AUTO_INCREMENT PRIMARY KEY,
	student_id      VARCHAR(10) NOT NULL,
	course_id       VARCHAR(10) NOT NULL,
	enrollment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	total_fee       DECIMAL(12,2) NOT NULL,
	status          VARCHAR(20) NOT NULL,
	CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
	CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES Courses(course_id),
	CONSTRAINT chk_enroll_fee CHECK (total_fee >= 0),
	CONSTRAINT chk_enroll_status CHECK (status IN ('Pending', 'Completed', 'Cancelled'))
);

CREATE TABLE Course_Log (
	log_id      INT AUTO_INCREMENT PRIMARY KEY,
	course_id   VARCHAR(10) NOT NULL,
	change_note VARCHAR(255) NOT NULL,
	change_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fk_log_course FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 1.2 Chèn dữ liệu (>=5 dòng mỗi bảng)
INSERT INTO Students (student_id, full_name, email, phone, total_credits) VALUES
('S001', 'Nguyen Minh Chau', 'chau.s001@gmail.com', '0900000001', 12),
('S002', 'Tran Thi Bich', 'bich.s002@gmail.com', '0900000002', 6),
('S003', 'Le Hoang Phuc', 'phuc.s003@gmail.com', '0900000003', 0),
('S004', 'Pham Gia Han', 'han.s004@gmail.com', '0900000004', 18),
('S005', 'Doan Nhat Cuong', 'cuong.s005@gmail.com', '0900000005', 24);

INSERT INTO Student_Profiles (student_id, address, birthday, citizen_id) VALUES
('S001', 'Hanoi', '2000-04-12', '012345678901'),
('S002', 'Ho Chi Minh', '2001-06-18', '012345678902'),
('S003', 'Da Nang', '2002-08-25', '012345678903'),
('S004', 'Hue', '1999-12-30', '012345678904'),
('S005', 'Hai Phong', '1998-10-05', '012345678905');

INSERT INTO Courses (course_id, course_name, fee, duration_hours, status) VALUES
('C001', 'Data Analysis with SQL', 12000000, 40, 'Active'),
('C002', 'Backend with NodeJS', 18000000, 60, 'Active'),
('C003', 'Frontend React', 15000000, 55, 'Inactive'),
('C004', 'Cloud Fundamentals', 9000000, 30, 'Active'),
('C005', 'AI for Everyone', 22000000, 50, 'Closed');

INSERT INTO Enrollments (student_id, course_id, total_fee, status, enrollment_date) VALUES
('S001', 'C001', 12000000, 'Completed', '2024-01-10 09:00:00'),
('S002', 'C002', 18000000, 'Pending',   '2024-02-15 10:30:00'),
('S003', 'C003', 15000000, 'Cancelled', '2023-12-01 14:00:00'),
('S004', 'C004',  9000000, 'Completed', '2024-03-02 08:15:00'),
('S005', 'C005', 22000000, 'Completed', '2024-04-20 11:45:00'),
('S001', 'C002', 18000000, 'Completed', '2024-05-01 12:00:00');

INSERT INTO Course_Log (course_id, change_note, change_date) VALUES
('C001', 'Initial creation', '2022-06-01 00:00:00'),
('C002', 'Initial creation', '2022-06-02 00:00:00'),
('C003', 'Initial creation', '2022-06-03 00:00:00'),
('C004', 'Initial creation', '2022-06-04 00:00:00'),
('C005', 'Initial creation', '2022-06-05 00:00:00');

-- 1.3 DML yêu cầu
-- Cộng 10 tín chỉ cho học viên có tổng tiền Completed > 30,000,000
UPDATE Students s
SET total_credits = total_credits + 10
WHERE s.student_id IN (
	SELECT student_id
	FROM Enrollments e
	WHERE e.status = 'Completed'
	GROUP BY student_id
	HAVING SUM(e.total_fee) > 30000000
);

-- Xóa log trước năm 2023
DELETE FROM Course_Log
WHERE change_date < '2023-01-01';

-- PHẦN 2: TRUY VẤN CƠ BẢN --------------------------------------------------------
-- Lọc khóa học theo phí, thời lượng hoặc trạng thái
SELECT course_id, course_name, fee, duration_hours, status
FROM Courses
WHERE (fee BETWEEN 10000000 AND 20000000)
   OR duration_hours >= 50
   OR status = 'Active';

-- Lọc học viên theo email gmail và tín chỉ >= 10
SELECT student_id, full_name, email, total_credits
FROM Students
WHERE email LIKE '%@gmail.com' AND total_credits >= 10;

-- Lấy 3 đơn đăng ký giá trị cao nhất (LIMIT + OFFSET)
SELECT enrollment_id, student_id, course_id, total_fee, status
FROM Enrollments
ORDER BY total_fee DESC
LIMIT 3 OFFSET 0;

-- PHẦN 3: TRUY VẤN NÂNG CAO -------------------------------------------------------
-- JOIN 3 bảng Students – Profiles – Enrollments
SELECT s.student_id, s.full_name, sp.address, e.enrollment_id, e.course_id, e.total_fee, e.status
FROM Students s
JOIN Student_Profiles sp ON sp.student_id = s.student_id
JOIN Enrollments e ON e.student_id = s.student_id;

-- GROUP BY + HAVING tổng tiền Completed
SELECT e.student_id, s.full_name, SUM(e.total_fee) AS total_completed_fee
FROM Enrollments e
JOIN Students s ON s.student_id = e.student_id
WHERE e.status = 'Completed'
GROUP BY e.student_id, s.full_name
HAVING SUM(e.total_fee) >= 20000000;

-- Subquery tìm khóa học có học phí cao nhất đã phát sinh giao dịch
SELECT c.course_id, c.course_name, c.fee
FROM Courses c
WHERE c.course_id IN (
	SELECT e.course_id
	FROM Enrollments e
	WHERE e.status IN ('Pending', 'Completed', 'Cancelled')
)
AND c.fee = (
	SELECT MAX(c2.fee)
	FROM Courses c2
	WHERE EXISTS (SELECT 1 FROM Enrollments e2 WHERE e2.course_id = c2.course_id)
);

-- PHẦN 4: INDEX & VIEW -----------------------------------------------------------
-- Composite Index
CREATE INDEX idx_enrollments_status_date ON Enrollments(status, enrollment_date);

-- View thống kê số đơn và tổng tiền học theo học viên
CREATE OR REPLACE VIEW vw_enrollment_stats AS
SELECT e.student_id,
	   COUNT(*) AS enrollment_count,
	   SUM(e.total_fee) AS total_fee_sum
FROM Enrollments e
GROUP BY e.student_id;

-- PHẦN 5: TRIGGER ----------------------------------------------------------------
DELIMITER $$

-- Trigger ghi log khi đơn hoàn thành
CREATE TRIGGER trg_enrollment_completed_log
AFTER UPDATE ON Enrollments
FOR EACH ROW
BEGIN
	IF NEW.status = 'Completed' AND OLD.status <> 'Completed' THEN
		INSERT INTO Course_Log (course_id, change_note)
		VALUES (NEW.course_id, CONCAT('Enrollment ', NEW.enrollment_id, ' completed'));
	END IF;
END $$

-- Trigger cộng tín chỉ theo tổng tiền (1 tín chỉ mỗi 3,000,000)
CREATE TRIGGER trg_enrollment_completed_credits
AFTER UPDATE ON Enrollments
FOR EACH ROW
BEGIN
	IF NEW.status = 'Completed' AND OLD.status <> 'Completed' THEN
		UPDATE Students
		SET total_credits = total_credits + FLOOR(NEW.total_fee / 3000000)
		WHERE student_id = NEW.student_id;
	END IF;
END $$

DELIMITER ;

-- PHẦN 6: STORED PROCEDURE -------------------------------------------------------
DELIMITER $$

-- Procedure kiểm tra trạng thái khóa học
CREATE PROCEDURE sp_check_course_status(IN p_course_id VARCHAR(10))
BEGIN
	SELECT course_id, course_name, status
	FROM Courses
	WHERE course_id = p_course_id;
END $$

-- Procedure hủy đăng ký học an toàn (transaction)
CREATE PROCEDURE sp_cancel_enrollment(IN p_enrollment_id INT)
BEGIN
	DECLARE v_status VARCHAR(20);
	DECLARE v_student VARCHAR(10);
	DECLARE v_course VARCHAR(10);
	DECLARE v_fee DECIMAL(12,2);
	DECLARE exit handler FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cancel enrollment failed';
	END;

	START TRANSACTION;
		SELECT status, student_id, course_id, total_fee
		INTO v_status, v_student, v_course, v_fee
		FROM Enrollments
		WHERE enrollment_id = p_enrollment_id
		FOR UPDATE;

		IF v_status = 'Completed' THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot cancel a completed enrollment';
		END IF;

		UPDATE Enrollments
		SET status = 'Cancelled', total_fee = 0
		WHERE enrollment_id = p_enrollment_id;

		-- Trừ tín chỉ nếu đã cộng trước đó
		UPDATE Students
		SET total_credits = GREATEST(0, total_credits - FLOOR(v_fee / 3000000))
		WHERE student_id = v_student;

		INSERT INTO Course_Log (course_id, change_note)
		VALUES (v_course, CONCAT('Enrollment ', p_enrollment_id, ' cancelled safely'));
	COMMIT;
END $$

DELIMITER ;

-- End of script
