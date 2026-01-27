CREATE DATABASE ss3ep2;
USE ss3ep2;

CREATE TABLE Student(
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(10) NOT NULL,
    email VARCHAR(255) UNIQUE
);

INSERT INTO Student VALUES (1, 'Nguyen Van A', 'Abc@example.com');
INSERT INTO Student VALUES (2, 'Nguyen Van B', 'Bbc@example.com');
INSERT INTO Student VALUES (3, 'Nguyen Van C', 'Cbc@example.com');

-- Omit the student_id column - it will auto-increment
INSERT INTO Student (full_name, email) VALUES ('Nguyen Van A', 'abc1@example.com');
INSERT INTO Student (full_name, email) VALUES ('Nguyen Van B', 'abc2@example.com');
INSERT INTO Student (full_name, email) VALUES ('Nguyen Van C', 'abc3@example.com');