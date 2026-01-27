USE social_network_pro;

CREATE VIEW view_users_summary AS
SELECT
	users.user_id, users.username, COUNT(posts.post_id) AS TotalPosts
    FROM users 
LEFT JOIN posts ON users.user_id = posts.user_id
GROUP BY users.user_id, users.username;

SELECT *
FROM view_users_summary
WHERE TotalPosts > 5;