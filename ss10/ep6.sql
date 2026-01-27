USE social_network_pro;

CREATE VIEW view_user_activity_status AS 
SELECT 
	users.user_id, users.username, users.gender, users.created_at,
    CASE
		WHEN COUNT(DISTINCT posts.post_id) > 1 OR COUNT(comments.comment_id) > 1
			THEN 'Active'
            ELSE 'Inactive'
		END AS status
FROM users
LEFT JOIN posts ON users.user_id = posts.user_id
LEFT JOIN comments ON users.user_id = comments.user_id
GROUP BY users.user_id, users.username, users.gender, users.created_at;

SELECT *
FROM view_user_activity_status;

SELECT
    status, COUNT(*) AS user_count
FROM view_user_activity_status
GROUP BY status
ORDER BY user_count DESC;