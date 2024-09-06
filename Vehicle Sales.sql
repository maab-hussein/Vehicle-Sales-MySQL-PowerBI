SELECT order_num, territory, MONTH(order_date) AS month, SUM(sales) AS sales
FROM sales
WHERE YEAR(order_date) = '2003'
GROUP BY territory, month
ORDER BY month, territory DESC


SELECT order_num, territory, MONTH(order_date) AS month, SUM(sales) AS sales
FROM sales
WHERE YEAR(order_date) = '2004'
GROUP BY territory, month
ORDER BY month, territory DESC



SELECT qtr_id, SUM(sales) as sales, YEAR(order_date) AS year
FROM sales
WHERE status = 'Shipped' AND qtr_id = '1' AND YEAR(order_date) <> '2005'
GROUP BY year, qtr_id
ORDER BY qtr_id

SELECT qtr_id, SUM(sales) as sales, YEAR(order_date) AS year
FROM sales
WHERE status = 'Shipped' AND qtr_id = '2' AND YEAR(order_date) <> '2005'
GROUP BY year, qtr_id
ORDER BY qtr_id

SELECT qtr_id, SUM(sales) as sales, YEAR(order_date) AS year
FROM sales
WHERE status = 'Shipped' AND qtr_id = '3' AND YEAR(order_date) <> '2005'
GROUP BY year, qtr_id
ORDER BY qtr_id

SELECT qtr_id, SUM(sales) as sales, YEAR(order_date) AS year
FROM sales
WHERE status = 'Shipped' AND qtr_id = '4' AND YEAR(order_date) <> '2005'
GROUP BY year, qtr_id
ORDER BY qtr_id


SELECT SUM(sales), country
FROM sales
WHERE YEAR(order_date) = '2003' AND country = 'USA' AND status = 'Shipped'


with cte1 AS(
SELECT country, SUM(sales) as sales1
FROM sales
WHERE YEAR(order_date) = '2003' AND country = 'Spain' AND status = 'Shipped'
),
cte2 AS(
SELECT country, SUM(sales) as sales2
FROM sales
WHERE YEAR(order_date) = '2003' AND country = 'France' AND status = 'Shipped'
),
cte3 AS(
SELECT country, SUM(sales) as sales3
FROM sales
WHERE YEAR(order_date) = '2003' AND country = 'Australia' AND status = 'Shipped'
)
SELECT sales1 + sales2 + sales3 AS total_sales
FROM cte1 join cte2 join cte3 on cte1.country = cte2.country = cte3.country


with last_purchase_date AS(
SELECT customer_name, MAX(order_date) as last_date
FROM sales
GROUP BY customer_name
ORDER BY last_date




















