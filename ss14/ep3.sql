USE social_network;

-- 1. Thêm cột đếm vào bảng users (nếu chưa có)
-- Sử dụng IGNORE hoặc kiểm tra tồn tại để tránh lỗi nếu chạy lại script
ALTER TABLE users ADD COLUMN IF NOT EXISTS following_count INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS followers_count INT DEFAULT 0;

-- 2. Tạo bảng followers
CREATE TABLE IF NOT EXISTS followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followed_id), -- Khóa chính phức hợp
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

-- 3. Tạo bảng follow_logs để ghi log lỗi (như yêu cầu)
CREATE TABLE IF NOT EXISTS follow_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    follower_id INT,
    followed_id INT,
    error_message TEXT,
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_follow_user(IN p_follower_id INT, IN p_followed_id INT)
BEGIN
    -- Biến để kiểm tra tồn tại
    DECLARE v_exists_follower INT;
    DECLARE v_exists_followed INT;
    DECLARE v_already_followed INT;
    
    -- Khai báo xử lý lỗi hệ thống (SQL Exceptions)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Nếu có lỗi bất ngờ khi đang chạy Transaction, Rollback ngay
        ROLLBACK;
        -- Ghi log lỗi hệ thống
        INSERT INTO follow_logs (follower_id, followed_id, error_message) 
        VALUES (p_follower_id, p_followed_id, 'Lỗi hệ thống (SQL Exception) khi thực hiện giao dịch.');
        SELECT 'Thất bại: Lỗi hệ thống, đã Rollback.' AS status;
    END;

    -- --- PHẦN 1: VALIDATION (Kiểm tra logic trước khi Transaction) ---
    
    -- 1. Kiểm tra tự follow chính mình
    IF p_follower_id = p_followed_id THEN
        INSERT INTO follow_logs (follower_id, followed_id, error_message) 
        VALUES (p_follower_id, p_followed_id, 'Không thể tự follow chính mình.');
        SELECT 'Thất bại: Không thể tự follow chính mình.' AS status;
    ELSE
        -- 2. Kiểm tra user có tồn tại không
        SELECT COUNT(*) INTO v_exists_follower FROM users WHERE user_id = p_follower_id;
        SELECT COUNT(*) INTO v_exists_followed FROM users WHERE user_id = p_followed_id;

        IF v_exists_follower = 0 OR v_exists_followed = 0 THEN
            INSERT INTO follow_logs (follower_id, followed_id, error_message) 
            VALUES (p_follower_id, p_followed_id, 'User không tồn tại.');
            SELECT 'Thất bại: User ID không hợp lệ.' AS status;
        ELSE
            -- 3. Kiểm tra đã follow chưa
            SELECT COUNT(*) INTO v_already_followed FROM followers 
            WHERE follower_id = p_follower_id AND followed_id = p_followed_id;
            
            IF v_already_followed > 0 THEN
                INSERT INTO follow_logs (follower_id, followed_id, error_message) 
                VALUES (p_follower_id, p_followed_id, 'Đã follow người này rồi.');
                SELECT 'Thất bại: Đã follow trước đó.' AS status;
            ELSE
                -- --- PHẦN 2: TRANSACTION (Thực hiện thay đổi dữ liệu) ---
                
                START TRANSACTION;
                
                -- Thao tác 1: Thêm vào bảng followers
                INSERT INTO followers (follower_id, followed_id) VALUES (p_follower_id, p_followed_id);
                
                -- Thao tác 2: Tăng following_count của người đi theo dõi
                UPDATE users SET following_count = following_count + 1 WHERE user_id = p_follower_id;
                
                -- Thao tác 3: Tăng followers_count của người được theo dõi
                UPDATE users SET followers_count = followers_count + 1 WHERE user_id = p_followed_id;
                
                -- Nếu mọi thứ OK -> Commit
                COMMIT;
                
                SELECT 'Thành công: Đã follow user.' AS status;
            END IF;
        END IF;
    END IF;
END //

DELIMITER ;


-- Tạo 2 user mẫu: User 1 (Alice) và User 2 (Bob)
INSERT IGNORE INTO users (user_id, username, posts_count, following_count, followers_count) 
VALUES (1, 'Alice', 0, 0, 0), (2, 'Bob', 0, 0, 0);



-- Kịch bản 1: Thành công (Alice follow Bob)


CALL sp_follow_user(1, 2);

-- KẾT QUẢ MONG ĐỢI:
-- Thông báo: "Thành công..."
-- Bảng followers: có dòng (1, 2)
-- Bảng users: Alice (following=1), Bob (followers=1)
SELECT * FROM users WHERE user_id IN (1, 2);
SELECT * FROM followers;
-- Kịch bản 2: Thất bại - Follow lại lần nữa (Duplicate)


CALL sp_follow_user(1, 2);

-- KẾT QUẢ MONG ĐỢI:
-- Thông báo: "Thất bại: Đã follow trước đó."
-- Bảng follow_logs: Xuất hiện log lỗi "Đã follow người này rồi."
-- Dữ liệu count không bị tăng lên thành 2.
SELECT * FROM follow_logs;
-- Kịch bản 3: Thất bại - Tự follow chính mình


CALL sp_follow_user(1, 1);

-- KẾT QUẢ MONG ĐỢI:
-- Thông báo: "Thất bại: Không thể tự follow chính mình."
-- Bảng follow_logs: Ghi log lỗi tương ứng.
-- Kịch bản 4: Thất bại - User không tồn tại


CALL sp_follow_user(1, 9999);

-- KẾT QUẢ MONG ĐỢI:
-- Thông báo: "Thất bại: User ID không hợp lệ."
-- Bảng follow_logs: Ghi log lỗi tương ứng.