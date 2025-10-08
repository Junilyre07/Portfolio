--dataset exploration
Use [SQL Project_Sales]

Select Count(*) AS "Number_of_Rows before cleaning"
FROM Return_report;
--2010 Rows

Select *
FROM Return_report

--Data Cleaning, removing duplicates and filling the null values
SELECT SUBSTRING(return_date, 1, 10)
FROM Return_report 

UPDATE Return_report
SET return_date = SUBSTRING(return_date, 1, 10)

--Finding the duplicates
WITH CLEAN_RETURNED_DATA AS (
   SELECT return_date, order_id, sku, asin, fnsku, product_name, quantity, fulfillment_center_id, detailed_disposition, reason, license_plate_number,
   ROW_NUMBER() OVER (Partition by return_date, order_id, sku, asin, fnsku, product_name, quantity, fulfillment_center_id, detailed_disposition, reason, license_plate_number ORDER BY ASIN) AS ROW_num
   FROM Return_report
)
SELECT return_date, order_id, sku, asin, fnsku, product_name, quantity, fulfillment_center_id, detailed_disposition, reason, license_plate_number, Row_num
FROM CLEAN_RETURNED_DATA
Where ROW_num > 1


Removing the duplicates
WITH CLEAN_RETURNED_DATA AS (
   SELECT 
       return_date, 
       order_id, 
       sku, 
       asin, 
       fnsku, 
       product_name, 
       quantity, 
       fulfillment_center_id, 
       detailed_disposition, 
       reason, 
       license_plate_number,  
       ROW_NUMBER() OVER (
           PARTITION BY 
               return_date, 
               order_id, 
               sku, 
               asin, 
               fnsku, 
               product_name, 
               quantity, 
               fulfillment_center_id, 
               detailed_disposition, 
               reason, 
               license_plate_number
           ORDER BY asin
       ) AS ROW_num
   FROM Return_report
)
DELETE FROM Return_report
WHERE EXISTS (
   SELECT 1
   FROM CLEAN_RETURNED_DATA
   WHERE CLEAN_RETURNED_DATA.ROW_num > 1
   AND CLEAN_RETURNED_DATA.return_date = Return_report.return_date
   AND CLEAN_RETURNED_DATA.order_id = Return_report.order_id
   AND CLEAN_RETURNED_DATA.sku = Return_report.sku
   AND CLEAN_RETURNED_DATA.asin = Return_report.asin
   AND CLEAN_RETURNED_DATA.fnsku = Return_report.fnsku
   AND CLEAN_RETURNED_DATA.product_name = Return_report.product_name
   AND CLEAN_RETURNED_DATA.quantity = Return_report.quantity
   AND CLEAN_RETURNED_DATA.fulfillment_center_id = Return_report.fulfillment_center_id
   AND CLEAN_RETURNED_DATA.detailed_disposition = Return_report.detailed_disposition
   AND CLEAN_RETURNED_DATA.reason = Return_report.reason
   AND CLEAN_RETURNED_DATA.license_plate_number = Return_report.license_plate_number
);

WITH CLEAN_RETURNED_DATA AS (
   SELECT return_date, order_id, sku, asin, fnsku, product_name, quantity, fulfillment_center_id, detailed_disposition, reason, license_plate_number,
   ROW_NUMBER() OVER (Partition by return_date, order_id, sku, asin, fnsku, product_name, quantity, fulfillment_center_id, detailed_disposition, reason, license_plate_number ORDER BY ASIN) AS ROW_num
   FROM Return_report
)
SELECT return_date, order_id, sku, asin, fnsku, product_name, quantity, fulfillment_center_id, detailed_disposition, reason, license_plate_number, Row_num
FROM CLEAN_RETURNED_DATA
Where ROW_num > 1

--Checking Null Values


Select 
   CASE
      WHEN Count (*) > 0  THEN 'Nulls Exist'
	  ELSE 'No nulls'
	  END as Null_Status
FROM Return_report
WHERE return_date IS NULL
     OR sku IS NULL
   OR asin IS NULL
   OR fnsku IS NULL
   OR product_name IS NULL
   OR quantity IS NULL
   OR fulfillment_center_id IS NULL
   OR detailed_disposition IS NULL
   OR reason IS NULL
   OR license_plate_number IS NULL;


