create database if not exists walmartsales; 
use walmartsales;


create table if not exists sales(invoice_id varchar(30) not null primary key,
								 branch varchar(5) not null, city varchar(30) not null,
                                 customer_type varchar(30) not null, gender varchar(8) not null,
                                 product_line varchar(100) not null, unit_price decimal(10,2) not null,
                                 quantity int not null, VAT float not null, total decimal(12,4) not null,
                                 date datetime not null, time time not null,
                                 payment varchar(15) not null, cogs decimal(10,2) not null,
                                 gross_margin_percent float, gross_income decimal(12,4) not null,
                                 rating float);
-- Create a Table and then import data to already created table                                  
								
-------------------------------------------------------------------------------------------------------------------
----------- FEATURE ENGINEERING -----------------

select time from sales;
select date from sales;


-- Classifying time of day in morning,noon and evening --
alter table sales add column day_time varchar(15);

update sales set day_time= (case 
							when time between "00:00:00" and "12:00:00" then "Morning"
                            when time between "12:00:10" and "16:00:00" then "Afternoon"
                            else "Evening" end);
select day_time from sales;

-- Classifying weekdays -- 
alter table sales add column week_day varchar(10);

update sales set week_day=dayname(date);
select week_day from sales;


-- classify month name of period --
alter table sales add column month_name varchar(10);


update sales set month_name=monthname(date);
select month_name from sales;

alter table sales rename column total to total_cost;
alter table sales rename column payment to payment_mode;
alter table sales rename column day_time to time_of_day;

-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
                                   --------------------- Bussiness Probelms -----------------------

-- How many unique cities does the data have?
select distinct city from sales;

-- In which city is each branch?
select distinct  city , branch from sales;


                                      -- Product Queries --
                                      
-- How many unique product lines does the data have?
select distinct product_line from sales;
select count(distinct product_line) from sales;

-- What is the most common payment method?
select  payment_mode , count(payment_mode) as Payment_count from sales
group by payment_mode
order by Payment_count desc;
-- We can observe a good balance in value of number of times of ecach payment mode used  



-- What is the most selling product line?
select product_line as Product , count(product_line) as Quantity_sold
from sales
group by product_line
order by Quantity_sold desc;


-- What is the total revenue by month?
select month_name as Month, sum(total_cost) as Total_Revenue
from sales 
group by Month 
order by Total_Revenue desc;


-- What month had the largest COGS?
select month_name as Month , sum(cogs) as Cost_of_Goods_Sold 
from sales
group by Month
order by Cost_of_Goods_Sold  desc;


-- What product line had the largest revenue?
select product_line as Product , sum(total_cost) as Total_revenue
from sales
group by product_line
order by Total_revenue desc;


-- What is the city with the largest revenue?
select Branch,City as Product , sum(total_cost) as Total_revenue
from sales
group by City,branch
order by branch;


-- What product line had the largest VAT?
select min(vat) as Minimum_VAT,max(vat) as Maximum_VAT , avg(vat) as Average_VAT from sales;
select product_line as Product, round(Avg(vat),3) as Avg_TAX 
from sales
group by product
order by Avg_TAX desc;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average product sold
select product_line as Product, avg(quantity) as Avg_QTY_Sold,(case when avg(quantity)>(select avg(quantity) from sales) then "Good" else "Bad" end) 
as Sales_Status 
from sales
group by Product;
SELECT  AVG(quantity) AS avg_qnty FROM sales;



select product_line as Product, sum(cogs) as Total_sales,(case when sum(cogs)>(select avg(cogs) from sales) then "Good"
															  when sum(cogs)=(select avg(cogs) from sales) then "Moderate" else "Bad" end) 
as Sales_Status 
from sales
group by Product;



-- Which branch sold more products than average product sold?
select branch as Branch ,sum(quantity) as QTY from sales 
group by Branch
having QTY > (select avg(quantity) from sales);


-- What is the most common product line by gender?
select Gender,product_line as Product , count(*) as Total_count
from sales
group by product_line,gender
order by Total_count desc;


-- What is the average rating of each product line?
select product_line as Product , round(avg(rating),3) as Avg_Rating
from sales
group by product_line
order by Avg_Rating desc;


                         -- Sales Queries --
                         
-- Number of sales made in each time of the day per weekday
select week_day,time_of_day ,count(*) as Number_of_Payment from sales
where week_day = "Monday"
group by time_of_day,week_day
order by Number_of_Payment desc;
-- Change day name in where condition to observe distribution of other week days

-- Which of the customer types brings the most revenue?
select customer_Type as `Customer Type`, sum(total_cost) as Total_revenue 
from sales
group by `Customer Type`
order by Total_revenue;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city , round(avg(VAT),3) as Avg_VAT from sales
group by city;


-- Which customer type pays the most in VAT?
select customer_Type as `Customer Type`, round(avg(VAT),3) as Avg_VAT from sales
group by `Customer Type`;
 
 
 
 
                        -- Customer queries --
                        
-- How many unique customer types does the data have?
select distinct customer_type from sales;


-- How many unique payment methods does the data have?
select distinct payment_mode from sales;


-- What is the most common customer type?
select customer_type , count(*) as Customer_type_count from sales 
group by customer_type
order by Customer_type_count desc
limit 1;


-- What is the gender of most of the customers?
select gender , count(*) as Count from sales 
group by gender
order by Count desc;

-- What is the gender distribution per branch?
select distinct branch from sales;
select branch,gender,count(gender) as  Count from sales 
where branch="A"
group by gender,branch
order by Count desc;
-- Change branch in 'where' condition for different insights
-- It is observed that distribution of male and female in each branch is nearly similar. Thus, gender in given dataset may not have significant impact on sales
 



-- Which time of the day do customers give most ratings?
select time_of_day, round(avg(rating),3) as AVG_Rating from sales
where week_day="Monday"
group by time_of_day;


-- Which time of the day do customers give most ratings per branch?
select branch as Branch,time_of_day,round(avg(rating),3) as AVG_Rating 
from sales
group by branch,time_of_day
order by Branch;

-- Which day fo the week has the best avg ratings?
select week_day as Day_Name, round(avg(rating),3) as AVG_Rating from sales
group by week_day
order by AVG_Rating desc;



-- Which day of the week has the best average ratings per branch?
select week_day as Day_Name, round(avg(rating),3) as AVG_Rating from sales
where branch ="C"
group by week_day
order by AVG_Rating desc;







