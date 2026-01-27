USE social_network_pro;

EXPLAIN ANALYZE
SELECT * 
FROM posts
WHERE user_id = 1 AND created_at BETWEEN '2026-01-01' AND '2026-12-31';

CREATE INDEX idx_created_user_id ON posts(created_at, user_id);

SELECT *
FROM users
WHERE email = 'an@gmail.com';

CREATE UNIQUE INDEX idx_email ON users(email);
SHOW INDEX FROM users;

DROP INDEX idx_created_user_id ON posts;
DROP INDEX idx_email ON users;