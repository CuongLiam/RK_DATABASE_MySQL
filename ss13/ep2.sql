USE TrgExercises;

CREATE TABLE likes(
	like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_likes_users
		FOREIGN KEY(user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
	CONSTRAINT fk_likes_posts
		FOREIGN KEY(post_id) REFERENCES posts(post_id)
        ON DELETE CASCADE
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

DELIMITER $$

CREATE TRIGGER trg_likes_after_insert
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_likes_after_delete
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$

DELIMITER ;

CREATE VIEW view_user_statistics AS
	SELECT users.user_id, users.username, users.post_count, SUM(posts.like_count) AS TotalLikes
FROM users
LEFT JOIN posts ON users.user_id = posts.user_id
GROUP BY users.user_id, users.username, users.post_count;

SELECT *
FROM view_user_statistics;