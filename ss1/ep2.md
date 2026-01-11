BT2 – Quản lý việc học của sinh viên trong một học kỳ

1. Mô tả bài toán

Một sinh viên muốn quản lý việc học của mình trong một học kỳ bằng máy tính. Sinh viên quan tâm đến:

Các môn học đang học

Mục tiêu học tập cho từng môn

2. Xác định các thực thể (Entities)

2.1. SinhVien

Đại diện cho sinh viên sử dụng hệ thống.

Thuộc tính:

MaSV (PK): Mã sinh viên

TenSV: Tên sinh viên

2.2. MonHoc

Đại diện cho các môn học mà sinh viên đang học.

Thuộc tính:

MaMon (PK): Mã môn học

TenMon: Tên môn học

SoTinChi: Số tín chỉ

2.3. MucTieuHocTap

Đại diện cho mục tiêu học tập của từng môn.

Thuộc tính:

MaMucTieu (PK): Mã mục tiêu

NoiDung: Nội dung mục tiêu học tập (ví dụ: đạt điểm cao, nắm vững kiến thức)

MaMon (FK): Mã môn học (Khóa ngoại liên kết với thực thể MonHoc)

3. Xác định mối quan hệ giữa các thực thể

3.1. Quan hệ SinhVien – MonHoc

Loại quan hệ: 1 – N

Mô tả: Một sinh viên có thể học nhiều môn học, mỗi môn học trong danh sách này thuộc về quyền quản lý của một sinh viên cụ thể.

3.2. Quan hệ MonHoc – MucTieuHocTap

Loại quan hệ: 1 – N

Mô tả: Một môn học có thể có nhiều mục tiêu học tập (ví dụ: vừa muốn điểm A, vừa muốn nắm vững kỹ năng thực hành), nhưng mỗi mục tiêu cụ thể chỉ thuộc về một môn học duy nhất.

4. Tóm tắt mô hình ERD (dạng text)

Plaintext

SinhVien (MaSV, TenSV)
   1 ─── N
MonHoc (MaMon, TenMon, SoTinChi, MaSV)
   1 ─── N
MucTieuHocTap (MaMucTieu, NoiDung, MaMon)
5. Ghi chú

Mô hình tập trung vào nhu cầu quản lý cá nhân nên mối quan hệ giữa Sinh viên và Môn học được đơn giản hóa thành 1-N (thay vì N-N như trong quản lý đào tạo toàn trường).

Có thể mở rộng thêm: Thêm bảng TienDo để theo dõi % hoàn thành mục tiêu hoặc bảng DiemSo để ghi nhận kết quả cuối kỳ.