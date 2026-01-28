-- 1. Tạo và sử dụng database
CREATE DATABASE IF NOT EXISTS social_network;
USE social_network;

-- 2. Tạo bảng users
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);

-- 3. Tạo bảng posts
CREATE TABLE IF NOT EXISTS posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 4. Thêm một user mẫu để test (user_id sẽ là 1)
INSERT INTO users (username, posts_count) VALUES ('nguyen_van_a', 0);


-- Bắt đầu Transaction
START TRANSACTION;

-- 1. Thêm bài viết mới cho user_id = 1
INSERT INTO posts (user_id, content) 
VALUES (1, 'Hôm nay trời đẹp quá! Transaction hoạt động tốt.');

-- 2. Cập nhật số lượng bài viết cho user đó
UPDATE users 
SET posts_count = posts_count + 1 
WHERE user_id = 1;

-- 3. Nếu không có lỗi, xác nhận lưu thay đổi
COMMIT;

-- KIỂM TRA KẾT QUẢ:
-- posts_count của user 1 phải tăng lên 1
-- Bảng posts phải có 1 bản ghi mới.
SELECT * FROM users; 
SELECT * FROM posts;


-- cố tình lỗi

-- Bắt đầu Transaction
START TRANSACTION;

-- 1. Cố tình thêm bài viết cho user_id = 999 (Không tồn tại) -> Gây lỗi Foreign Key
INSERT INTO posts (user_id, content) 
VALUES (999, 'Bài viết này sẽ gây lỗi vì user không tồn tại');

-- 2. Giả sử lệnh trên chạy được (thực tế sẽ lỗi ngay dòng trên), ta chạy tiếp lệnh này:
UPDATE users 
SET posts_count = posts_count + 1 
WHERE user_id = 999;

-- 3. Vì có lỗi xảy ra ở bước 1, ta thực hiện ROLLBACK để hoàn tác mọi thứ
ROLLBACK;

-- KIỂM TRA KẾT QUẢ:
-- Bảng posts KHÔNG được có bài viết của user 999.
-- Dữ liệu cũ vẫn nguyên vẹn.
SELECT * FROM users;
SELECT * FROM posts;



-- recomend :
DELIMITER //

CREATE PROCEDURE CreatePost(IN p_user_id INT, IN p_content TEXT)
BEGIN
    -- Khai báo biến để theo dõi lỗi
    DECLARE sql_error TINYINT DEFAULT 0;
    
    -- Khai báo handler: Nếu gặp lỗi SQLEXCEPTION, set biến sql_error = 1
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = 1;

    -- Bắt đầu Transaction
    START TRANSACTION;

    -- Thao tác 1: Insert bài viết
    INSERT INTO posts (user_id, content) VALUES (p_user_id, p_content);

    -- Thao tác 2: Update số lượng
    UPDATE users SET posts_count = posts_count + 1 WHERE user_id = p_user_id;

    -- Kiểm tra lỗi
    IF sql_error = 1 THEN
        -- Nếu có lỗi -> Rollback
        ROLLBACK;
        SELECT 'Giao dịch thất bại: Đã Rollback' AS Message;
    ELSE
        -- Nếu không lỗi -> Commit
        COMMIT;
        SELECT 'Giao dịch thành công: Đã Commit' AS Message;
    END IF;
END //

DELIMITER ;

-- test thành công
CALL CreatePost(1, 'Hello World using Procedure');

-- rollback
CALL CreatePost(999, 'Error Post');