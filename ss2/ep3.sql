CREATE DATABASE ss2ep3;
USE ss2ep3;

CREATE TABLE Student(
    MaSV VARCHAR(10) PRIMARY KEY,
    HoTen VARCHAR(50) NOT NULL,

    CONSTRAINT uq_student_masv UNIQUE (MaSV) -- không cần thiết vì PRIMARY KEY đã có unique rồi
);

CREATE TABLE Subject(
    MaMH VARCHAR(10) PRIMARY KEY,
    TenMH VARCHAR(50),
    SoTinChi INT CHECK(SoTinChi > 0)
);

