CREATE DATABASE ss3ep4;
USE ss3ep4;

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(255) NOT NULL,
    credit INT CHECK (credit > 0)
);

INSERT INTO Subject (subject_name, credit) VALUES
('Toán', 10),
('Văn', 10),
('Anh', 10);

UPDATE Subject
SET credit = 7
WHERE subject_id = 2;

UPDATE Subject
SET subject_name = 'English'
WHERE subject_id = 1;

SELECT * FROM Subject;

SELECT * FROM Subject
WHERE student_id = 1;