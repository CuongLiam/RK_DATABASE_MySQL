USE social_network_pro;

DELIMITER $$

CREATE PROCEDURE calculate_posts_likes (
	IN p_post_id INT,
    OUT total_likes INT
)
BEGIN 
	SELECT COUNT(*)
    INTO total_likes
    FROM likes
    WHERE post_id = p_post_id;
END$$

DELIMITER ;

CALL calculate_posts_likes(2, @total_likes);

SELECT @total_likes AS total_likes;

DROP PROCEDURE IF EXISTS calculate_posts_likes;