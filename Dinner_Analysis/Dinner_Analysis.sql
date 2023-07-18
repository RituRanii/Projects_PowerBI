CREATE DATABASE dannys_diner;

USE dannys_diner;

CREATE TABLE sales(
	customer_id VARCHAR(1),
	order_date DATE,
	product_id INTEGER
);

INSERT INTO sales
	(customer_id, order_date, product_id)
VALUES
	('A', '2021-01-01', 1),
	('A', '2021-01-01', 2),
	('A', '2021-01-07', 2),
	('A', '2021-01-10', 3),
	('A', '2021-01-11', 3),
	('A', '2021-01-11', 3),
	('B', '2021-01-01', 2),
	('B', '2021-01-02', 2),
	('B', '2021-01-04', 1),
	('B', '2021-01-11', 1),
	('B', '2021-01-16', 3),
	('B', '2021-02-01', 3),
	('C', '2021-01-01', 3),
	('C', '2021-01-01', 3),
	('C', '2021-01-07', 3);

CREATE TABLE menu(
	product_id INTEGER,
	product_name VARCHAR(5),
	price INTEGER
);

INSERT INTO menu
	(product_id, product_name, price)
VALUES
	(1, 'sushi', 10),
    (2, 'curry', 15),
    (3, 'ramen', 12);

CREATE TABLE members(
	customer_id VARCHAR(1),
	join_date DATE
);

-- Still works without specifying the column names explicitly
INSERT INTO members
	(customer_id, join_date)
VALUES
	('A', '2021-01-07'),
    ('B', '2021-01-09');

	select * from menu;
--1. What is the total amount each customer spent at the restaurant?
select s.customer_id,sum(m.price) as total_spent
from sales s
join menu m
on s.product_id = m.product_id
group by s.customer_id


-- 2. How many days has each customer visited the restaurant?
select s.customer_id, COUNT(distinct s.order_date) as days_visited
from sales s
group by s.customer_id


-- 3. What was the first item from the menu purchased by each customer?
with customer_first_purchase AS(
select s.customer_id,MIN(s.order_date) as first_purchase_date
from sales s
group by s.customer_id
)
select cfp.customer_id, cfp.first_purchase_date, m.product_name
from customer_first_purchase as cfp
JOIN sales s on s.customer_id = cfp.customer_id
and cfp.first_purchase_date = s.order_date
join menu m on m.product_id = s.product_id


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select top 3 m.product_name, COUNT(*) as total_purchased
from sales s
join menu m on s.product_id = m.product_id
group by m.product_name
order by total_purchased DESC


-- 5. Which item was the most popular for each customer?
WITH customer_popularity AS (
    SELECT s.customer_id, m.product_name, COUNT(*) AS purchase_count,
        DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rank
    FROM sales s
    INNER JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
)
SELECT customer_id, product_name, purchase_count
FROM customer_popularity
WHERE rank = 1;


-- 6. Which item was purchased first by the customer after they became a member?
WITH first_purchase_after_membership AS (
    SELECT s.customer_id, MIN(s.order_date) as first_purchase_date
    FROM sales s
    JOIN members mb ON s.customer_id = mb.customer_id
    WHERE s.order_date >= mb.join_date
    GROUP BY s.customer_id
)
SELECT fpam.customer_id, m.product_name
FROM first_purchase_after_membership fpam
JOIN sales s ON fpam.customer_id = s.customer_id 
AND fpam.first_purchase_date = s.order_date
JOIN menu m ON s.product_id = m.product_id;


-- 7. Which item was purchased just before the customer became a member?
WITH last_purchase_before_membership AS (
    SELECT s.customer_id, MIN(s.order_date) as last_purchase_date
    FROM sales s
    JOIN members mb ON s.customer_id = mb.customer_id
    WHERE s.order_date < mb.join_date
    GROUP BY s.customer_id
)
SELECT lpbm.customer_id, m.product_name
FROM last_purchase_before_membership lpbm
JOIN sales s ON lpbm.customer_id = s.customer_id 
AND lpbm.last_purchase_date = s.order_date
JOIN menu m ON s.product_id = m.product_id;


-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(*) as total_items, SUM(m.price) AS total_spent
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
JOIN dbo.members mb ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;