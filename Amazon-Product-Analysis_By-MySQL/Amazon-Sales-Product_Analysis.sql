CREATE DATABASE AmazonSalesProduct; 
use AmazonSalesProduct;

CREATE TABLE AmazonSales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(10,4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percentage FLOAT(11,9) NOT NULL,
    gross_income DECIMAL(10,4) NOT NULL,
    rating FLOAT(2,1) NOT NULL
);

select * from AmazonSales;

SELECT * FROM AmazonSales WHERE invoice_id IS NULL OR branch IS NULL OR city IS NULL OR customer_type IS NULL OR gender IS NULL OR product_line IS NULL OR unit_price IS NULL OR quantity IS NULL OR VAT IS NULL OR total IS NULL OR date IS NULL OR time IS NULL OR payment_method IS NULL OR cogs IS NULL OR gross_margin_percentage IS NULL OR gross_income IS NULL OR rating IS NULL;
SELECT invoice_id, COUNT(*) FROM AmazonSales GROUP BY invoice_id HAVING COUNT(*) > 1; 
ALTER TABLE AmazonSales MODIFY unit_price DECIMAL(10,2) NOT NULL; 
 UPDATE AmazonSales SET gender = UPPER(gender), customer_type = UPPER(customer_type); 
 
 ALTER TABLE AmazonSales ADD COLUMN timeofday VARCHAR(20);
ALTER TABLE AmazonSales ADD COLUMN dayname VARCHAR(10);
ALTER TABLE AmazonSales ADD COLUMN monthname VARCHAR(10);

UPDATE AmazonSales
SET 
    timeofday = CASE
        WHEN HOUR(time) >= 0 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END,
    dayname = DAYNAME(date),
    monthname = MONTHNAME(date);

#Distinct cities count:  
SELECT COUNT(DISTINCT city) FROM AmazonSales; 
#Branch-city mapping: 
SELECT branch, city FROM AmazonSales GROUP BY branch; 
#Distinct product lines:
 SELECT COUNT(DISTINCT product_line) FROM AmazonSales; 
 #Most frequent payment: 
 SELECT payment_method, COUNT(*) AS freq FROM AmazonSales GROUP BY payment_method ORDER BY freq DESC LIMIT 1; 
# Highest sales product line: 
SELECT product_line, SUM(quantity) AS total_sales FROM AmazonSales GROUP BY product_line ORDER BY total_sales DESC LIMIT 1;
#Monthly revenue: 
SELECT monthname, SUM(total) AS revenue FROM AmazonSales GROUP BY monthname ORDER BY revenue DESC; 
#Peak COGS month: 
SELECT monthname, SUM(cogs) AS total_cogs FROM AmazonSales GROUP BY monthname ORDER BY total_cogs DESC LIMIT 1; 
#Highest revenue product line: 
SELECT product_line, SUM(total) AS revenue FROM AmazonSales GROUP BY product_line ORDER BY revenue DESC LIMIT 1;
#Highest VAT product line: 
SELECT product_line, SUM(VAT) AS total_VAT FROM AmazonSales GROUP BY product_line ORDER BY total_VAT DESC LIMIT 1;
#Good/Bad sales column:
ALTER TABLE AmazonSales ADD COLUMN sales_performance VARCHAR(5);
SET @avg_sales = (SELECT AVG(total) FROM AmazonSales);
UPDATE AmazonSales SET sales_performance = IF(total > @avg_sales, 'Good', 'Bad');
#Branch exceeding avg products sold:
SELECT branch FROM (SELECT branch, AVG(quantity) AS avg_qty FROM AmazonSales GROUP BY branch) AS sub WHERE avg_qty > (SELECT AVG(quantity) FROM AmazonSales);
#Product line per gender: 
SELECT gender, product_line, COUNT(*) AS freq FROM AmazonSales GROUP BY gender, product_line ORDER BY gender, freq DESC;
#Avg rating per product line: 
SELECT product_line, AVG(rating) AS avg_rating FROM AmazonSales GROUP BY product_line ORDER BY avg_rating DESC;
#Highest revenue customer type: 
SELECT customer_type, SUM(total) AS revenue FROM AmazonSales GROUP BY customer_type ORDER BY revenue DESC LIMIT 1;
#Highest VAT % city: 
SELECT city, (SUM(VAT) / SUM(total)) * 100 AS VAT_pct FROM AmazonSales GROUP BY city ORDER BY VAT_pct DESC LIMIT 1;  
#Highest VAT customer type: 
SELECT customer_type, SUM(VAT) AS total_VAT FROM AmazonSales GROUP BY customer_type ORDER BY total_VAT DESC LIMIT 1; 
#Distinct customer types: 
SELECT COUNT(DISTINCT customer_type) FROM AmazonSales;
#Distinct payment methods: 
SELECT COUNT(DISTINCT payment_method) FROM AmazonSales; 
#Most frequent customer type: 
SELECT customer_type, COUNT(*) AS freq FROM AmazonSales GROUP BY customer_type ORDER BY freq DESC LIMIT 1; 
#Highest purchase freq customer type: 
SELECT customer_type, COUNT(*) AS purchases FROM AmazonSales GROUP BY customer_type ORDER BY purchases DESC LIMIT 1; 
#Predominant gender: 
SELECT gender, COUNT(*) AS count FROM AmazonSales GROUP BY gender ORDER BY count DESC LIMIT 1; 
#Gender distribution per branch: 
SELECT branch, gender, COUNT(*) AS count FROM AmazonSales GROUP BY branch, gender ORDER BY branch; 
#Sales per timeofday on weekdays: 
SELECT dayname, timeofday, COUNT(*) AS sales_count FROM AmazonSales WHERE dayname NOT IN ('Saturday', 'Sunday') GROUP BY dayname, timeofday ORDER BY sales_count DESC;
#Timeofday with most ratings: 
SELECT timeofday, COUNT(rating) AS rating_count FROM AmazonSales GROUP BY timeofday ORDER BY rating_count DESC LIMIT 1; 
#Highest rating timeofday per branch: 
SELECT branch, timeofday, AVG(rating) AS avg_rating FROM AmazonSales GROUP BY branch, timeofday ORDER BY branch, avg_rating DESC; 
#Day with highest avg ratings: 
SELECT dayname, AVG(rating) AS avg_rating FROM AmazonSales GROUP BY dayname ORDER BY avg_rating DESC LIMIT 1; 
#Highest avg rating day per branch: 
SELECT branch, dayname, AVG(rating) AS avg_rating FROM AmazonSales GROUP BY branch, dayname ORDER BY branch, avg_rating DESC;