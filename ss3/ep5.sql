CREATE DATABASE Session03;
USE Session03;

CREATE TABLE Enrollment (
	student_id VARCHAR(10) NOT NULL,
    subject_id VARCHAR(10) NOT NULL,
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enroll_student
		FOREIGN KEY (student_id)
        REFERENCES Student(student_id),
	CONSTRAINT fk_enroll_subject
		FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);

INSERT INTO Enrollment VALUES
("SV01", "MH01", "2025-10-01"),
("SV02", "MH02", "2025-10-15");

-- SELECT * FROM Subject;
-- SELECT * FROM Student;
SELECT * FROM Enrollment;
SELECT * FROM Enrollment WHERE student_id = "SV02";
