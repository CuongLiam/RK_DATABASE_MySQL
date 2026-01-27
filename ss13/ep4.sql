USE trgexercises;

CREATE TABLE post_history(
	history_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    FOREIGN KEY(post_id) REFERENCES posts(post_id)
		ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER trg_post_update_history
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN 
	IF OLD.content <> NEW.content THEN
		INSERT INTO post_history(post_id, old_content, new_content, changed_at, changed_by_user_id)
        VALUES(OLD.post_id, OLD.content, NEW.content, NOW(), OLD.user_id);
	END IF;
END$$

DELIMITER ;

UPDATE posts
SET content = 'Noi dung moi lan 1'
WHERE post_id = 1;

UPDATE posts
SET content = 'Noi dung moi lan 2'
WHERE post_id = 1;

SELECT * FROM post_history WHERE post_id = 1;