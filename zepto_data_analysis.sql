DROP TABLE IF EXISTS zepto;
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
-- dataset overview
SELECT * FROM zepto
LIMIT 15

-- no. of rows
SELECT COUNT(*) FROM zepto;

-- check null
SELECT * FROM zepto 
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

-- different product category
SELECT DISTINCT category
FROM zepto;

-- check stock vs out of stock
SELECT outofstock, COUNT(sku_id) FROM zepto
GROUP BY outofstock;

-- PRODUCT NAME which is more than 1
SELECT name, COUNT(name) AS Number_of_products FROM zepto
GROUP BY name
HAVING COUNT(name)>1
ORDER BY Number_of_products DESC;

-- data cleaning

-- product with price=0
SELECT * FROM zepto WHERE mrp=0 OR discountedsellingprice=0;

-- delete it 
DELETE FROM zepto
WHERE mrp=0;

-- convert mrp from paisa to rupees

UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto;

-- Business Problems
-- 1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent FROM zepto 
ORDER BY discountPercent DESC 
LIMIT 10;

-- 2. products with high mrp but out of stock
SELECT DISTINCT name, mrp, outofstock FROM zepto
WHERE outofstock='TRUE' AND mrp>350
ORDER BY mrp DESC;

-- 3. Estimated revenue for each category
SELECT category, SUM(discountedsellingprice*availablequantity) AS total_revenue FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- 4. Find all products where mrp is greater than 500 and discount is less then 10%
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC, discountPercent DESC;

-- 5. Identify the top 5 categories offering the highest average discount percentage
SELECT category, ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto 
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- 6. Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedsellingprice, ROUND(discountedsellingprice/weightInGms, 2) AS price_per_GMs
FROM zepto
WHERE weightInGms>=100
ORDER BY price_per_GMs;

-- 7. Group the products into categories like Low, Medium, Bulk.
SELECT name, weightInGms,
CASE WHEN weightInGms<1000 THEN 'Low'
WHEN weightInGms<5500 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM zepto

-- 8. What is the total Inventory weight per category
SELECT category, SUM(weightInGms*availableQuantity) AS totalWeight
FROM zepto
GROUP BY category
ORDER BY totalWeight;
