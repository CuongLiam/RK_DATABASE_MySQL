CREATE DATABASE ss3ep5;
USE ss3ep5;

CREATE TABLE Student(
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(10) NOT NULL,
    email VARCHAR(255) UNIQUE,
    dob DATE NOT NULL
);

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(255) NOT NULL,
    credit INT CHECK (credit > 0)
);

CREATE TABLE Enrollment (
    Student_id INT PRIMARY KEY AUTO_INCREMENT,
    Subject_id INT PRIMARY KEY AUTO_INCREMENT,
    Enroll_date DATE NOT NULL,

    PRIMARY KEY (Student_id, Subject_id),

    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enroll_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
)

    
INSERT INTO Student (full_name, email, dob) VALUES 
('Nguyen Van A', 'abc1@example.com', '2005-12-31'),
('Nguyen Van B', 'abc2@example.com', '2005-12-31'),
('Nguyen Van C', 'abc3@example.com', '2005-12-31');

INSERT INTO Subject (subject_name, credit) VALUES
('Toán', 10),
('Văn', 10),
('Anh', 10);

INSERT INTO Enrollment (Student_id, Subject_id, Enroll_date) VALUES
(1, 1, '2026-2-2'),
(2, 1, '2026-2-31');

SELECT * FROM Enrollment;

SELECT * FROM Enrollment
WHERE Student_id = 1;