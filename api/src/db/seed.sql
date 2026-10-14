TRUNCATE orders, users RESTART IDENTITY;

INSERT INTO users (created_at, username, email)
SELECT
  NOW() - (INTERVAL '90 days' + random() * INTERVAL '90 days'),
  'user_' || i,
  'user_' || i || '@email.com'
FROM generate_series(1, 1000) AS i;

INSERT INTO orders (created_at, user_id, total_cents, currency, status)
SELECT 
  NOW() - (random() * INTERVAL '90 days'),
  1 + floor(random() * 1000)::int,
  1 + floor(random() * 100000)::int,
  (ARRAY['usd', 'eur', 'gbp'])[1 + floor(random() * 3)::int],
  (ARRAY['pending', 'fulfilled', 'canceled'])[1 + floor(random() * 3)::int]
FROM generate_series(1, 1000000) AS i;

ANALYZE users;
ANALYZE orders;