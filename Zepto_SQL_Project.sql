drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR (150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows

SELECT COUNT (*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--looking for null values
SELECT * FROM zepto
WHERE name IS NULL 
OR 
category IS NULL
OR
mrp IS NULL 
OR
discountpercent IS NULL 
OR
discountedsellingprice IS NULL 
OR
weightingms IS NULL 
OR
availableQuantity IS NULL 
OR
outofstock IS NULL 
OR
quantity IS NULL; 

--different categories 
SELECT DISTINCT category FROM zepto
ORDER BY category;

--products in and out of stock
SELECT outofstock, COUNT(sku_id) 
FROM zepto 
GROUP BY outofstock;

--product names present multiple times
SELECT name,COUNT(Sku_id) as "Number of SKUS"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning
--products with price=0
SELECT * FROM zepto 
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM ZEPTO 
WHERE mrp=0;

--converting the mrp from paisas to rupees
UPDATE zepto SET mrp= mrp/100.0, 
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto;

-- 1. Find the top 10 best value products based on discounted percentage

SELECT DISTINCT name, mrp, discountpercent 
FROM zepto 
ORDER BY discountpercent DESC
LIMIT 10;

-- 2. what are the products with high mrp but out of stock?
SELECT DISTINCT name, mrp FROM zepto
WHERE outofstock= TRUE and mrp > 300
ORDER BY mrp DESC;

-- 3. Calculate estimated revenue for each category
SELECT category,
SUM(discountedsellingprice * availablequantity) as Total_revenue 
FROM zepto
GROUP BY category
ORDER BY Total_revenue;

-- 4. Find all products where MRP is greater than 500 and discount is <10%
SELECT DISTINCT name, mrp, discountpercent 
FROM zepto
WHERE mrp > 500 and discountpercent<10
ORDER BY mrp DESC, discountpercent DESC;

-- 5. Identify the top 5 categories offering the highest average discount percentage
SELECT DISTINCT category, ROUND(AVG(discountpercent),2) as avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- 6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) as price_per_gram
FROM zepto
WHERE weightingms = 100
ORDER BY price_per_gram;

-- 7. Group the products in categories like low, medium and bulk.
SELECT DISTINCT name, weightingms,
CASE WHEN weightingms <1000 THEN 'LOW'
     WHEN weightingms <5000 THEN 'MEDIUM'
	 ELSE 'BULK'
	 END AS weight_category
FROM zepto;

-- 8. what is the Total Inventory Weight Per Category
SELECT category,
SUM(weightingms * availablequantity) as total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


