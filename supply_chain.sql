-->Created A Exact Table like our csv file for anylysis
CREATE TABLE supply_chain (
    sku VARCHAR(50) PRIMARY KEY,
    product_type VARCHAR(50),
    price DECIMAL(10,2),
    availability INT,
    number_of_products_sold INT,
    revenue_generated DECIMAL(10,2),
    customer_demographics VARCHAR(50),
    stock_levels INT,
    lead_times INT,
    order_quantities INT,
    shipping_times INT,
    shipping_carriers VARCHAR(50),
    shipping_costs DECIMAL(10,2),
    supplier_name VARCHAR(50),
    location VARCHAR(50),
	lead_time INT,
    production_volumes INT,
    manufacturing_lead_time INT,
    manufacturing_costs DECIMAL(10,2),
    inspection_results VARCHAR(50),
    defect_rates DECIMAL(5,2),
    transportation_modes VARCHAR(50),
    routes VARCHAR(50),
    costs DECIMAL(10,2)
);

-->Importing the data 
COPY supply_chain(
    product_type, sku, price, availability, number_of_products_sold,
    revenue_generated, customer_demographics, stock_levels,
    lead_times, order_quantities, shipping_times,
    shipping_carriers, shipping_costs, supplier_name,
    location, lead_time, production_volumes,
    manufacturing_lead_time, manufacturing_costs,
    inspection_results, defect_rates,
    transportation_modes, routes, costs
)
FROM 'D:\python data anlysis project\supply chain anylysis\supply_chain_data.csv'
DELIMITER ','
CSV HEADER;


-->Full Data
select * from supply_chain;


/*Sales & Revenue
Top 5 products by revenue
Product type contributing highest revenue
Average revenue per product type*/

--1.Top 5 products by revenue
select sku , sum(revenue_generated) as total_revenue_generated 
from supply_chain
group by sku 
order by sum(revenue_generated) desc
limit 5; 


--2.Average revenue per product type
select product_type , avg(revenue_generated) as average_revenue_generated 
from supply_chain
group by product_type 
order by avg(revenue_generated) desc; 

--3.Product type contributing highest revenue
select product_type , sum(revenue_generated) as highest_revenue_generated 
from supply_chain
group by product_type 
order by sum(revenue_generated) desc; 


/*Inventory Analysis
Products with low stock but high sales
Total stock per product type
Products with highest order quantity*/


--1.Products with low stock but high sales
SELECT sku, product_type, stock_levels, number_of_products_sold
FROM supply_chain
WHERE stock_levels < 50
AND number_of_products_sold > 500;

--2.Total stock per product type
select product_type , sum(stock_levels) as total_stock
from supply_chain
group by product_type
order by total_stock desc;

--3.Products with highest order quantity
select * from supply_chain 
order by order_quantities desc
limit 5;

select * from supply_chain;

/*Logistics Analysis
Average shipping cost by transport mode
Fastest shipping mode
Most expensive shipping routes*/

--1.Average shipping cost by transport mode
select transportation_modes , avg(shipping_costs) as avg_shipping_costs
from supply_chain
group by transportation_modes;

--2.Fastest shipping mode
select transportation_modes , avg(shipping_times) as avg_shipping_time
from supply_chain
group by transportation_modes
order by avg_shipping_time asc;

--3.Most expensive shipping routes
select routes , sum(shipping_costs) as total_shipping_cost
from supply_chain
group by routes
order by total_shipping_cost desc;


/*Supplier Analysis
Supplier with highest defect rate
Supplier with lowest lead time
Best supplier (low defect + low lead time)*/


--1.Supplier with highest defect rate
select supplier_name , avg(defect_rates) as avg_defect_rate
from supply_chain
group by supplier_name
order by avg_defect_rate desc
limit 1;

--2.Supplier with lowest lead time
select supplier_name , avg(lead_time) as supplier_lowest_lead_time
from supply_chain
group by supplier_name 
order by avg(lead_time) asc
limit 1;

--3.Best supplier (low defect + low lead time)
select 
    supplier_name,
    avg(defect_rates) as avg_defect_rate,
    avg(lead_time) as avg_lead_time
from supply_chain
group by supplier_name
order by avg_defect_rate asc, avg_lead_time asc
limit 5;


/*Cost & Profit
Calculate profit (Revenue - Cost)
Products with highest profit
High revenue but low profit products
*/

--1.Calculate profit (Revenue - Cost)
select sku,revenue_generated - (manufacturing_costs + shipping_costs + costs) as profit
from supply_chain;

--2.Products with highest profit
select sku,revenue_generated - (manufacturing_costs + shipping_costs + costs) as profit
from supply_chain
order by profit desc
limit 5;

--3.High revenue but low profit products
select product_type , avg(revenue_generated) as avg_revenue,
avg(revenue_generated - (manufacturing_costs + shipping_costs + costs)) as avg_profit
from supply_chain
group by product_type
order by avg(revenue_generated) desc , avg_profit asc;







