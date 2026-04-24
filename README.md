# SQL Advanced Data Analytics Project

This project performs advanced analysis on the Olist Brazilian e-commerce database. Cumulative analysis, Part-to-Whole analysis and Data Segmentation is used gather key insights into customer behaviour and sales revenue

---

## Tools Used

- SQL (Microsoft SQL Server)
- Excel / CSV datasets
- Data analysis techniques (Cumulative, Part-to-Whole, Data Segmentation)

---

## Dataset Description

- **Customers Table** → Customer demographics and details  
- **Products Table** → Product catalog and attributes  
- **Order Items Table** → Transaction-level sales data
- **Orders Table** → Higher-level order details such as order status and order delivery timestamps
- **Order Payments Table** → Meta-data regarding payments made
- **Sellers Table** → Seller details

---

## Files Included

- `Olist_SQL_analysis.sql` → SQL queries used for analysis  
- `olist_customers_dataset.csv` → Customer dimension table  
- `olist_order_items_dataset.csv` → Sales Fact table 
- `olist_order_payments_dataset.csv` → Sales Payment information table
- `olist_orders_dataset.csv` → Order information table
- `olist_products_dataset.csv` → Product dimension table
- `olist_sellers_dataset.csv` → Seller dimension table

---

## Key Questions Answered

- Which categories contribute the most to overall sales?
- How much has each of customers spent with us in total?
  - Are they a VIP, Regular or new customer?
- What is the average order value (AOV)?
- What is the Total Revenue over time monthly (Running total)?
- What is the Month over Month percentage total revenue change?
- Which cities have the most valuable customers?
- What is the average delivery time by city and state?
- What Percentage of orders that were on time vs late according to delivery estimate?
- What is the Average shipping time of orders by year?
