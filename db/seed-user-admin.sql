-- 初回用: admin ユーザーを 1 件作成
-- 実行例（プロジェクトルートで）: docker exec -i mysql mysql -u root -p myapp < db/seed-user-admin.sql
-- ログイン: email = admin@example.com / パスワード = admin123
-- 既に同じ email がいる場合は INSERT をスキップするため、重複実行してもエラーにはなりません。

SET NAMES utf8mb4;

INSERT INTO user (name, email, password, createdAt, updatedAt)
SELECT 'Admin', 'admin@example.com', '$2b$10$ZAU0O0dCoQqYbAIbAp8LBuPpJdkYv2Pk2F9xavgz2uuMJVLmeSF4q', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM user WHERE email = 'admin@example.com' LIMIT 1);

INSERT INTO user_meta (userId, metaKey, metaValue, createdAt, updatedAt)
SELECT u.id, 'role', 'admin', NOW(), NOW()
FROM user u
WHERE u.email = 'admin@example.com'
  AND NOT EXISTS (SELECT 1 FROM user_meta m WHERE m.userId = u.id AND m.metaKey = 'role' LIMIT 1);
