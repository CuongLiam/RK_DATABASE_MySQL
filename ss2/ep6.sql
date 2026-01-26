CREATE DATABASE ss2ep6;
USE ss2ep6;

CREATE TABLE Student(
    MaSV VARCHAR(10) PRIMARY KEY,
    HoTen VARCHAR(50) NOT NULL
);

CREATE TABLE Subject(
    MaMH VARCHAR(10) PRIMARY KEY,
    TenMH VARCHAR(50) NOT NULL
);

CREATE TABLE Score (
    MaSV VARCHAR(10),
    MaMH VARCHAR(10),
    DiemQuaTrinh DECIMAL(4,2) CHECK (DiemQuaTrinh BETWEEN 0 AND 10),
    DiemCuoiKy DECIMAL(4,2) CHECK (DiemCuoiKy BETWEEN 0 AND 10),

--  Thiết lập khóa chính hỗn hợp: Mỗi SV chỉ có một kết quả duy nhất cho mỗi môn

    PRIMARY KEY (MaSV, MaMH),

    CONSTRAINT fk_score_student FOREIGN KEY (MaSV) REFERENCES Student(MaSV),
    CONSTRAINT fk_score_student FOREIGN KEY (MaMH) REFERENCES Student(MaSV)
);

