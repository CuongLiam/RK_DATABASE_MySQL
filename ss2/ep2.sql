CREATE DATABASE ss2ep2;
USE ss2ep2;

CREATE TABLE Class (
	MaLop VARCHAR(10) PRIMARY KEY,
    TenLop VARCHAR(50) NOT NULL,
    -- UNIQUE (Malop), (cách viết khác)
    CONSTRAINT uq_class_malop UNIQUE (MaLop) -- từ khóa cONSTRAINT không bắt buộc nhưng nó giúp dễ quản lý, chỉnh sửa, xóa,...
    NamHoc INT CHECK (NamHoc > 2000)
);

CREATE TABLE Student (
    MaSV VARCHAR(10) PRIMARY KEY,
    HoTen VARCHAR(50) NOT NULL,
    NgaySinh DATE,
    MaLop VARCHAR(10),

    CONSTRAINT fk_student_class
    FOREIGN KEY (MaLop) REFERENCES Class(MaLop)
);

