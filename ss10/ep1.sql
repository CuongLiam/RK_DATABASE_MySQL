USE social_network_pro;

CREATE VIEW view_user_post AS
SELECT
	users.user_id, COUNT(posts.post_id) AS TotalPosts
FROM users
LEFT JOIN posts ON users.user_id = posts.user_id
GROUP BY users.user_id;

SELECT * FROM view_user_post;

SELECT users.full_name, view_user_post.TotalPosts
FROM users
JOIN view_user_post ON users.user_id = view_user_post.user_id;