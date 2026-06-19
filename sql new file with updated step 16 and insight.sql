-- Step 1: Create a new schema (database) for the project
CREATE DATABASE bank_project;
-- Step 2: Switch into that schema so all tables go here
USE bank_project;
SHOW TABLES;
RENAME TABLE `banking churn sql poject` TO bank_churn;
-- Step 3: Inspect the structure of the new table
DESCRIBE bank_churn;
-- Step:3A Find shape of the dataset (rows × columns)

-- Total rows
SELECT COUNT(*) AS total_rows
FROM bank_churn;

-- Total columns
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bank_churn';

-- step:3B Find data types of all columns in bank_churn

SELECT COLUMN_NAME AS column_name,
       DATA_TYPE AS data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bank_churn';

-- step:3C Fix datatypes for better consistency

ALTER TABLE bank_churn
MODIFY Balance DECIMAL(15,2),
MODIFY EstimatedSalary DECIMAL(15,2),
MODIFY Surname VARCHAR(50),
MODIFY Gender VARCHAR(10),
MODIFY Geography VARCHAR(50);

-- step:3D FIND UNIQUE VALUES

-- Unique values in Geography
SELECT DISTINCT Geography FROM bank_churn;

-- Unique values in Gender
SELECT DISTINCT Gender FROM bank_churn;

-- Unique values in NumOfProducts
SELECT DISTINCT NumOfProducts FROM bank_churn;

-- Unique values in HasCrCard
SELECT DISTINCT HasCrCard FROM bank_churn;

-- Unique values in IsActiveMember
SELECT DISTINCT IsActiveMember FROM bank_churn;

-- Unique values in Exited
SELECT DISTINCT Exited FROM bank_churn;

-- Step 4: Count how many rows were imported
SELECT COUNT(*) FROM bank_churn;

-- Step 4A:  Check for duplicates
SELECT CustomerId, COUNT(*) AS count
FROM bank_churn
GROUP BY CustomerId
HAVING COUNT(*) > 1;

-- step 4B: CHECK FOR NULL VALUES
SELECT *
FROM bank_churn
WHERE CustomerId IS NULL
   OR Geography IS NULL
   OR Gender IS NULL
   OR Age IS NULL
   OR Balance IS NULL
   OR CreditScore IS NULL
   OR EstimatedSalary IS NULL;

-- Step 5: Preview the first 10 rows of data
SELECT * FROM bank_churn LIMIT 10;
-- Step 6: Calculate overall churn rate (percentage of customers who exited)
SELECT ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate 
FROM bank_churn;
-- Step 7: Churn by country/region
SELECT Geography, 
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY Geography;
-- Step 8: Churn by age groups
SELECT CASE 
           WHEN Age < 30 THEN 'Under 30'
           WHEN Age BETWEEN 30 AND 50 THEN '30-50'
           ELSE 'Over 50'
       END AS age_group,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY age_group;
-- Step 9: Churn by tenure (years with bank)
SELECT Tenure, 
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY Tenure
ORDER BY Tenure;
-- Step 10: Find lowest and highest credit scores and churn by credit scores
SELECT MIN(CreditScore) AS lowest_score,
       MAX(CreditScore) AS highest_score
FROM bank_churn;
SELECT CASE 
           WHEN CreditScore < 500 THEN 'Poor (<500)'
           WHEN CreditScore BETWEEN 500 AND 650 THEN 'Fair (500-650)'
           WHEN CreditScore BETWEEN 651 AND 750 THEN 'Good (651-750)'
           ELSE 'Excellent (>750)'
       END AS credit_band,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY credit_band
ORDER BY credit_band;
-- Step 11: Find min, avg, and max balance,and churn by balance
SELECT 
    MIN(Balance) AS min_balance,
    AVG(Balance) AS avg_balance,
    MAX(Balance) AS max_balance
FROM bank_churn;
SELECT CASE 
           WHEN Balance = 0 THEN 'Zero Balance'
           WHEN Balance BETWEEN 1 AND 50000 THEN 'Low (1-50k)'
           WHEN Balance BETWEEN 50001 AND 100000 THEN 'Medium (50k-100k)'
           ELSE 'High (>100k)'
       END AS balance_band,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY balance_band          
ORDER BY balance_band;
-- Step 12: Find min and max number of products,Churn by number of products
SELECT 
    MIN(NumOfProducts) AS min_products,
   MAX(NumOfProducts) AS max_products
FROM bank_churn;
SELECT NumOfProducts,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;
-- Step 13: Gender unique values, counts, and churn rate
SELECT Gender,
       COUNT(*) AS total_customers,
       SUM(Exited) AS churned_customers,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY Gender;
-- Step 14: Churn by Has Credit Card ,min/max holders
SELECT HasCrCard,
       COUNT(*) AS total_customers,
       SUM(Exited) AS churned_customers,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY HasCrCard;
-- Step 15: Churn by Active Member
SELECT IsActiveMember,
       COUNT(*) AS total_customers,
       SUM(Exited) AS churned_customers,
       ROUND(SUM(Exited)*100.0/COUNT(*),2) AS churn_rate,
       MIN(IsActiveMember) AS min_active_status,
       MAX(IsActiveMember) AS max_active_status
FROM bank_churn
GROUP BY IsActiveMember;

-- Step 16: Top 10 customers by balance

SELECT CustomerId,
       Geography,
       Balance
FROM bank_churn
ORDER BY Balance DESC
LIMIT 10;
-- ============================
-- 📊 INSIGHTS / SUMMARY
-- ============================

-- 1. Overall churn rate is ~20%.
-- 2. France shows higher churn compared to Spain and Germany.
-- 3. Female customers churn slightly more than male customers.
-- 4. Middle-aged customers (40–50) have higher churn risk.
-- 5. Customers with zero balance churn more often (inactive accounts).
-- 6. Customers with multiple products are more loyal.
-- 7. Business takeaway: focus retention on French & middle-aged segments,
--    encourage cross-selling, and re-engage inactive accounts.
-- 8. Spain accounts for half of the top 10 highest-balance customers, indicating a strong concentration of high-value customers in that region.