--Dropping a column which is not necessary
ALTER TABLE RETURN_REPORT
DROP COLUMN customer_comments;

Select * 
FROM Return_report
WHERE return_date IS NULL
     OR sku IS NULL
   OR asin IS NULL
   OR fnsku IS NULL
   OR product_name IS NULL
   OR quantity IS NULL
   OR fulfillment_center_id IS NULL
   OR detailed_disposition IS NULL
   OR reason IS NULL
   OR license_plate_number IS NULL;

   Select ASIN, product_name
   FROM Return_report
   WHERE product_name = 'Andlane Hair Bun Maker French Twist Hair Fold Wrap Snap - Ballet Bun for Women and Kids (1 Brown, 1 Light Brown)';
   Andlane Hair Bun Maker French Twist Hair Fold Wrap Snap - Ballet Bun for Women and Kids (1 Brown, 1 Light Brown)

--Filling null values
UPDATE Return_report
Set ASIN = ISNULL(ASIN, 'B071X2SQ3Q')

--Now the data is clean.

--Which fulfillment center has the highest number of returned products?
--What is the most returned product?
--In which fulfillment centers are the most returned products usually restocked?
--Which dates have the highest number of returns?
--Which SKUs have multiple returns from the same order ID?
--For each product, what is the average quantity returned per order?
--Which reason codes (e.g., MISSING_PARTS, DEFECTIVE) are most common per fulfillment center?
--For each detailed_disposition, what % of returns are “Unit returned to inventory” vs disposed/scrapped?
--Identify the top 5 products most often marked as CUSTOMER_DAMAGED.
--How do returns vary by day of week?
--What is the trend of returns per month in 2023 by fulfillment center?
--On average, how many days after purchase (if you have order_date) do returns happen?
--Which fulfillment centers have the highest proportion of returns marked as customer damaged?



--Which fulfillment center has the highest number of returned products? TOP 5 are LAS, LEX2, MEM3, IND8, LEX1

Select fulfillment_center_id, Count (*) as FC_Highest 
FROM Return_report
GROUP BY fulfillment_center_id
ORDER by FC_Highest DESC

--With Ranking
SELECT FULFILLMENT_CENTER_ID,
       COUNT(*) AS FC_COUNT,
	   DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS RANK_
FROM RETURN_REPORT
GROUP BY FULFILLMENT_CENTER_ID
ORDER BY FC_COUNT DESC

 

SELECt fulfillment_center_id, COUNT(DISTINCT product_name) as Distinct_count
FROM Return_report
GROUP BY fulfillment_center_id
ORDER BY Distinct_count DESC

--This fulfillment center handles 46 unique products.


SELECt  COUNT(DISTINCT product_name) AS UNIQUE_ITEMS
FROM Return_report

--There are 84 unique items in total.

