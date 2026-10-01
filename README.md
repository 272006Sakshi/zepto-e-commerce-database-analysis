# Zepto Inventory & Pricing Analysis (SQL)

An end-to-end SQL project that explores a Zepto (quick-commerce) product catalogue: setting up the schema, exploring and cleaning the data, and answering practical business questions about pricing, discounts, stock availability, revenue and inventory weight.

## Objectives

- Build a clean, queryable table from raw product data
- Run exploratory data analysis (EDA): row counts, nulls, categories, stock status, duplicate product names
- Clean the data: remove invalid pricing rows and convert prices from paise to rupees
- Answer business questions that help with pricing, stock planning and category strategy

## Tech Stack

- **Database:** PostgreSQL
- **Language:** SQL
- **Data source:** Zepto product catalogue CSV *([click here](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv))*

## Dataset Schema

| Column | Type | Description |
|---|---|---|
| `sku_id` | SERIAL (PK) | Unique ID for each SKU |
| `category` | VARCHAR(120) | Product category |
| `name` | VARCHAR(150) | Product name (NOT NULL) |
| `mrp` | NUMERIC(8,2) | Maximum retail price |
| `discountPercent` | NUMERIC(5,2) | Discount applied on MRP |
| `availableQuantity` | INTEGER | Units available in inventory |
| `discountedSellingPrice` | NUMERIC(8,2) | Price after discount |
| `weightInGms` | INTEGER | Product weight in grams |
| `outOfStock` | BOOLEAN | Stock status flag |
| `quantity` | INTEGER | Units per pack/listing |

## Workflow

### 1. Setup
Drops and recreates the `zepto` table, then the CSV is imported into it.

### 2. Data Exploration
- Preview the first 15 rows
- Count total rows
- Check for NULLs across all columns
- List distinct product categories
- Compare in-stock vs out-of-stock SKUs
- Find product names that appear more than once (multiple SKUs/variants)

### 3. Data Cleaning
- Identified products with `mrp = 0` or `discountedSellingPrice = 0`
- Deleted rows with `mrp = 0` (invalid pricing)
- Converted `mrp` and `discountedSellingPrice` from **paise to rupees** (divided by 100)

> **Note:** The paise-to-rupees `UPDATE` should be run **only once**. Running it again will divide the prices by 100 a second time.

### 4. Business Questions

| # | Question | Techniques used |
|---|---|---|
| 1 | Top 10 best-value products by discount percentage | `DISTINCT`, `ORDER BY`, `LIMIT` |
| 2 | High-MRP products (> ₹350) that are out of stock | `WHERE`, filtering on boolean |
| 3 | Estimated revenue per category | `SUM`, `GROUP BY` |
| 4 | Products with MRP > ₹500 and discount < 10% | Multi-condition `WHERE` |
| 5 | Top 5 categories by average discount | `AVG`, `ROUND`, `GROUP BY` |
| 6 | Price per gram for products ≥ 100g, sorted by best value | Calculated column |
| 7 | Bucket products into Low / Medium / Bulk by weight | `CASE WHEN` |
| 8 | Total inventory weight per category | `SUM` of weight × quantity |

## Weight Buckets (Question 7)

| Bucket | Weight range |
|---|---|
| Low | < 1000 g |
| Medium | 1000 g to < 5500 g |
| Bulk | ≥ 5500 g |

## Key Insights
 -----

## How to Run

1. Create a PostgreSQL database and open it in `psql`, pgAdmin or DBeaver.
2. Run the `CREATE TABLE` statement from the SQL file.
3. Import the dataset into the `zepto` table.
4. Run the exploration, cleaning and business-question queries in order.

## Repository Structure

```
.
├── zepto_SQL_data_analysis.sql   
├── zepto_v2.csv                   
└── README.md
```

## Next
- Add indexes on `category` and `outOfStock` for faster filtering
- Use window functions to rank products within each category
- Visualise results in Power BI

