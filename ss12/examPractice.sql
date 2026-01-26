CREATE DATABASE StudentDB;
USE StudentDB;
-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);

-- ========================================
-- PHẦN A – CƠ BẢN (4đ)
-- ========================================

-- ============ Câu 1: View_StudentBasic ============
-- Tạo View hiển thị: StudentID, FullName, DeptName
CREATE VIEW View_StudentBasic AS
SELECT 
    s.StudentID,
    s.FullName,
    d.DeptName
FROM Student s
INNER JOIN Department d ON s.DeptID = d.DeptID;

-- Truy vấn toàn bộ View_StudentBasic
SELECT * FROM View_StudentBasic;

-- ============ Câu 2: Index cho cột FullName ============
-- Tạo Regular Index cho cột FullName của bảng Student
CREATE INDEX idx_StudentFullName ON Student(FullName);

-- ============ Câu 3: Stored Procedure GetStudentsIT ============
-- Tạo Stored Procedure (không có tham số)
-- Hiển thị toàn bộ sinh viên khoa Information Technology
DELIMITER $$
CREATE PROCEDURE GetStudentsIT()
BEGIN
    SELECT 
        s.StudentID,
        s.FullName,
        s.Gender,
        s.BirthDate,
        d.DeptName
    FROM Student s
    INNER JOIN Department d ON s.DeptID = d.DeptID
    WHERE d.DeptName = 'Information Technology';
END$$
DELIMITER ;

-- Gọi Stored Procedure GetStudentsIT
CALL GetStudentsIT();

-- ========================================
-- PHẦN B – KHÁ (3đ)
-- ========================================

-- ============ Câu 4a: View_StudentCountByDept ============
-- Tạo View hiển thị: DeptName, TotalStudents (số sinh viên mỗi khoa)
CREATE VIEW View_StudentCountByDept AS
SELECT 
    d.DeptName,
    COUNT(s.StudentID) AS TotalStudents
FROM Department d
LEFT JOIN Student s ON d.DeptID = s.DeptID
GROUP BY d.DeptID, d.DeptName;

-- ============ Câu 4b: Tìm khoa có nhiều sinh viên nhất ============
-- Truy vấn từ View để hiển thị khoa có nhiều sinh viên nhất
SELECT DeptName, TotalStudents
FROM View_StudentCountByDept
WHERE TotalStudents = (SELECT MAX(TotalStudents) FROM View_StudentCountByDept);

-- ============ Câu 5a: Stored Procedure GetTopScoreStudent ============
-- Tạo Stored Procedure với tham số p_CourseID
-- Hiển thị sinh viên có điểm cao nhất trong môn học được truyền vào
DELIMITER $$
CREATE PROCEDURE GetTopScoreStudent(IN p_CourseID CHAR(6))
BEGIN
    SELECT 
        e.StudentID,
        s.FullName,
        c.CourseName,
        e.Score
    FROM Enrollment e
    INNER JOIN Student s ON e.StudentID = s.StudentID
    INNER JOIN Course c ON e.CourseID = c.CourseID
    WHERE e.CourseID = p_CourseID
    ORDER BY e.Score DESC
    LIMIT 1;
END$$
DELIMITER ;

-- ============ Câu 5b: Gọi thủ tục để tìm sinh viên có điểm cao nhất môn Database Systems ============
-- Gọi GetTopScoreStudent để tìm sinh viên có điểm cao nhất môn C00001 (Database Systems)
CALL GetTopScoreStudent('C00001');

-- ========================================
-- PHẦN C – GIỎI (3đ)
-- ========================================

-- ============ Câu 6a: View_IT_Enrollment_DB ============
-- Tạo View hiển thị các sinh viên:
-- - Thuộc khoa IT
-- - Đăng ký môn C00001
-- View phải có WITH CHECK OPTION
CREATE VIEW View_IT_Enrollment_DB AS
SELECT 
    e.StudentID,
    s.FullName,
    d.DeptName,
    e.CourseID,
    c.CourseName,
    e.Score
FROM Enrollment e
INNER JOIN Student s ON e.StudentID = s.StudentID
INNER JOIN Department d ON s.DeptID = d.DeptID
INNER JOIN Course c ON e.CourseID = c.CourseID
WHERE d.DeptID = 'IT' AND e.CourseID = 'C00001'
WITH CHECK OPTION;

-- ============ Câu 6b: Stored Procedure UpdateScore_IT_DB ============
-- Tạo Stored Procedure UpdateScore_IT_DB
-- Tham số:
-- - IN p_StudentID: Mã sinh viên
-- - INOUT p_NewScore: Điểm mới (vào và ra)
-- Xử lý:
-- - Nếu p_NewScore > 10 → gán lại = 10
-- - Cập nhật điểm thông qua View View_IT_Enrollment_DB
DELIMITER $$
CREATE PROCEDURE UpdateScore_IT_DB(
    IN p_StudentID CHAR(6),
    INOUT p_NewScore FLOAT
)
BEGIN
    -- Kiểm tra và điều chỉnh điểm nếu vượt quá 10
    IF p_NewScore > 10 THEN
        SET p_NewScore = 10;
    END IF;
    
    -- Cập nhật điểm thông qua View
    UPDATE View_IT_Enrollment_DB
    SET Score = p_NewScore
    WHERE StudentID = p_StudentID AND CourseID = 'C00001';
END$$
DELIMITER ;

-- ============ Câu 6c: GỌI THỦ TỤC ============
-- Khai báo biến để nhận giá trị INOUT
SET @studentID = 'S00001';
SET @newScore = 12.5;

-- Hiển thị giá trị ban đầu
SELECT 'Trước khi cập nhật:' AS Info;
SELECT * FROM View_IT_Enrollment_DB WHERE StudentID = @studentID;

-- Gọi thủ tục để cập nhật điểm cho sinh viên S00001
CALL UpdateScore_IT_DB(@studentID, @newScore);

-- Hiển thị lại giá trị điểm mới
SELECT CONCAT('Điểm mới: ', @newScore) AS Info;

-- Kiểm tra dữ liệu trong View View_IT_Enrollment_DB
SELECT 'Sau khi cập nhật:' AS Info;
SELECT * FROM View_IT_Enrollment_DB WHERE StudentID = @studentID;

-- Hiển thị toàn bộ dữ liệu trong View
SELECT '=== Toàn bộ View_IT_Enrollment_DB ===' AS Info;
SELECT * FROM View_IT_Enrollment_DB;

