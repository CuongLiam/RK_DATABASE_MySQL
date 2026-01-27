USE trgexercises;

DELIMITER $$

CREATE TRIGGER trg_check_before_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN 
	IF NEW.email NOT LIKE '%@%.%' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email không hợp lệ!';
	END IF;
    
    IF NEW.username REGEXP '[^a-zA-Z0-9_]' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username chứa kí tự không hợp lệ!';
	END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_user(
	IN p_username VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_created_at DATETIME
)
BEGIN 
	INSERT INTO users(username, email, created_at)
    VALUES(p_username, p_email, p_created_at);
END$$

DELIMITER ;

CALL add_user('linh_dev', 'linh@gmail.com', '2026-01-23');

CALL add_user('linh_dev2', 'linhgmail.com', '2026-01-23');

CALL add_user('linh@dev', 'linh2@gmail.com', '2026-01-23');

SELECT * FROM users;