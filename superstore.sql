# What are the top 5 selling products? 
select
	round(sum(sales),1) as Total_Sales, `product name`
from superstore.`sample - superstore`
group by `product name`
order by Total_Sales desc
limit 5;


#Which category generates the most revenue? 
select
	category, round(sum(sales), 1) as Total_Sales
from superstore.`sample - superstore`
group by category
order by Total_Sales desc
limit 1;


#How do monthly sales trend over time? 
select 
	date_format(str_to_date(`order date`, '%m/%d/%y'),'%y-%m') as order_month,
	round(sum(sales),1) as Total_Sales
from superstore.`sample - superstore`
group by order_month
order by order_month asc;


#Who are the top 10 customers by lifetime value? 
select  
	`customer name`,
	round(sum(sales),1) as Total_Sale
from superstore.`sample - superstore`
group by `customer name`
order by Total_sale desc
limit 10;


#Which product sub-categories have the lowest profit margins?
select  
	`Sub-Category`,
	round(sum(profit)/sum(sales) *100,1) as Profit_Margine_Percentage
from superstore.`sample - superstore`
group by `Sub-Category`
order by Profit_Margine_Percentage asc;


#What is the average delivery time per shipping mode?
select 
	`ship mode`,
	round(avg(datediff(
		str_to_date(`order date`,'%m/%d/%y'),
		str_to_date(`ship date`,'%m/%d/%y')
		)),1) as `average ship time`
from superstore.`sample - superstore`
where `order date` is not null and `ship date` is not null
group by `ship mode`;

#Are there seasonal patterns in sales?   
select 
	month(str_to_date(`order date`, '%m/%d/%y'))as month,
	monthname(str_to_date(`order date`, '%m/%d/%y'))as month_name,
	round(sum(`sales`),1) as total_sales
from superstore.`sample - superstore`
group by month,month_name
order by month asc;


# Which quarter of the year brings in the highest average profit?
select
	quarter(str_to_date(`order date`,'%m/%d/%y')) as quarters,
	round(avg(profit),1) as avg_profit
from superstore.`sample - superstore`
group by quarters
order by quarters;


#Top 3 regions where the average profit per order is highest.
with profit_per_region as(
select 
	region,
	round(
	sum(profit)/ sum(sales)*100,1) as Profit_Per_Sale
from superstore.`sample - superstore`
group by region
)
select region,profit_per_sale
from profit_per_region
order by profit_per_sale desc
limit 3;


#Identify the top 5 customers who had the highest average order value — but only for orders shipped with 'First Class'.

with first_class as(
select
	`order id`,`customer id` , `customer name`,
	sum(sales) as order_value
from  superstore.`sample - superstore`
where `Ship Mode`= 'first class'
GROUP BY `Order ID`, `Customer ID`, `Customer Name`
)
select 
	`customer id` , `customer name`,
	round(avg(order_value),1) as avg_order_value
from first_class
group by `customer id` , `customer name`
order by avg_order_value desc
limit 5;