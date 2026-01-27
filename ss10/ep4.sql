USE social_network_pro;

CREATE INDEX idx_hometown ON users(hometown);

DROP INDEX idx_hometown ON users;

EXPLAIN ANALYZE
SELECT users.user_id, users.username, posts.post_id, posts.content
FROM users
JOIN posts ON users.user_id = posts.user_id
WHERE users.hometown = 'Hà Nội'
ORDER BY users.username DESC
LIMIT 10;