--What is the most returned product(ASIN) B08QCFJ7JC and B06XXKJRB2 are the top 2
--K-Brands Auger Drill Bit for Planting - 1.6 x 16 Inch & 3.5 x 16 Inch Set - Garden Spiral Hole Drill and Bulb Planter Tool - Bedding Plants, Umbrella Holes - 3/8 Inch Hex Drive Drill
--Andlane Hair Bun Maker French Twist Hair Fold Wrap Snap - Ballet Bun for Women and Kids (1 Black, 1 Brown
--Andlane Hair Bun Maker French Twist Hair Fold Wrap Snap - Ballet Bun for Women and Kids (1 Brown, 1 Light Brown)
--Women's Hair Bun Maker French Twist Hair Fold Wrap Snap by Andlane (1 Brown, 1 Dark Brown)
--Andlane Women's Hair Bun Maker Tool - French Twist Hair Fold Wrap Snap Hair Accessories (3 Blonde)

Select ASIN, COUNT(*) As Highest_ASIN,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_ASIN	 
FROM RETURN_REPORT
GROUP BY ASIN
ORDER BY Highest_ASIN DESC

Select product_name
from Return_report
where asin = 'B08QCFJ7JC'

Select product_name
from Return_report
where asin = 'B06XXKJRB2'

Select product_name
from Return_report
where asin = 'B071X2SQ3Q'

Select product_name
from Return_report
where asin = 'B098R36MF1'

Select product_name
from Return_report
where asin = 'B07CZ86L3P'



--In which fulfillment centers are the most returned products usually restocked?
--top 1 -- LAS2 and Lex2
Select  fulfillment_center_id, COUNT(*) AS B08QCFJ7JC 
FROM Return_report
WHERE ASIN = 'B08QCFJ7JC'
GROUP BY ASIN, fulfillment_center_id 
HAVING COUNT(*) > 20
ORDER BY B08QCFJ7JC  DESC

--top 2
Select  fulfillment_center_id, COUNT(*) AS B06XXKJRB2
FROM Return_report
WHERE ASIN = 'B06XXKJRB2'
GROUP BY ASIN, fulfillment_center_id 
HAVING COUNT(*) > 20
ORDER BY B06XXKJRB2  DESC

--top3
Select fulfillment_center_id, COUNT(*) as B071X2SQ3Q
FROM Return_report
WHERE ASIN = 'B071X2SQ3Q'
GROUP BY ASIN, fulfillment_center_id
ORDER BY B071X2SQ3Q DESC

--top4
Select fulfillment_center_id, COUNT(*) AS B098R36MF1
from Return_report
WHERE ASIN = 'B098R36MF1'
GROUP BY ASIN, fulfillment_center_id
ORDER BY B098R36MF1 DESC


--top5
Select fulfillment_center_id, COUNT(*) as B07CZ86L3P
from  Return_report
WHERE ASIN = 'B07CZ86L3P'
GROUP BY ASIN, fulfillment_center_id
ORDER BY B07CZ86L3P DESC


Select fulfillment_center_id, ASIN, COUNT(*) as COUNT_
FROM Return_report
WHERE fulfillment_center_id = 'LAS2'
GROUP BY ASIN, fulfillment_center_id
ORDER BY COUNT_ DESC

Select ASIN, COUNT(*) As Highest_ASIN,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_ASIN	 
FROM RETURN_REPORT
GROUP BY ASIN
ORDER BY Highest_ASIN DESC

----Which dates have the highest number of returns? December 28

Select MIN(return_date) as oldest_date, (SELECT MAX(return_date)) as latest_date
FROM Return_report

Select MONTH(Return_date) as Month_,
       COUNT(*) as Return_count
from Return_report
Group by MONTH(return_date)
ORDER by Return_count DESC


--Which SKUs have multiple returns from the same order ID?

Select order_id, sku, count(sku) as sku_count_per_order
from Return_report
group by order_id, sku
Having count(sku) > 1
order by order_id desc

Select *
from Return_report
where order_id = '702-9711423-1433019' and sku = 'W3-PVC3-UB4N'

--For each product,  quantity returned per order? ONE

SELECT 
    order_id,
    sku,
    SUM(quantity) AS quantity_returned_per_order
FROM Return_report
GROUP BY order_id, sku;

--Which reason codes (e.g., MISSING_PARTS, DEFECTIVE) are most common per fulfillment center? The most common reason is DEFECTIVE 

with cte as (Select fulfillment_center_id, REASON, COUNT(reason) as Return_reason_count,
ROW_NUMBER() OVER(PARTITION BY fulfillment_center_id Order by COUNT(reason) DESC) as Rank_
FROM Return_report
GROUP BY fulfillment_center_id, REASON
Having COUNT(reason) > 9),

cte_2 as (Select fulfillment_center_id,  Count(*) as Total_count
FROM Return_report
GROUP BY fulfillment_center_id),

cte_3 as (Select fulfillment_center_id, Count(reason) as Customer_damaged_count
from return_report
Where detailed_disposition = 'Customer_damaged'
GROUP BY fulfillment_center_id)  

Select a.fulfillment_center_id, a.reason, a.Return_reason_count, CONCAT(CAST(a.Return_reason_count * 100.0/b.Total_count as Decimal(5,2)), '%') as percentage_of_retur_per_fc, c.Customer_damaged_count,
CASE
 WHEN c.Customer_damaged_count > a.Return_reason_count then 'All defective were damaged by customer'
 ELSE 'Not all defective products are damaged by customer'
END as Customer_damaged__defective
FROM cte a
JOIN cte_2 b
ON a.fulfillment_center_id = b.fulfillment_center_id
JOIN cte_3 c
ON  b.fulfillment_center_id =  c.fulfillment_center_id
where a.Rank_ = 1
ORDER BY a.Return_reason_count DESC


--most common is defective, how many are customer damaged amoung these defective products?

--For each detailed_disposition, what % of returns are “Unit returned to inventory” vs reimbursed?


with cte as(Select detailed_disposition, count(*) as detailed_disposition_count
FROM Return_report
GROUP BY detailed_disposition),

cte_2 as(Select detailed_disposition, count(*) as Unit_returned_to_inventory
FROM Return_report
where status = 'Unit returned to inventory'
GROUP BY detailed_disposition),

cte_3 as (Select detailed_disposition, count(*) as Reimbursed
FROM Return_report
where status = 'Reimbursed'
GROUP BY detailed_disposition)

SELECT 
    COALESCE(a.detailed_disposition, b.detailed_disposition, c.detailed_disposition) AS detailed_disposition,
    a.detailed_disposition_count,
    b.Unit_returned_to_inventory,
    CONCAT(
        CAST(b.Unit_returned_to_inventory * 100.00 / NULLIF(a.detailed_disposition_count, 0) AS DECIMAL(5,2)), '%'
    ) AS 'Percentage of Unit_returned_to_inventory',
    c.Reimbursed,
    CONCAT(
        CAST(c.Reimbursed * 100.00 / NULLIF(a.detailed_disposition_count, 0) AS DECIMAL(5,2)), '%'
    ) AS 'Percentage of Unit reimbursed'
FROM cte a
FULL JOIN cte_2 b
   ON a.detailed_disposition = b.detailed_disposition
FULL JOIN cte_3 c
   ON COALESCE(a.detailed_disposition,  b.detailed_disposition) = c.detailed_disposition
ORDER BY a.detailed_disposition_count DESC;

--SIMPLER CODE, SAME RESULT AS ABOVE

Select detailed_disposition, count(*)
from Return_report
group by detailed_disposition

SELECT 
    detailed_disposition,
    COUNT(*) AS detailed_disposition_count,
    SUM(CASE WHEN status = 'Unit returned to inventory' THEN 1 ELSE 0 END) AS Unit_returned_to_inventory,
    CONCAT(
        CAST(SUM(CASE WHEN status = 'Unit returned to inventory' THEN 1 ELSE 0 END) * 100.0 
             / COUNT(*) AS DECIMAL(5,2)), '%'
    ) AS Percentage_Unit_returned_to_inventory,
    SUM(CASE WHEN status = 'Reimbursed' THEN 1 ELSE 0 END) AS Reimbursed,
    CONCAT(
        CAST(SUM(CASE WHEN status = 'Reimbursed' THEN 1 ELSE 0 END) * 100.0 
             / COUNT(*) AS DECIMAL(5,2)), '%'
    ) AS Percentage_Reimbursed
FROM Return_report
GROUP BY detailed_disposition
ORDER BY detailed_disposition_count DESC;

--Identify the top 5 products most often marked as CUSTOMER_DAMAGED.

SELECT TOP 5 
       asin, 
       product_name,  
       COUNT(*) AS count_
FROM Return_report
WHERE detailed_disposition = 'CUSTOMER_DAMAGED'
GROUP BY asin, product_name
ORDER BY count_ DESC;


--How do returns vary by day of week?
select  DATENAME(weekday, return_date) as 'day of the week', count(*) as count_
from Return_report
group by DATENAME(weekday, return_date)
order by count(*) desc

--Which fulfillment centers have the highest proportion of returns marked as customer damaged?

Select fulfillment_center_id, count(*), 
sum(case when detailed_disposition = 'customer_damaged' then 1 else 0 end) as count_,
concat(cast(sum(case when detailed_disposition = 'customer_damaged' then 1 else 0 end) * 100.00/count(*)  as decimal(5,2)), '%')
from Return_report
group by fulfillment_center_id
order by count(*) desc

--Which products are most often returned due to damaged_by_fc and damaged_by_carrier

Select asin, product_name, reason, count(*)
from Return_report
where reason IN ('damaged_by_fc', 'damaged_by_carrier')
Group BY asin, product_name,reason
order by reason DESC

