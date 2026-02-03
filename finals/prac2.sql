CREATE DATABASE IF NOT EXISTS School_Management_prac2;
USE School_Management_prac2;

-- Cleanup for re-run
DROP VIEW IF EXISTS StudentInfo;
DROP TRIGGER IF EXISTS SubjectUpdateID;
DROP TRIGGER IF EXISTS StudentDeleteID;
DROP PROCEDURE IF EXISTS sp_delete_student;
DROP TABLE IF EXISTS StudentSubject;
DROP TABLE IF EXISTS Subject;
DROP TABLE IF EXISTS Student;

-- =============================================================================
-- Câu 1 (2 điểm): Tạo các bảng và thêm dữ liệu
-- =============================================================================

-- Bảng Student
CREATE TABLE Student (
    ID          INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100) NOT NULL,
    Age         INT NOT NULL,
    Gender      TINYINT,  -- 0: Male, 1: Female, NULL: Unknown
    CONSTRAINT chk_student_age CHECK (Age >= 0 AND Age <= 100)
);

-- Bảng Subject
CREATE TABLE Subject (
    ID          INT PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100) NOT NULL
);

-- Bảng StudentSubject (bảng trung gian)
CREATE TABLE StudentSubject (
    StudentID   INT NOT NULL,
    SubjectID   INT NOT NULL,
    Mark        DECIMAL(4,2) NOT NULL,
    Date        DATE NOT NULL,
    PRIMARY KEY (StudentID, SubjectID, Date),
    CONSTRAINT fk_ss_student FOREIGN KEY (StudentID) REFERENCES Student(ID),
    CONSTRAINT fk_ss_subject FOREIGN KEY (SubjectID) REFERENCES Subject(ID),
    CONSTRAINT chk_ss_mark CHECK (Mark >= 0 AND Mark <= 10)
);

-- Thêm dữ liệu cho bảng Student
INSERT INTO Student (Name, Age, Gender) VALUES
('Nguyen Van A', 18, 0),      -- Male
('Tran Thi B', 19, 1),         -- Female
('Le Van C', 20, 0),           -- Male
('Pham Thi D', 18, 1),         -- Female
('Hoang Van E', 21, NULL);     -- Unknown

-- Thêm dữ liệu cho bảng Subject
INSERT INTO Subject (Name) VALUES
('Mathematics'),
('Physics'),
('Chemistry'),
('Literature'),
('English');

-- Thêm dữ liệu cho bảng StudentSubject
INSERT INTO StudentSubject (StudentID, SubjectID, Mark, Date) VALUES
(1, 1, 8.5, '2024-01-15'),
(1, 2, 7.0, '2024-01-20'),
(2, 1, 9.0, '2024-01-15'),
(2, 2, 8.0, '2024-01-20'),
(3, 3, 6.5, '2024-01-18'),
(4, 1, 7.5, '2024-01-15'),
(1, 1, 9.0, '2024-02-10');  -- Student 1 has 2 marks for Math

-- =============================================================================
-- Câu 2 (2 điểm): Truy vấn SQL
-- =============================================================================

-- a) Lấy tất cả các môn học chưa có bất kỳ điểm nào
SELECT s.ID, s.Name
FROM Subject s
LEFT JOIN StudentSubject ss ON s.ID = ss.SubjectID
WHERE ss.SubjectID IS NULL;

-- b) Lấy danh sách các môn học có ít nhất 2 điểm
SELECT s.ID, s.Name, COUNT(ss.SubjectID) AS MarkCount
FROM Subject s
JOIN StudentSubject ss ON s.ID = ss.SubjectID
GROUP BY s.ID, s.Name
HAVING COUNT(ss.SubjectID) >= 2;

-- =============================================================================
-- Câu 3 (2 điểm): Tạo VIEW
-- =============================================================================

CREATE VIEW StudentInfo AS
SELECT 
    st.ID AS StudentID,
    sub.ID AS SubjectID,
    st.Name AS StudentName,
    st.Age AS StudentAge,
    CASE 
        WHEN st.Gender = 0 THEN 'Male'
        WHEN st.Gender = 1 THEN 'Female'
        ELSE 'Unknown'
    END AS StudentGender,
    sub.Name AS SubjectName,
    ss.Mark,
    ss.Date
FROM Student st
JOIN StudentSubject ss ON st.ID = ss.StudentID
JOIN Subject sub ON ss.SubjectID = sub.ID;

-- Test VIEW
SELECT * FROM StudentInfo;

-- =============================================================================
-- Câu 4 (2 điểm): Tạo TRIGGER
-- =============================================================================

DELIMITER $$

-- a) Trigger SubjectUpdateID
-- Khi thay đổi ID của Subject thì SubjectID trong StudentSubject cũng thay đổi
CREATE TRIGGER SubjectUpdateID
BEFORE UPDATE ON Subject
FOR EACH ROW
BEGIN
    IF OLD.ID <> NEW.ID THEN
        UPDATE StudentSubject
        SET SubjectID = NEW.ID
        WHERE SubjectID = OLD.ID;
    END IF;
END $$

-- b) Trigger StudentDeleteID
-- Khi xóa Student thì xóa toàn bộ bản ghi liên quan trong StudentSubject
CREATE TRIGGER StudentDeleteID
BEFORE DELETE ON Student
FOR EACH ROW
BEGIN
    DELETE FROM StudentSubject
    WHERE StudentID = OLD.ID;
END $$

DELIMITER ;

-- =============================================================================
-- Câu 5 (2 điểm): Tạo STORED PROCEDURE
-- =============================================================================

DELIMITER $$

CREATE PROCEDURE sp_delete_student(IN student_name VARCHAR(100))
BEGIN
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Delete student failed';
    END;
    
    START TRANSACTION;
        IF student_name = '*' THEN
            -- Xóa toàn bộ học sinh
            DELETE FROM StudentSubject;
            DELETE FROM Student;
        ELSE
            -- Xóa học sinh có tên trùng khớp
            DELETE FROM StudentSubject
            WHERE StudentID IN (
                SELECT ID FROM Student WHERE Name = student_name
            );
            
            DELETE FROM Student
            WHERE Name = student_name;
        END IF;
    COMMIT;
END $$

DELIMITER ;

-- =============================================================================
-- TEST CÁC CHỨC NĂNG
-- =============================================================================

-- Test Stored Procedure
-- CALL sp_delete_student('Hoang Van E');  -- Xóa 1 học sinh cụ thể
-- CALL sp_delete_student('*');             -- Xóa toàn bộ học sinh

-- Test Trigger SubjectUpdateID (không khuyến khích thay đổi Primary Key trong thực tế)
-- UPDATE Subject SET ID = 100 WHERE ID = 1;

-- Test Trigger StudentDeleteID
-- DELETE FROM Student WHERE ID = 5;

-- End of script
