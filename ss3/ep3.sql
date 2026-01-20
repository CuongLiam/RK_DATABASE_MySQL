CREATE DATABASE Session03;
USE Session03;

CREATE TABLE Student (
	Student_ID VARCHAR(10) PRIMARY KEY,
    Full_Name VARCHAR(50) NOT NULL,
    DOB DATE,
    Email VARCHAR(50) UNIQUE
);

INSERT INTO Student VALUES 
("SV01", "Nguyen Van A", "2003-05-10", "a@gmail.com"),
("SV02", "Tran Thi B", "2003-08-21", "b@gmail.com"),
("SV03", "Le Van C", "2004-01-12", "c@gmail.com");

UPDATE Student
SET Email = "duyhoangtran2006@gmail.com" WHERE Student_ID = "SV01";

UPDATE Student
SET DOB = "2006-04-19" WHERE Student_ID = "SV01";

DELETE FROM Student
WHERE Student_ID = "SV03";

SELECT * FROM Student;