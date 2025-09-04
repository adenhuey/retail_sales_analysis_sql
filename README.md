# Retail Sales Analysis (PostgreSQL)

This project analyzes retail sales transactions using **PostgreSQL**.  
It demonstrates **data cleaning, exploration, and business-driven SQL queries** to extract insights.

---

## Project Overview
**Dataset:** `retail_sales.csv`  

**Key Business Questions Answered:**
- What are the sales made on **2022-11-05**?
- Which transactions are in the category **Clothing** with quantity > 10 in **Nov-2022**?
- What are the **total sales** for each category of items?
- What is the **average age** of customers who purchased items from **Beauty**?
- Which transactions have **total_sale > 1000**?
- What is the total number of transactions made by **each gender in each category**?
- What is the **best-selling month** for each year?
- Who are the **top 5 customers** by spending?
- How many **unique customers** purchased from each category?
- How many transactions occurred in each **shift** (Morning, Afternoon, Evening)?

---

## Project Structure

### **1. Data Setup**
A table named **`retail_sales`** is created to store transaction data:

```sql
CREATE TABLE retail_sales (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(25),
    quantity INT,
    price_per_unit INT,
    cogs INT,
    total_sale INT
);
```
### **2. Data Cleaning**
Finding rows with NULL values

```sql
SELECT * FROM retail_sales
WHERE transactions_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL 
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```
Deleting rows with NULL values
```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL 
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```
### **3. Data Exploration**
Total number of records
```sql
SELECT COUNT(*) FROM retail_sales;
```
Number of distinct customers
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;
```
All purchase categories
```sql
SELECT DISTINCT category FROM retail_sales;
```
### **4. Data Analysis**
Sales made on 2022-11-05
```sql
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';
```
Clothing transactions with quantity > 3 in Nov-2022
```sql
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
  AND quantity > 3 
  AND DATE_TRUNC('month', sale_date)::date = DATE '2022-11-01';
```
Total sales per category
```sql
SELECT category, SUM(total_sale) 
FROM retail_sales
GROUP BY category;
```
Average customer age in Beauty category
```sql
SELECT AVG(age) 
FROM retail_sales
WHERE category = 'Beauty';
```
Transactions with total_sale > 1000
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

Number of transactions by gender and category
```sql
SELECT gender, category, COUNT(transactions_id) 
FROM retail_sales
GROUP BY gender, category;
```

Best-selling month per year
```sql
SELECT * FROM (
    SELECT EXTRACT('month' FROM sale_date) AS month,
           EXTRACT('year' FROM sale_date) AS year,
           AVG(total_sale) AS avg_total_sale,
           RANK() OVER(PARTITION BY EXTRACT('year' FROM sale_date) ORDER BY AVG(total_sale) DESC)
    FROM retail_sales
    GROUP BY month, year
) ranked_sales
WHERE rank = 1;
```

Top 5 customers by total spending
```sql
SELECT customer_id, SUM(total_sale) AS total_purchase
FROM retail_sales
GROUP BY customer_id
ORDER BY total_purchase DESC
LIMIT 5;
```
Unique customers per category
```sql
SELECT category, COUNT(DISTINCT customer_id) 
FROM retail_sales
GROUP BY category;
```

Transactions by shift (Morning, Afternoon, Evening)
```sql
SELECT 
    CASE 
        WHEN EXTRACT('hour' FROM sale_time) <= 12 THEN 'Morning'
        WHEN EXTRACT('hour' FROM sale_time) > 12 AND EXTRACT('hour' FROM sale_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) 
FROM retail_sales
GROUP BY shift;
```

## Findings

- **Customer Demographics:** Purchases come from a wide range of age groups across multiple categories.  
- **Sales Trends:** Sales peaked in **July 2022** and **February 2023**.  
- **Customer Insights:** Highest spending occurred in **Electronics**, followed by **Clothing** and **Beauty**.  

