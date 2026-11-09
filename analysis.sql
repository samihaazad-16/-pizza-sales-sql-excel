-- Retail sales analysis for a fictional pizza shop.
-- Run after loading the three CSVs into the tables defined in schema.sql.
-- Prices are stored in cents. Reported revenue excludes tax, tips and fees.

-- Join orders, order lines, and products at the order-line level.
CREATE VIEW sales_detail AS
SELECT
    o.order_id,
    o.order_date,
    o.channel,
    l.line_number,
    p.product_id,
    p.product_name,
    p.category,
    l.quantity,
    l.unit_price_cents,
    l.quantity * l.unit_price_cents AS revenue_cents
FROM order_lines AS l
JOIN orders AS o ON l.order_id = o.order_id
JOIN products AS p ON l.product_id = p.product_id;

-- Monthly revenue and orders. DISTINCT prevents counting one order twice.
CREATE VIEW monthly_sales AS
SELECT
    SUBSTR(order_date, 1, 7) AS month,
    SUM(revenue_cents) / 100.0 AS revenue_usd,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units
FROM sales_detail
GROUP BY SUBSTR(order_date, 1, 7);

-- Revenue by category.
CREATE VIEW category_sales AS
SELECT
    category,
    SUM(revenue_cents) / 100.0 AS revenue_usd,
    SUM(quantity) AS units
FROM sales_detail
GROUP BY category;

-- Rank products by revenue and keep ties at the same rank.
CREATE VIEW product_sales AS
WITH product_totals AS (
    SELECT
        product_id,
        product_name,
        SUM(revenue_cents) / 100.0 AS revenue_usd,
        SUM(quantity) AS units
    FROM sales_detail
    GROUP BY product_id, product_name
)
SELECT
    DENSE_RANK() OVER (ORDER BY revenue_usd DESC) AS revenue_rank,
    product_id,
    product_name,
    revenue_usd,
    units
FROM product_totals;

-- Revenue and distinct orders by order channel.
CREATE VIEW channel_sales AS
SELECT
    channel,
    SUM(revenue_cents) / 100.0 AS revenue_usd,
    COUNT(DISTINCT order_id) AS orders
FROM sales_detail
GROUP BY channel;

-- Run these SELECT statements individually to explore the results.
SELECT * FROM monthly_sales ORDER BY month;
SELECT * FROM category_sales ORDER BY revenue_usd DESC, category;
SELECT * FROM product_sales ORDER BY revenue_rank, product_id;
SELECT * FROM channel_sales ORDER BY revenue_usd DESC, channel;

-- Both differences should be zero. Check joins and orders without items.
SELECT
    (SELECT COUNT(*) FROM order_lines)
        - (SELECT COUNT(*) FROM sales_detail) AS missing_joined_lines,
    (SELECT COUNT(*) FROM orders)
        - (SELECT COUNT(DISTINCT order_id) FROM sales_detail) AS orders_without_lines;
