WITH events AS (
    SELECT
        user_id,
        event_name,
        event_time::date AS event_date
    FROM dwh.events
    WHERE event_date BETWEEN DATE '2025-07-01' AND DATE '2025-07-31'
),
step1 AS (
    SELECT DISTINCT user_id
    FROM events
    WHERE event_name = 'app_launch'
),
step2 AS (
    SELECT DISTINCT e.user_id
    FROM events e
    JOIN step1 s ON e.user_id = s.user_id
    WHERE e.event_name = 'view_catalog'
),
step3 AS (
    SELECT DISTINCT e.user_id
    FROM events e
    JOIN step2 s ON e.user_id = s.user_id
    WHERE e.event_name = 'checkout'
)
SELECT
    'Step 1: App Launch' AS step,
    COUNT(*) AS users_count
FROM step1
UNION ALL
SELECT
    'Step 2: View Catalog' AS step,
    COUNT(*) AS users_count
FROM step2
UNION ALL
SELECT
    'Step 3: Checkout' AS step,
    COUNT(*) AS users_count
FROM step3;
