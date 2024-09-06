# Vehicles Sales Based on SQL and Power BI

### Contents
- [Project Overview](#project-overview)
- [Data Source](#data-source)
- [Data Cleaning and Preparation with Excel](#data-cleaning-and-preparation-with-excel)
- [Data Extraction by MySQL](#data-extraction-by-mysql)
- [Creating the dashboard by Power BI](#creating-the-dashboard-by-power-bi)
- [Insights and Trends](#insights-and-trends)


### Project Overview

This project focuses on analyzing vehicle sales data using SQL for database management and querying, and Power BI for visualization and reporting. The dataset includes vehicle sales information such as product, model, ordering dates, sales volume, price, and regional performance. SQL was utilized to clean, structure, and query the data, providing insights into sales trends, top-selling models, and regional sales distribution. Power BI dashboards visualize key metrics like total sales by region, sales growth over time, and product performance, enabling data-driven decision-making for optimizing sales strategies in the automotive industry.

### Data Source
Original data used is from this [Kaggle link.](https://www.kaggle.com/datasets/kyanyoga/sample-sales-data/data)

### Data Cleaning and Preparation with Excel

- Generally, this dataset did not need much cleaning. I deleted useless rows, checked for duplicates and empty rows, and searched for illogical values like negative quantities and percentages that are greater than 100%.
- I re-formated the date column to `yyyy-mm-dd` so it would be suitable for SQL for later use.
- There was a problem with the price column, where prices larger than 100 seemed to be inserted as 100 no matter how much they were. I fixed it by dividing sales for each product by the quantity ordered, to find the price of each piece.
- Another problem was that in the territory column, "APAC" was mistakingly replaced with "Japan". With a simple usage of `Find & Select > Replace` in Excel's ribbon, the problem was solved.

### Data Extraction by MySQL

Using SQL, I extracted snippets of data to be used later for further exploration by visualizations and charts. Here are they:

To begin with, I realized that in the country column, Japan was replaced with APAC, so I changed it using:

```
UPDATE sales
SET country = 'Japan'
WHERE country = 'APAC'
```


1. For quantity ordered:

```
SELECT SUM(quantity_ordered) as quantity_ordered
FROM sales
```

 - On 2003

```
SELECT SUM(quantity_ordered) as quantity_ordered
FROM sales
WHERE YEAR(order_date) = '2003'
```

And the same query for `2004`, by replacing `2003` with `2004`.



2. Products by quantity sold for each:

  - On 2003
```
SELECT productline, SUM(quantity_ordered) AS qnt
FROM sales
WHERE status = 'Shipped' AND YEAR(order_date) = '2003'
GROUP BY productline
ORDER BY sales DESC
```

And the same query for `2004`, by replacing `2003` with `2004`.



3. Most sold product by country:

```
WITH cte as(
  SELECT country, productline, SUM(quantity_ordered) as quantity,
    ROW_NUMBER() OVER(PARTITION BY country ORDER BY SUM(quantity_ordered) DESC) as rn
  FROM sales
  GROUP BY country, productline
)
SELECT country, productline, quantity
FROM cte
WHERE rn = 1
ORDER BY quantity DESC
```



4. Total revenue:

```
SELECT SUM(sales) as revenue
FROM sales
WHERE status = 'Shipped'
```



5. Sales by country:

```
SELECT country, SUM(sales) as sales
FROM sales
WHERE status = 'Shipped'
GROUP BY country
ORDER BY sales DESC
```



6. Top 10 countries by sales:

- On 2003:

```
SELECT country, SUM(sales) as sales
FROM sales
WHERE status = 'Shipped' AND YEAR(order_date) = '2003'
GROUP BY country
ORDER BY sales DESC
LIMIT 10
```

And the same query for `2004`, by replacing `2003` with `2004`.




7. Sales by territory, to analyze general distribution:

```
SELECT territory, SUM(sales) as sales
FROM sales
GROUP BY territory
ORDER by sales DESC
```



8. Sales per territory by time, to measure distribution with time:

- On 2003:
 
```
SELECT territory, MONTH(order_date) AS month, SUM(sales) AS sales
FROM sales
WHERE YEAR(order_date) = '2003'
GROUP BY territory, month
ORDER BY month, territory DESC
```


And the same query for `2004`, by replacing `2003` with `2004`.



9. Sales by 24-months time period:

```
with cte AS(
  SELECT
    CONCAT(YEAR(order_date), '-', LPAD(MONTH(order_date), 2, '0')) AS month_year,
    SUM(sales) AS sale
  FROM sale
  WHERE status = 'Shipped' AND YEAR(order_date) <> '2005'
  GROUP BY month_year
)
SELECT month_year, sales,
  ROW_NUMBER() OVER(ORDER BY month_year) as month
FROM cte
```



10. Most profitable products:

- On 2003:

```
SELECT productline, SUM(sales) AS sales
FROM sales
WHERE status = 'Shipped' AND YEAR(order_date) = '2003'
GROUP BY productline
ORDER BY sales DESC
```

And the same query for `2004`, by replacing `2003` with `2004`.



11. Sales by quarters:

- In the first quarter of 2003:
 
```
SELECT qtr_id, SUM(sales) as sales
FROM sales
WHERE status = 'Shipped' AND YEAR(order_date) = '2003' AND qtr_id = '1'
GROUP BY qtr_id
ORDER BY sales DESC
```

And the same query for `2004`, by replacing `2003` with `2004`, and replacing quarters with `2`, `3`, and `4`.



12. Number of customers:

- Total:

```
SELECT COUNT(DISTINCT(customer_name)) as num_of_customers
FROM sales
```

- On 2003:
```
SELECT COUNT(DISTINCT(customer_name)) as num_of_customers
FROM sales
WHERE YEAR(order_date) = '2003'
```

And the same query for `2004`, by replacing `2003` with `2004`.



13. Number of countries involved:

```
SELECT COUNT(DISTINCT country) as num_of_countries
FROM sales
```




### Creating the dashboard by Power BI



Using the snippets of data extracted above by SQL, the dashboard was created, featuring trends and insights. Here is the result.

![p1](https://github.com/user-attachments/assets/e145d149-239e-4fc3-a721-725a9f531808)
![p2](https://github.com/user-attachments/assets/b72c621f-1a7b-48af-a2bc-6704d2ce0952)
![p3](https://github.com/user-attachments/assets/e2a196b6-b6d2-4dd7-996f-ea420319fbd4)



### Insights and Trends

- Sales increase at the end of both years. It is an interesting fact that needs further investigation about the reasons.
- Classic cars make the vast majority of sales. Vintage cars come after.
- Classic cars make the vast majority of sales because they are the most sold product, and, as expected, are followed by vintage cars.
- USA, Spain, France, and Norway make the most sales, but looking at the bar chart, it seems that the USA makes more than the rest of the 3 combined. To make more than a mere notice, I used SQL to analyze, as follows:

  - Sales for USA:
```
SELECT SUM(sales), country
FROM sales
WHERE YEAR(order_date) = '2003' AND country = 'USA' AND status = 'Shipped'
```

  - Sales for Spain, France, and Norway combined:
```
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
```
 I could've used SQL to decide whether the sales are more or not, just for the fun of it ;)
 
 Using the calculator, it turned out that the USA, indeed, makes more sales than the rest of the 3 countries combined, by `333,909`. 
- Sales in 2004 generally increased, the number of customers increased, as well as the countries involved. It is generally a positive growth.
- In all 4 quarters in both years, 2004 made more sales.
- I wanted to calculate the churn rate (percentage of customers who stopped purchasing from 2003 in 2004). I used the following query to calculate customers who made their last purchase in 2003:
```
SELECT customer_name, MAX(order_date) as last_date
FROM sales
GROUP BY customer_name
ORDER BY last_date
```
There wasn't any data before January 2004, and since churn rate is calculated with the equation ` number of customers who made their last purchase in 2003 / number of total customers in 2004`, we conclude that the churn rate is 0%, hurray! That usually indicates that all customer continued to buy the product, and they are likely satisfied with the service.






