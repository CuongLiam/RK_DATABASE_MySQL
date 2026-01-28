USE social_network;

-- 1. Thêm cột comments_count vào bảng posts
ALTER TABLE posts ADD COLUMN IF NOT EXISTS comments_count INT DEFAULT 0;

-- 2. Tạo bảng comments
CREATE TABLE IF NOT EXISTS comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_post_comment(
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT,
    IN p_simulate_fail BOOLEAN -- Tham số để test lỗi
)
BEGIN
    -- Bắt đầu giao dịch
    START TRANSACTION;

    -- BƯỚC 1: Thêm bình luận (Luôn chạy trước)
    INSERT INTO comments (post_id, user_id, content) 
    VALUES (p_post_id, p_user_id, p_content);

    -- TẠO ĐIỂM LƯU (SAVEPOINT)
    -- Tại đây, comment đã nằm trong bộ nhớ đệm transaction.
    SAVEPOINT after_insert;

    -- BƯỚC 2: Cố gắng cập nhật số lượng
    IF p_simulate_fail = TRUE THEN
        -- !!! GIẢ LẬP LỖI !!! 
        -- Giả sử hệ thống đếm bị lỗi hoặc logic update gặp vấn đề
        
        -- Quay lại điểm savepoint (Hủy bỏ các lệnh sau savepoint, giữ lại lệnh trước savepoint)
        ROLLBACK TO SAVEPOINT after_insert;
        
        -- Commit những gì còn lại (chính là lệnh INSERT ở bước 1)
        COMMIT;
        
        SELECT 'Cảnh báo: Đã lưu bình luận nhưng KHÔNG cập nhật được số lượng (Partial Commit).' AS status;
    ELSE
        -- TRƯỜNG HỢP BÌNH THƯỜNG
        UPDATE posts 
        SET comments_count = comments_count + 1 
        WHERE post_id = p_post_id;
        
        -- Commit toàn bộ
        COMMIT;
        
        SELECT 'Thành công: Đã lưu bình luận và cập nhật số lượng.' AS status;
    END IF;

END //

DELIMITER ;

-- test

-- Reset lại số đếm để dễ theo dõi
UPDATE posts SET comments_count = 0 WHERE post_id = 1;
-- Xóa comment cũ nếu có
DELETE FROM comments;


-- Trường hợp 1: Thành công toàn diện (Full Commit)
Chạy procedure với tham số giả lập lỗi là FALSE.


-- User 1 bình luận vào Post 1: "Bài viết hay quá"
CALL sp_post_comment(1, 1, 'Bài viết hay quá (Case Success)', FALSE);

-- KIỂM TRA:
-- comments: Có bản ghi.
-- posts: comments_count = 1.
SELECT * FROM comments;
SELECT post_id, comments_count FROM posts WHERE post_id = 1;


-- Trường hợp 2: Lỗi UPDATE -> Rollback một phần (Partial Rollback)
Chạy procedure với tham số giả lập lỗi là TRUE. Theo logic, bình luận vẫn được lưu (vì đã qua Savepoint), nhưng lệnh Update count sẽ bị hủy.


-- User 1 bình luận tiếp: "Test lỗi savepoint"
CALL sp_post_comment(1, 1, 'Test lỗi savepoint (Case Fail)', TRUE);

-- KIỂM TRA KẾT QUẢ QUAN TRỌNG:
-- 1. Bảng comments: Sẽ có thêm bản ghi mới "Test lỗi savepoint".
-- 2. Bảng posts: comments_count VẪN LÀ 1 (Không tăng lên 2).
SELECT * FROM comments;
SELECT post_id, comments_count FROM posts WHERE post_id = 1;

