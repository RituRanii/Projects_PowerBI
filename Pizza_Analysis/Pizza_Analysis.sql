select * from pizza_sales

--Problem Statement KPI's
--1. Total Revenue
select SUM(total_price) AS Total_Revenue from pizza_sales

--2. Average Order Value
select SUM(total_price)/COUNT(distinct order_id) AS Avg_Order_Value from pizza_sales

--3. Total Pizza Sold
select SUM(quantity) AS Total_pizza_sold from pizza_sales

--4. Total Order Placed
select COUNT(distinct order_id) AS Total_orders from pizza_sales

--5. Average Pizza Per Order
select cast(cast(SUM(quantity) AS decimal(10,2))/cast(COUNT(DISTINCT order_id) AS decimal(10,2)) AS decimal(10,2)) AS AVg_pizza_per_order from pizza_sales

--CHARTS REQUIREMENTS
--1. Daily Trend for Total Orders:
select DATENAME(DW, order_date) as order_day, COUNT(DISTINCT order_id) AS Total_orders from pizza_sales group by DATENAME(DW, order_date)

--2. Monthly Trend for Total Orders:
select DATENAME(MONTH, order_date) as order_month, COUNT(DISTINCT order_id) AS Total_orders from pizza_sales group by DATENAME(MONTH, order_date) order by Total_orders desc

--3. Percentage of sales by Pizza Category:
select pizza_category,sum(total_price) as Total_Sales, SUM(total_price) * 100/(SELECT SUM(total_price) from pizza_sales where MONTH(order_date) = 1) as Percentage_total_sales
from pizza_sales 
where MONTH(order_date) = 1 
group by pizza_category

--4. Percentage of sales by pizza size:

select pizza_size,sum(total_price) as Total_Sales, SUM(total_price) * 100/(SELECT SUM(total_price) from pizza_sales where DATEPART(QUARTER, order_date)=1) as Percentage_total_sales
from pizza_sales 
where DATEPART(QUARTER, order_date)=1
group by pizza_size
order by Percentage_total_sales desc

--5. Top 5 Best sellers by Revenue, Total_Quantity and Total Orders
--a)
select TOP 5 pizza_name, SUM(total_price) as revenue from pizza_sales
group by pizza_name
order by revenue desc
--b)
select TOP 5 pizza_name, SUM(quantity) as Quantity from pizza_sales
group by pizza_name
order by Quantity desc
--c)
select TOP 5 pizza_name, COUNT(DISTINCT order_id) as Total_order from pizza_sales
group by pizza_name
order by Total_order desc

--6. Bottom 5 Best sellers by Revenue, Total_Quantity and Total Orders
--a)
select TOP 5 pizza_name, SUM(total_price) as revenue from pizza_sales
group by pizza_name
order by revenue 
--b)
select TOP 5 pizza_name, SUM(quantity) as Quantity from pizza_sales
group by pizza_name
order by Quantity 
--c)
select TOP 5 pizza_name, COUNT(DISTINCT order_id) as Total_order from pizza_sales
group by pizza_name
order by Total_order 