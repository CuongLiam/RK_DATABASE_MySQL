USE social_network_pro;

DELIMITER $$

CREATE PROCEDURE create_post_with_validation(
	IN p_user_id INT,
    IN p_content TEXT,
    OUT result_message VARCHAR(255)
)
BEGIN
	IF CHAR_LENGTH(p_content) < 5 THEN 
		SET result_message = 'Noi Dung Qua Ngan!';
        
	ELSE 
		INSERT INTO posts(user_id, content, created_at)
        VALUES(p_user_id, p_content, NOW());
        
        SET result_message = 'Them Bai Viet Thanh Cong!';
	END IF;
END$$

DELIMITER ;

CALL create_post_with_validation(4, 'Duy Dep Trai', @result);

SELECT @result AS message_result;

DROP PROCEDURE IF EXISTS create_post_with_validation;