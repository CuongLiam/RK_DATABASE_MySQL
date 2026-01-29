/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
	StudentID CHAR(5) PRIMARY KEY,
	FullName VARCHAR(50) NOT NULL,
	TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
	SubjectID CHAR(5) PRIMARY KEY,
	SubjectName VARCHAR(50) NOT NULL,
	Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
	StudentID CHAR(5),
	SubjectID CHAR(5),
	Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
	PRIMARY KEY (StudentID, SubjectID),
	CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
	LogID INT PRIMARY KEY AUTO_INCREMENT,
	StudentID CHAR(5),
	OldScore DECIMAL(4,2),
	NewScore DECIMAL(4,2),
	ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- =============================================
-- 3. TRIGGERS & TRANSACTIONS
-- =============================================

-- Clean up existing objects to allow re-run
DROP TRIGGER IF EXISTS tg_CheckScore;
DROP TRIGGER IF EXISTS tg_LogGradeUpdate;
DROP TRIGGER IF EXISTS tg_PreventPassUpdate;
DROP PROCEDURE IF EXISTS sp_PayTuition;
DROP PROCEDURE IF EXISTS sp_DeleteStudentGrade;

DELIMITER $$

-- Câu 1: Chuẩn hóa điểm nhập trước khi insert
CREATE TRIGGER tg_CheckScore
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
	IF NEW.Score < 0 THEN
		SET NEW.Score = 0;
	ELSEIF NEW.Score > 10 THEN
		SET NEW.Score = 10;
	END IF;
END $$

-- Câu 3: Log mọi thay đổi điểm sau update
CREATE TRIGGER tg_LogGradeUpdate
AFTER UPDATE ON Grades
FOR EACH ROW
BEGIN
	IF OLD.Score <> NEW.Score THEN
		INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
		VALUES (OLD.StudentID, OLD.Score, NEW.Score, NOW());
	END IF;
END $$

-- Câu 5: Ngăn sửa điểm đã đậu
CREATE TRIGGER tg_PreventPassUpdate
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
	IF OLD.Score >= 4.0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Cannot update score: already passed';
	END IF;
END $$

-- Câu 4: Thủ tục đóng học phí cho SV01 với 2,000,000
CREATE PROCEDURE sp_PayTuition()
BEGIN
	DECLARE vDebt DECIMAL(10,2);

	START TRANSACTION;

	SELECT TotalDebt INTO vDebt
	FROM Students
	WHERE StudentID = 'SV01'
	FOR UPDATE;

	SET vDebt = vDebt - 2000000;

	UPDATE Students
	SET TotalDebt = vDebt
	WHERE StudentID = 'SV01';

	IF vDebt < 0 THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END $$

-- Câu 6: Thủ tục xóa điểm môn học với lưu vết
CREATE PROCEDURE sp_DeleteStudentGrade(
	IN p_StudentID CHAR(5),
	IN p_SubjectID CHAR(5)
)
proc: BEGIN
	DECLARE vOldScore DECIMAL(4,2);
	DECLARE CONTINUE HANDLER FOR NOT FOUND BEGIN ROLLBACK; LEAVE proc; END;

	START TRANSACTION;

	SELECT Score INTO vOldScore
	FROM Grades
	WHERE StudentID = p_StudentID AND SubjectID = p_SubjectID
	FOR UPDATE;

	INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
	VALUES (p_StudentID, vOldScore, NULL, NOW());

	DELETE FROM Grades
	WHERE StudentID = p_StudentID AND SubjectID = p_SubjectID;

	IF ROW_COUNT() = 0 THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END proc $$

DELIMITER ;

-- =============================================
-- 4. Câu 2: Transaction thêm sinh viên SV02
-- =============================================

START TRANSACTION;
	INSERT INTO Students (StudentID, FullName)
	VALUES ('SV02', 'Ha Bich Ngoc');

	UPDATE Students
	SET TotalDebt = 5000000
	WHERE StudentID = 'SV02';
COMMIT;

-- End of File
