USE social_network;

-- Tạo bảng log xóa bài viết
CREATE TABLE IF NOT EXISTS delete_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id_was INT,       -- ID của bài viết đã bị xóa
    deleted_by INT,        -- ID người thực hiện xóa
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_delete_post(IN p_post_id INT, IN p_user_id INT)
BEGIN
    -- Khai báo biến để kiểm tra chủ sở hữu
    DECLARE v_owner_id INT;
    
    -- Khai báo Handler: Nếu có lỗi SQL bất kỳ -> Rollback và báo lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Lỗi hệ thống: Giao dịch đã bị hủy (Rollback).' AS Status;
    END;

    -- 1. KIỂM TRA HỢP LỆ (Validation)
    -- Lấy owner_id của bài viết
    SELECT user_id INTO v_owner_id FROM posts WHERE post_id = p_post_id;

    -- Logic kiểm tra
    IF v_owner_id IS NULL THEN
        SELECT 'Lỗi: Bài viết không tồn tại.' AS Status;
    ELSEIF v_owner_id != p_user_id THEN
        SELECT 'Lỗi: Bạn không có quyền xóa bài viết này.' AS Status;
    ELSE
        -- 2. BẮT ĐẦU TRANSACTION (Nếu hợp lệ)
        START TRANSACTION;

        -- Bước A: Xóa dữ liệu phụ thuộc (Bảng con) trước
        DELETE FROM likes WHERE post_id = p_post_id;
        DELETE FROM comments WHERE post_id = p_post_id;

        -- Bước B: Xóa bài viết (Bảng cha)
        DELETE FROM posts WHERE post_id = p_post_id;

        -- Bước C: Cập nhật số lượng bài viết của User
        UPDATE users 
        SET posts_count = posts_count - 1 
        WHERE user_id = p_user_id;

        -- Bước D: Ghi log (Lưu lại bằng chứng đã xóa)
        INSERT INTO delete_logs (post_id_was, deleted_by) 
        VALUES (p_post_id, p_user_id);

        -- Bước E: Hoàn tất
        COMMIT;
        
        SELECT 'Thành công: Đã xóa bài viết và dữ liệu liên quan.' AS Status;
    END IF;
END //

DELIMITER ;

-- test
-- 1. Tạo User chủ bài viết (User ID 1)
INSERT IGNORE INTO users (user_id, username, posts_count) VALUES (1, 'Boss_User', 1);

-- 2. Tạo User người lạ (User ID 2)
INSERT IGNORE INTO users (user_id, username, posts_count) VALUES (2, 'Hacker', 0);

-- 3. Tạo Bài viết (Post ID 100)
INSERT IGNORE INTO posts (post_id, user_id, content) VALUES (100, 1, 'Bài viết sắp bị xóa');

-- 4. Tạo dữ liệu rác (Likes và Comments) gắn vào Post 100
INSERT IGNORE INTO likes (post_id, user_id) VALUES (100, 1), (100, 2);
INSERT IGNORE INTO comments (post_id, user_id, content) VALUES (100, 2, 'Đừng xóa comment của tôi');

-- Trường hợp 1: Xóa không hợp lệ (User 2 cố xóa bài của User 1)
-- Logic transaction thậm chí không được khởi động vì không qua được bước Validation.

CALL sp_delete_post(100, 2); 

-- KẾT QUẢ MONG ĐỢI:
-- Status: "Lỗi: Bạn không có quyền xóa bài viết này."
-- Dữ liệu bài viết và comments vẫn còn nguyên.


-- Trường hợp 2: Xóa thành công (User 1 xóa bài chính mình)
-- Đây là lúc Transaction thể hiện sức mạnh: Xóa 4 bảng khác nhau cùng lúc.

CALL sp_delete_post(100, 1);

-- KẾT QUẢ MONG ĐỢI:
-- Status: "Thành công..."


-- Bước 5: Kiểm chứng tính toàn vẹn (Verification)
-- Sau khi chạy Trường hợp 2, hãy chạy các lệnh sau để kiểm tra xem hệ thống có sạch sẽ không.

-- 1. Kiểm tra bài viết: Phải KHÔNG còn kết quả
SELECT * FROM posts WHERE post_id = 100;

-- 2. Kiểm tra likes/comments: Phải KHÔNG còn kết quả liên quan đến post 100
SELECT * FROM likes WHERE post_id = 100;
SELECT * FROM comments WHERE post_id = 100;

-- 3. Kiểm tra user: posts_count của User 1 phải giảm về 0 (hoặc giảm đi 1 so với ban đầu)
SELECT user_id, username, posts_count FROM users WHERE user_id = 1;

-- 4. Kiểm tra log: Phải có dòng ghi nhận việc xóa
SELECT * FROM delete_logs;