DELIMITER $$

CREATE PROCEDURE get_posts_by_user (
	IN p_user_id INT
)
BEGIN 
	SELECT post_id, content, created_at
    FROM posts
    WHERE user_id = p_user_id
    ORDER BY post_id ASC;
END $$

DELIMITER ;

CALL get_posts_by_user(3);

DROP PROCEDURE IF EXISTS get_posts_by_user;