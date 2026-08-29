-- PORTAFOLIO DATA ANALYTICS
-- Michael Estiven Pachón Moncada
-- Dataset sintético de demostración

-- 1. Ventas por mes
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS sales,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    AVG(amount) AS avg_line_value
FROM ventas
WHERE order_date >= '2025-01-01'
  AND order_date < '2026-07-01'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- 2. Ventas por ciudad
SELECT
    city,
    SUM(amount) AS sales,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(amount) / COUNT(DISTINCT order_id) AS avg_ticket
FROM ventas
GROUP BY city
ORDER BY sales DESC;

-- 3. Clientes de mayor valor
SELECT
    customer_id,
    SUM(amount) AS total_spent,
    COUNT(DISTINCT order_id) AS orders
FROM ventas
GROUP BY customer_id
HAVING SUM(amount) > 3000000
ORDER BY total_spent DESC;

-- 4. Ticket promedio REAL
-- Primero calculamos el total de cada orden.
WITH order_totals AS (
    SELECT
        order_id,
        customer_id,
        city,
        SUM(amount) AS order_total
    FROM ventas
    GROUP BY order_id, customer_id, city
)
SELECT
    city,
    AVG(order_total) AS avg_ticket
FROM order_totals
GROUP BY city
ORDER BY avg_ticket DESC;

-- 5. Funnel de ecommerce
WITH cte_page_view AS (
    SELECT DISTINCT user_id
    FROM eventos_funnel
    WHERE event_name = 'page_view'
),
cte_view_item AS (
    SELECT DISTINCT user_id
    FROM eventos_funnel
    WHERE event_name = 'view_item'
),
cte_add_to_cart AS (
    SELECT DISTINCT user_id
    FROM eventos_funnel
    WHERE event_name = 'add_to_cart'
),
cte_purchase AS (
    SELECT DISTINCT user_id
    FROM eventos_funnel
    WHERE event_name = 'purchase'
)
SELECT
    (SELECT COUNT(*) FROM cte_page_view) AS page_view_users,
    (SELECT COUNT(*) FROM cte_view_item) AS view_item_users,
    (SELECT COUNT(*) FROM cte_add_to_cart) AS add_to_cart_users,
    (SELECT COUNT(*) FROM cte_purchase) AS purchase_users;
