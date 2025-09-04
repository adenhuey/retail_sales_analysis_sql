CREATE TABLE retail_sales 
			( 
				transactions_id INT,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(25,
				quantity INT,
				price_per_unit INT,
				cogs INT,
				total_sale INT,
			)
-- Number of rows in dataset
SELECT COUNT(*) FROM retail_sales;

-- ======================================
-- Data Cleaning
-- ======================================

-- All the rows with NULL values
SELECT * FROM retail_sales WHERE 
	transactions_id IS NULL OR 
	sale_date IS NULL OR 
	sale_time IS NULL OR
	customer_id IS NULL OR 
	gender IS NULL OR 
	age IS NULL OR
	category IS NULL OR
	quantity IS NULL OR 
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

-- Removing all the rows that contain null values
DELETE FROM retail_sales 
WHERE transactions_id IS NULL OR 
	sale_date IS NULL OR 
	sale_time IS NULL OR
	customer_id IS NULL OR 
	gender IS NULL OR 
	age IS NULL OR
	category IS NULL OR
	quantity IS NULL OR 
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

-- ======================================
-- Data Exploration
-- ======================================

-- Total number of records
SELECT COUNT(*) FROM retail_sales;

-- Number of distinct customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- All the categories of purchases
SELECT DISTINCT category FROM retail_sales;

-- ======================================
-- Data Analysis and Business Problems 
-- ======================================

-- Sales made on 2022-11-05
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT * FROM retail_sales 
WHERE category = 'Clothing' AND quantity > 3 AND DATE_TRUNC('month', sale_date)::date= DATE '2022-11-01';

-- Total sales for each category.
SELECT category, SUM(total_sale) FROM retail_sales
GROUP BY category;

-- Average total sale per category
SELECT category, AVG(total_sale) FROM retail_sales
GROUP BY category;

-- Average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age) FROM retail_sales
WHERE category = 'Beauty';

-- Transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Total number of transactions made by each gender in each category.
SELECT gender, category, COUNT(transactions_id) FROM retail_sales
GROUP BY gender, category;

-- The best-selling month for each year based on the average total_sale for each month.
SELECT * FROM (
		SELECT EXTRACT('month' FROM sale_date) AS month, EXTRACT('year' FROM sale_date) AS year,
			AVG(total_sale) AS avg_total_sale,
			RANK() OVER(PARTITION BY EXTRACT('year' FROM sale_date) ORDER BY AVG(total_sale) DESC)
		FROM retail_sales
		GROUP BY month, year
		) AS table1
WHERE rank = 1;

-- Top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) AS total_purchase FROM retail_sales
GROUP BY customer_id
ORDER BY total_purchase DESC
LIMIT 5;

-- Number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) FROM retail_sales
GROUP BY category;

-- Total number of transactions for each shift (Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
	CASE WHEN EXTRACT('hour' FROM sale_time) <=12 THEN 'Morning'
		 WHEN EXTRACT('hour' FROM sale_time) >12 AND EXTRACT('hour' FROM sale_time) <= 17 THEN 'Afternoon'
		 ELSE 'Evening' END AS shift,
	COUNT(*) FROM retail_sales
GROUP BY shift;

--End of Project