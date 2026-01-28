USE social_network;

-- 1. Thêm cột likes_count vào bảng posts (nếu chưa có)
-- Lưu ý: Nếu cột đã tồn tại, lệnh này có thể báo lỗi, bạn có thể bỏ qua.
ALTER TABLE posts ADD COLUMN likes_count INT DEFAULT 0;

-- 2. Tạo bảng likes với ràng buộc UNIQUE
CREATE TABLE IF NOT EXISTS likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    -- Ràng buộc quan trọng: 1 user chỉ được like 1 post cụ thể 1 lần
    UNIQUE KEY unique_like (post_id, user_id)
);

-- Đảm bảo có user 1
INSERT IGNORE INTO users (user_id, username, posts_count) VALUES (1, 'nguyen_van_a', 0);
-- Đảm bảo có post 1 của user 1
INSERT IGNORE INTO posts (post_id, user_id, content) VALUES (1, 1, 'Hello World');



DELIMITER //

CREATE PROCEDURE LikePostProcess(IN p_post_id INT, IN p_user_id INT)
BEGIN
    -- Khai báo xử lý lỗi: Nếu gặp lỗi Duplicate Key (1062) hoặc bất kỳ lỗi SQL nào
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Gặp lỗi thì Rollback ngay lập tức
        ROLLBACK;
        SELECT 'Thất bại: Bạn đã like bài này rồi hoặc lỗi hệ thống.' AS Status;
    END;

    -- Bắt đầu Transaction
    START TRANSACTION;

    -- Bước 1: Insert (Nếu trùng sẽ nhảy xuống HANDLER ở trên)
    INSERT INTO likes (post_id, user_id) VALUES (p_post_id, p_user_id);

    -- Bước 2: Update count
    UPDATE posts SET likes_count = likes_count + 1 WHERE post_id = p_post_id;

    -- Nếu chạy mượt đến đây thì Commit
    COMMIT;
    SELECT 'Thành công: Đã like bài viết.' AS Status;
END //

DELIMITER ;