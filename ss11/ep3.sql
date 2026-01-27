USE social_network_pro;

DELIMITER $$

CREATE PROCEDURE calculate_bonus_point(
	IN p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN 
	DECLARE post_count INT;
	SELECT COUNT(*)
    INTO post_count
    FROM posts
    WHERE user_id = p_user_id;
    
    IF post_count >= 10 THEN
		SET p_bonus_points = p_bonus_points + 50;
        
	ELSEIF post_count >= 20 THEN
		SET p_bonus_points = p_bonus_point + 100;
        
	END IF;
END$$

DELIMITER ;

SET @bonus_points = 100;

CALL calculate_bonus_point(3, @bonus_points);

SELECT @bonus_points AS bonus_points;

DROP PROCEDURE IF EXISTS calculate_bonus_point;