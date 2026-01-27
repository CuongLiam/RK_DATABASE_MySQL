USE trgexercises;

DELIMITER $$

CREATE TRIGGER trg_no_self_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN 
	DECLARE post_owner INT;
    
    SELECT user_id INTO post_owner
    FROM posts
    WHERE id = NEW.post_id;
    
    IF NEW.user_id = post_owner THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không được Like bài của chính mình!';
	END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_like_insert
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
	UPDATE posts
    SET like_count = like_count + 1
    WHERE id = NEW.post_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_after_like_delete
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN 
	UPDATE posts
    SET like_count = like_count - 1
    WHERE id = OLD.post_id;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_after_like_update
AFTER UPDATE ON Likes
FOR EACH ROW
BEGIN
	IF NEW.post_id <> OLD.post_id THEN	
		UPDATE posts
        SET like_count = like_count - 1
        WHERE id = OLD.post_id;
        
        UPDATE posts
        SET like_count = like_count + 1
        WHERE id = NEW.post_id;
	END IF;
END$$

DELIMITER ;

INSERT INTO likes(user_id, post_id) VALUES (1,1);

INSERT INTO likes(user_id, post_id) VALUES (2,1);

UPDATE likes SET post_id = 2 WHERE user_id = 2;

DELETE FROM likes WHERE user_id = 2;

SELECT id, like_count FROM posts;
SELECT * FROM user_statistics;