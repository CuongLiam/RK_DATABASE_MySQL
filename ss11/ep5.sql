USE social_network_pro;

DELIMITER $$

CREATE PROCEDURE calculate_user_activity_score(
	IN p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
	DECLARE post_count INT DEFAULT 0;
    DECLARE like_count INT DEFAULT 0;
    DECLARE comment_count INT DEFAULT 0;
    
    SELECT COUNT(*) 
    INTO post_count
    FROM posts
    WHERE user_id = p_user_id;
    
    SELECT COUNT(*)
	INTO like_count
	FROM likes l
	JOIN posts p ON l.post_id = p.post_id
	WHERE p.user_id = p_user_id;
    
    SELECT COUNT(*)
    INTO comment_count
    FROM comments
    WHERE user_id = p_user_id;
    
    SET activity_score = post_count * 10 + comment_count * 5 + like_count * 3;
    
    IF activity_score > 500 THEN
		SET activity_level = 'Rat tich cuc';
        
	ELSEIF activity_score >= 200 THEN
		SET activity_level = 'Tich cuc';

	ELSE
		SET activity_level = 'Binh thuong';
	END IF;
END$$

DELIMITER ;

CALL calculate_user_activity_score(3, @score, @level);

SELECT @score AS activity_score, @level AS activity_level;

DROP PROCEDURE IF EXISTS calculate_user_activity_score;