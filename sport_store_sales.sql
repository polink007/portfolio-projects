SELECT * 
FROM  myportfolio-396320.sports_store.orders

-- 1. KPIs for Total Revenue, Profit, Number of Orders, Profit Margin

SELECT
  SUM(revenue) AS total_revenue,
  SUM(profit) AS total_profit,
  COUNT(order_id) AS total_orders,
  SUM(profit) / SUM(revenue) * 100 AS profit_margin
FROM 
  myportfolio-396320.sports_store.orders


-- 2. Total Revenue, Profit, Number of Orders, Profit Margin for each Sport

SELECT
  sport,
  ROUND(SUM(revenue), 2) AS total_revenue,
  ROUND(SUM(profit), 2 )AS total_profit,
  COUNT(order_id) AS total_orders,
  ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS profit_margin
FROM 
  myportfolio-396320.sports_store.orders
GROUP BY
  sport
ORDER BY
  profit_margin DESC


-- 3. Number of Customer ratings, and the average rating
SELECT
  (SELECT COUNT (*) FROM myportfolio-396320.sports_store.orders WHERE rating IS NOT NULL) AS number_of_reviews,
  ROUND(AVG (rating), 2 )AS average_rating,
FROM 
  myportfolio-396320.sports_store.orders


-- 4. Number of People for Each rating, and its revenue, profit, profit margin

SELECT
  rating,
  ROUND(SUM(revenue), 2)AS total_revenue,
  ROUND(SUM(profit), 2)AS total_profit,
  ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS profit_margin
FROM 
  myportfolio-396320.sports_store.orders
WHERE
  rating IS NOT NULL
GROUP BY
  rating
ORDER BY
  rating DESC


  -- 5. State revenue, profit, profit margin

SELECT
    c.state,
    row_number() OVER (ORDER BY SUM(o.revenue) DESC) AS revenue_rank,
    SUM(o.revenue) as total_revenue,
    row_number() OVER (ORDER BY SUM(o.profit) DESC) AS profit_rank,
    SUM(o.profit) as total_profit,
    row_number() OVER (ORDER BY SUM(o.profit) / SUM(o.revenue) * 100 DESC) AS margin_rank,
    SUM(o.profit) / SUM(o.revenue) * 100 AS profit_margin
FROM 
  myportfolio-396320.sports_store.orders AS o
INNER JOIN
  myportfolio-396320.sports_store.customers AS c
ON
  o.customer_id = c.customer_id
GROUP BY 
  c.state
ORDER BY
  margin_rank


-- 6. Monthly Profits

WITH monthly_profit AS (SELECT
  EXTRACT(month FROM date) AS month,
  ROUND(SUM(profit), 2) AS total_profit
FROM 
  myportfolio-396320.sports_store.orders
WHERE EXTRACT(month FROM date) IS NOT NULL
GROUP BY
  month)

SELECT
  month,
  total_profit,
  lag(total_profit) OVER (ORDER BY month) AS previous_month_profit,
  total_profit - lag(total_profit) OVER (ORDER BY month) AS profit_difference
FROM
  monthly_profit
ORDER BY
  month



