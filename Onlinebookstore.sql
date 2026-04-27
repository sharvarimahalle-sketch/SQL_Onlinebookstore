-- ============================================================
--  PROJECT  : Online Bookstore Analytics
--  DATABASE : books, customers, orders
--  PURPOSE  : End-to-end SQL analysis of an e-commerce bookstore
--             covering inventory, customer details, revenue.
-- ============================================================

-- ============================================================
-- SECTION 1 – DATABASE SETUP
-- ============================================================
create database OnlineBookstore; 
use OnlineBookstore ; 

-- ============================================================
-- SECTION 2 – EXPLORATORY / BASIC QUERIES
-- ============================================================

-- ----------------------------------------------------------------------------------------------------------
-- Q1  Genre Filter
-- Business value: Quickly audit catalogue depth for a specific genre; useful for purchasing decisions.
-- -----------------------------------------------------------------------------------------------------------
select * from books where genre="Fiction" order by title; 

-- -----------------------------------------------------------------------------------------------------------
-- Q2  Recently Published Books
-- Business value: Identify modern titles that may attract contemporary readers and drive traffic.
-- ------------------------------------------------------------------------------------------------------------
select * from books where Published_Year > 2015 order by Published_Year desc; 

-- ------------------------------------------------------------------------------------------------------------
-- Q3  Customers by Country
-- Business value: Supports targeted regional marketing campaigns and shipping-cost analysis.
-- ------------------------------------------------------------------------------------------------------------
select * from customers where country = 'Canada' order by city ; 

-- -------------------------------------------------------------------------------------------------------------
-- Q4  Orders in a Specific Month
-- Business value: Month-level sales monitoring; compare performance vs prior periods.
-- -------------------------------------------------------------------------------------------------------------
select * from orders where order_date between '2023-11-01' and '2023-11-30'; 
#OR
select * from orders where order_date like '2023-11-%'; 

-- -----------------------------------------------------------------------------------------------------------
-- Q5  Total Stock on Hand
-- Business value: Single-number KPI for inventory health; triggers reorder alerts when stock is low.
-- -----------------------------------------------------------------------------------------------------------
select
    sum(stock)               as total_stock,
    count(book_id)           as total_titles,
    avg(stock)               as avg_stock_per_title,
    min(stock)               as lowest_stock,
    max(stock)               as highest_stock
from Books;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Q6  Most Expensive Book
-- Business value: Premium price titles may need different promotions or bundle strategies.
-- ----------------------------------------------------------------------------------------------------------------------------------------
select * from books order by price desc limit 1 ;  

-- --------------------------------------------------------------------------------------------------------------------
-- Q7  High-Quantity Orders (> 1 copy per transaction)
-- Business value: Bulk buyers are strong candidates for loyalty rewards or wholesale pricing.
-- --------------------------------------------------------------------------------------------------------------------
#using join
select cust.customer_id, cust.`name` , ord.quantity 
from customers as cust 
join orders as ord
on cust.customer_id = ord.customer_id 
where quantity > 1; 

#without join
select * from Orders where quantity>1;

-- --------------------------------------------------------------------------------------------------------------------
-- Q8  Orders Above $200
-- Business value: Segment high value transactions for revenue analysis and fraud screening.
-- --------------------------------------------------------------------------------------------------------------------
select c.name , b.title , o.total_amount
from Orders as o
join Customers as c on o.customer_id = c.customer_id
join Books as b on o.book_id = b.book_id
where o.total_amount > 200
order by o.total_amount desc;

-- -------------------------------------------------------------------------------------------------------
-- Q9  Distinct Genres in Catalogue
-- Business value: Quick catalogue audit; reveals genre diversity and potential gaps.
-- -------------------------------------------------------------------------------------------------------
select genre, count(*) as title_count, round(avg(price), 2) as avg_price, sum(stock) as total_stock
from Books
group by genre
order by title_count desc;

-- --------------------------------------------------------------------------------------------------------------
-- Q10  Books with Lowest Stock (Top 5 reorder candidates)
-- Business value: Prioritise restocking before stockouts cause lost sales.
-- --------------------------------------------------------------------------------------------------------------
select * from books order by stock limit 5;  

-- ============================================================
-- SECTION 3 – INTERMEDIATE ANALYTICS
-- ============================================================
 
-- ------------------------------------------------------------
-- Q11  Total Revenue
-- Business value: Primary financial KPI for the platform.
-- ------------------------------------------------------------
select 
	sum(total_amount)               as total_revenue,
    count(order_id)                 as total_orders,
    round(avg(total_amount), 2)     as avg_order_value,
    max(total_amount)               as largest_order,
    min(total_amount)               as smallest_order
