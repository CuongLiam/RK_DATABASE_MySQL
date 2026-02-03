-- ĐỀ ÔN TẬP CUỐI HỌC PHẦN 2
-- Môn: Cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS ThucTap_prac3;
USE ThucTap_prac3;

-- Cleanup for re-run
DROP VIEW IF EXISTS SinhVienInfo;
DROP TRIGGER IF EXISTS trg_check_namsinh;
DROP TABLE IF EXISTS HuongDan;
DROP TABLE IF EXISTS DeTai;
DROP TABLE IF EXISTS SinhVien;
DROP TABLE IF EXISTS GiangVien;

-- =============================================================================
-- Câu 1 (2 điểm): Tạo các bảng và thêm dữ liệu
-- =============================================================================

-- Bảng GiangVien
CREATE TABLE GiangVien (
    magv        VARCHAR(10) PRIMARY KEY,
    hoten       VARCHAR(100) NOT NULL,
    luong       DECIMAL(12,2) NOT NULL,
    CONSTRAINT chk_gv_luong CHECK (luong > 0)
);

-- Bảng SinhVien
CREATE TABLE SinhVien (
    masv        VARCHAR(10) PRIMARY KEY,
    hoten       VARCHAR(100) NOT NULL,
    namsinh     INT NOT NULL,
    quequan     VARCHAR(100),
    CONSTRAINT chk_sv_namsinh CHECK (namsinh > 1900 AND namsinh <= YEAR(CURDATE()))
);

-- Bảng DeTai
CREATE TABLE DeTai (
    madt        VARCHAR(10) PRIMARY KEY,
    tendt       VARCHAR(200) NOT NULL,
    kinhphi     DECIMAL(15,2) NOT NULL,
    NoiThucTap  VARCHAR(200),
    CONSTRAINT chk_dt_kinhphi CHECK (kinhphi >= 0)
);

-- Bảng HuongDan
CREATE TABLE HuongDan (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    masv        VARCHAR(10) NOT NULL,
    madt        VARCHAR(10) NOT NULL,
    magv        VARCHAR(10) NOT NULL,
    ketqua      VARCHAR(50),
    CONSTRAINT fk_hd_sinhvien FOREIGN KEY (masv) REFERENCES SinhVien(masv) ON DELETE CASCADE,
    CONSTRAINT fk_hd_detai FOREIGN KEY (madt) REFERENCES DeTai(madt),
    CONSTRAINT fk_hd_giangvien FOREIGN KEY (magv) REFERENCES GiangVien(magv),
    CONSTRAINT chk_hd_ketqua CHECK (ketqua IN ('Đạt', 'Không đạt', 'Chưa đánh giá'))
);

-- Thêm dữ liệu cho bảng GiangVien
INSERT INTO GiangVien (magv, hoten, luong) VALUES
('GV001', 'Nguyen Van A', 15000000),
('GV002', 'Tran Thi B', 18000000),
('GV003', 'Le Van C', 20000000),
('GV004', 'Pham Thi D', 17000000);

-- Thêm dữ liệu cho bảng SinhVien
INSERT INTO SinhVien (masv, hoten, namsinh, quequan) VALUES
('SV001', 'Hoang Van E', 2002, 'Hanoi'),
('SV002', 'Nguyen Thi F', 2003, 'Ho Chi Minh'),
('SV003', 'Tran Van G', 2002, 'Da Nang'),
('SV004', 'Le Thi H', 2001, 'Hue'),
('SV005', 'Pham Van I', 2003, 'Hai Phong');

-- Thêm dữ liệu cho bảng DeTai
INSERT INTO DeTai (madt, tendt, kinhphi, NoiThucTap) VALUES
('DT001', 'CONG NGHE SINH HOC', 50000000, 'Vien Sinh hoc'),
('DT002', 'TRI TUE NHAN TAO', 80000000, 'Cong ty AI Corp'),
('DT003', 'PHAN TICH DU LIEU', 60000000, 'Cong ty Data Solutions'),
('DT004', 'PHAT TRIEN WEB', 40000000, 'Cong ty Tech Start');

-- Thêm dữ liệu cho bảng HuongDan
INSERT INTO HuongDan (masv, madt, magv, ketqua) VALUES
('SV001', 'DT001', 'GV001', 'Đạt'),
('SV002', 'DT001', 'GV001', 'Chưa đánh giá'),
('SV003', 'DT002', 'GV002', 'Đạt'),
('SV004', 'DT003', 'GV003', 'Chưa đánh giá');
-- SV005 không có đề tài

-- =============================================================================
-- Câu 2 (2 điểm): Truy vấn SQL
-- =============================================================================

-- a) Lấy tất cả sinh viên chưa có đề tài hướng dẫn
SELECT sv.masv, sv.hoten, sv.namsinh, sv.quequan
FROM SinhVien sv
LEFT JOIN HuongDan hd ON sv.masv = hd.masv
WHERE hd.id IS NULL;

-- b) Đếm số sinh viên đang làm đề tài "CONG NGHE SINH HOC"
SELECT COUNT(DISTINCT hd.masv) AS SoSinhVien
FROM HuongDan hd
JOIN DeTai dt ON hd.madt = dt.madt
WHERE dt.tendt = 'CONG NGHE SINH HOC';

-- =============================================================================
-- Câu 3 (2 điểm): Tạo VIEW
-- =============================================================================

CREATE VIEW SinhVienInfo AS
SELECT 
    sv.masv AS MaSinhVien,
    sv.hoten AS HoTen,
    COALESCE(dt.tendt, 'Chưa có') AS TenDeTai
FROM SinhVien sv
LEFT JOIN HuongDan hd ON sv.masv = hd.masv
LEFT JOIN DeTai dt ON hd.madt = dt.madt;

-- Test VIEW
SELECT * FROM SinhVienInfo;

-- =============================================================================
-- Câu 4 (2 điểm): Tạo TRIGGER
-- =============================================================================

DELIMITER $$

-- Trigger kiểm tra năm sinh khi INSERT
CREATE TRIGGER trg_check_namsinh
BEFORE INSERT ON SinhVien
FOR EACH ROW
BEGIN
    IF NEW.namsinh <= 1900 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Năm sinh phải > 1900';
    END IF;
END $$

DELIMITER ;

-- =============================================================================
-- Câu 5 (2 điểm): Cấu hình CASCADE DELETE
-- =============================================================================
-- Đã cấu hình ON DELETE CASCADE trong bảng HuongDan tại Câu 1
-- Khi xóa sinh viên, dữ liệu trong HuongDan sẽ tự động bị xóa

-- =============================================================================
-- TEST CÁC CHỨC NĂNG
-- =============================================================================

-- Test Trigger (sẽ báo lỗi)
-- INSERT INTO SinhVien (masv, hoten, namsinh, quequan) VALUES
-- ('SV999', 'Test Student', 1899, 'Test Location');

-- Test CASCADE DELETE
-- DELETE FROM SinhVien WHERE masv = 'SV001';
-- SELECT * FROM HuongDan;  -- Kiểm tra xem bản ghi của SV001 đã bị xóa chưa

-- End of script
