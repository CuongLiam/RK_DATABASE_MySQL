CREATE DATABASE ss2ep4;
USE ss2ep4;

CREATE TABLE Student(
    MaSV VARCHAR(10) PRIMARY KEY,
    HoTen VARCHAR(50) NOT NULL
);

CREATE TABLE Subject(
    MaMH VARCHAR(10) PRIMARY KEY,
    TenMH VARCHAR(50),
    SoTinChi INT CHECK(SoTinChi > 0)
);

CREATE TABLE Enrollment(
    MaSV VARCHAR(10),
    MAMH VARCHAR(10),
    NgayDangKi DATE NOT NULL,

    PRIMARY KEY (MaSV, MaMH),

    -- ngắn gọn nhưng không đầy đủ
    -- FOREIGN KEY (MaSV) REFERENCES Student(MaSV),
    -- FOREIGN KEY (MaMH) REFERENCES Subject(MaMH)

    -- đầy đủ
    CONSTRAINT fk_enrollment_student FOREIGN KEY (MaSV) REFERENCES Student(MaSV),
    CONSTRAINT fk_enrollment_subject FOREIGN KEY (MaMH) REFERENCES Subject(MaMH)
);