from Orders;


-- --------------------------------------------------------------------------------------------------------------------------------------
-- Q12  Units Sold per Genre
-- Business value: Reveals which genres drive volume vs margin; informs catalogue investment decisions.
-- --------------------------------------------------------------------------------------------------------------------------------------
select b.genre, sum(o.quantity) as units_sold
from books as b
join orders as o
on b.book_id = o.book_id
group by b.genre
order by units_sold desc ; 

-- -------------------------------------------------------------------------------------------------------------
-- Q13  Average Price by Genre
-- Business value: Understand pricing positioning per genre to guide discount and pricing strategies.
-- -------------------------------------------------------------------------------------------------------------
select
    genre,
    round(avg(price), 2)  as avg_price,
    min(price)            as min_price,
    max(price)            as max_price,
    count(*)              as title_count
from books
group by genre
order by avg_price desc;

-- -------------------------------------------------------------------------------------------------------
-- Q14  Repeat Customers (≥ 2 orders)
-- Business value: Repeat buyers have higher lifetime value; target them for loyalty and upsell programmes.
-- -------------------------------------------------------------------------------------------------------
# COUNT(o.Order_id) - Inside each person's bucket, the database counts how many order IDs it finds.
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;
-- ---------------------------------------------------------------------------------------------------------
-- Q15  Most Frequently Ordered Book
-- Business value: Bestseller data informs restocking priority and homepage / featured section placement.
-- ---------------------------------------------------------------------------------------------------------
select b.book_id, b.title, count(o.order_id) AS order_count
from books as b 
join orders as o 
on b.book_id = o.book_id
group by b.book_id, b.title
order by order_count desc
limit 1; 

-- ------------------------------------------------------------------------------------------------------
-- Q16  Top 3 Most Expensive Fantasy Books
-- Business value: Premium Fantasy titles may appeal to a niche collector segment worth targeting.
-- -----------------------------------------------------------------------------------------------------
select * from books where genre = 'Fantasy'
order by price desc 
limit 3; 

-- ------------------------------------------------------------------------------------------------------
-- Q17  Total Units Sold per Author
-- Business value: Author level performance data supports exclusive deal negotiations and promotions.
-- ------------------------------------------------------------------------------------------------------
select b.author , sum(o.quantity) as total_units_sold, count(distinct b.book_id) as titles_available,
    round(sum(o.total_amount), 2) as author_revenue
from orders as o  
join books as b
on o.book_id = b.book_id 
group by b.author
order by total_units_sold desc;

-- ----------------------------------------------------------------------------------------------------------
-- Q18  Cities with High Value Customers (orders > $30)
-- Business value: Geographic hotspots for premium customers guide localised marketing spend.
-- ----------------------------------------------------------------------------------------------------------
select distinct c.city, c.country,
    count(distinct c.customer_id) as premium_customer_count,
    round(sum(o.total_amount), 2) as total_spend 
FROM customers as c
JOIN orders as o
ON c.customer_id=o.customer_id
WHERE o.total_amount > 30
group by c.city, c.country
order by total_spend desc;

-- -------------------------------------------------------------------------------------------------------------
-- Q19  Top Spending Customer
-- Business value: VIP identification; first candidate for personalised outreach and premium perks.
-- -------------------------------------------------------------------------------------------------------------
select c.customer_id, c.`name`, count(o.order_id) as total_orders, sum(total_amount) as total_spent
from customers as c 
join orders as o 
on c.customer_id = o.customer_id
group by c.customer_id, c.`name`
order by total_spent desc
limit 1; 

-- ---------------------------------------------------------------------------------------------------------------
-- Q20  Remaining Stock After Fulfilling All Orders
-- Business value: Real-time inventory position post-sales; critical for warehouse and supply planning.
-- ------------------------------------------------------------
select b.book_ID, b.title, b.Stock AS initial_stock,
coalesce(sum(o.Quantity), 0) AS total_ordered,
b.Stock - coalesce(sum(o.Quantity), 0) AS remaining_stock    
#COALESCE(..., 0) -If a book has no orders, SUM returns NULL. COALESCE replaces that NULL with 0, ensuring accurate calculation.
from Books as b
left join Orders as o 
on b.Book_ID = o.Book_ID
group by b.Book_ID, b.title, b.Stock;
/*
Why LEFT JOIN? 
to ensure that books with zero orders still appear in the final report. 
If an INNER JOIN were used, books with no orders would be excluded entirely
*\
