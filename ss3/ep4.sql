CREATE DATABASE Session03;
USE Session03;

CREATE TABLE Subject (
    subject_id VARCHAR(10) PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);

INSERT INTO Subject VALUES
('MH01', 'Co So Du Lieu', 3),
('MH02', 'Lap Trinh C', 4),
('MH03', 'Cau Truc Du Lieu', 3);

UPDATE Subject
SET credit = 5
WHERE subject_id = 'MH01';

SELECT * FROM Subject
WHERE subject_id = 'MH01';

UPDATE Subject
SET subject_name = 'Lap Trinh C Nang Cao'
WHERE subject_id = 'MH02';

SELECT * FROM Subject;