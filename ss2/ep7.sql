CREATE DATABASE ss2ep7;
USE ss2ep7;

-- 1. Bảng Lớp học (Class)
CREATE TABLE Class (
    MaLop VARCHAR(10) PRIMARY KEY,
    TenLop VARCHAR(50) NOT NULL,
    NamHoc INT CHECK (NamHoc > 2000)
);

-- 2. Bảng Giảng viên (Teacher)
CREATE TABLE Teacher (
    MaGV INT AUTO_INCREMENT PRIMARY KEY,
    HoTen VARCHAR(50) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE
);

-- 3. Bảng Sinh viên (Student)
CREATE TABLE Student (
    MaSV VARCHAR(10) PRIMARY KEY,
    HoTen VARCHAR(50) NOT NULL,
    NgaySinh DATE,
    MaLop VARCHAR(10),
    CONSTRAINT fk_student_class FOREIGN KEY (MaLop) REFERENCES Class(MaLop)
);

-- 4. Bảng Môn học (Subject)
CREATE TABLE Subject (
    MaMH VARCHAR(10) PRIMARY KEY,
    TenMH VARCHAR(50) NOT NULL,
    SoTinChi INT CHECK (SoTinChi > 0),
    MaGV INT,
    CONSTRAINT fk_subject_teacher FOREIGN KEY (MaGV) REFERENCES Teacher(MaGV)
);

-- 5. Bảng Đăng ký môn học (Enrollment)
CREATE TABLE Enrollment (
    MaSV VARCHAR(10),
    MaMH VARCHAR(10),
    NgayDangKy DATE NOT NULL,
    PRIMARY KEY (MaSV, MaMH),
    CONSTRAINT fk_enroll_student FOREIGN KEY (MaSV) REFERENCES Student(MaSV),
    CONSTRAINT fk_enroll_subject FOREIGN KEY (MaMH) REFERENCES Subject(MaMH)
);

-- 6. Bảng Kết quả học tập (Score)
CREATE TABLE Score (
    MaSV VARCHAR(10),
    MaMH VARCHAR(10),
    DiemQuaTrinh DECIMAL(4,2) CHECK (DiemQuaTrinh BETWEEN 0 AND 10),
    DiemCuoiKy DECIMAL(4,2) CHECK (DiemCuoiKy BETWEEN 0 AND 10),
    PRIMARY KEY (MaSV, MaMH),
    CONSTRAINT fk_score_student FOREIGN KEY (MaSV) REFERENCES Student(MaSV),
    CONSTRAINT fk_score_subject FOREIGN KEY (MaMH) REFERENCES Subject(MaMH)
);