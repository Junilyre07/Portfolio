Use [SQL Project_Sales]

Select Count(*) as 'Number of Sales Transactions(2011-2016)'
FROM Sales
--112036 

Select Sum(Order_Quantity) as 'Total Sales_Volume(2011-2016)'
FROM Sales
--The sales volume  was 1,333,705 dollars.

Select Max(Year)
FROM Sales
--2016
Select Min(Year)
FROM Sales
--2011

Select MAX(date) as 'Latest date'
FROM SALES;

Select MIN(date) as 'Earliest date'
FROm Sales;

Select Year, Count(*) as 'Number of Sales Transactions per year'
FROM Sales
GROUP BY Year
ORDER by YEAR

Select Year, Sum(Order_Quantity) as 'Total Sales_Volume per year'
FROM Sales
GROUP BY Year
ORDER by YEAR
--Sales Volume skyrocketed in 2013

Select Year, Sum(Profit) as 'Profit per year'
FROM Sales
GROUP BY Year
ORDER by YEAR

Select Year, Sum(Revenue) as 'Revenue per year'
FROM Sales
GROUP BY Year
ORDER by YEAR

--What is the most common age group among bicycle buyers?

Select Profit, Revenue, Customer_Age
FROM Sales
Where Customer_Age = (Select max(Customer_Age) FROM Sales)
--87 is the oldest customer 

Select Profit, Customer_Age
FROM Sales
Where Customer_Age = (Select min(Customer_Age) FROM Sales)
--17 is the youngest

Select Country, MAx(Profit) as "Profit by country"
FROM Sales
GROUP BY country 
ORDER by MAx(Profit) DESC
-- Australia got the highest from 2011 - 2016
-- UK and France got the lowst, tied at 5056

Select Country, MAx(Revenue) as "Revenue by country"
FROM Sales
GROUP BY country 
ORDER by MAx(Revenue) DESC
--Australia: Australia stands out as the most profitable market, generating $15,096 in profit and the highest revenue at $58,074. It is both the most profitable and revenue-generating country.
--Canada: Canada is the third-highest profit-generating country at $5,628 and the second-highest revenue-generating country at $14,312.
--United States: The United States follows as the second-highest profit-generating country with $5,638 in profit and the fourth-highest revenue at $14,026.
--Germany: Germany ranks as the fourth-highest profit-generating country with $5,485 in profit and the third-highest revenue at $14,169.
--United Kingdom and France: The United Kingdom and France share the same positions, ranking as the fifth-highest in both profit and revenue, each with $5,056 in profit and $13,740 in revenue.


Select Age_Group, SUM(Profit) as "Profit per age_group", SUM(Profit) * 100.0 / (Select SUM(Profit) from Sales) AS "Percentage of Profit", SUM(Revenue) as Revenue_per_group, SUM(Order_Quantity) as Total_Order_quantity
FROM Sales
Group By Age_Group
ORDER BY SUM(Profit) DESC
-- The 35 to 64 age bracket secured the highest profit share at 51%.
-- Seniors attained the lowest share, accounting for just 0.4%

Select Year, Age_Group, SUM(Profit) as "Profit per age_group", SUM(Profit) * 100.0 / (Select SUM(Profit) from Sales) AS "Percentage of Profit", SUM(Order_Quantity) as Total_Order_quantity
FROM Sales
Group By year, Age_Group
ORDER BY Year, SUM(Profit) DESC
--The trend remained consistent from 2011 to 2016, 
--with the highest profit consistently achieved by the Adults (35-64) group, 
--followed by the Young Adults (25-34) group in second place, the Youth (<25) group in third, 
--and Seniors (64+) with the lowest profit.

Select Year, Age_Group, SUM(Revenue) as "Revenue per age_group", SUM(Revenue) * 100.0 / (Select SUM(Revenue) from Sales) AS "Percentage of Revenue", SUM(Order_Quantity) as Total_Order_quantity
FROM Sales
Group By year, Age_Group
ORDER BY Year, SUM(Revenue) DESC
--In terms of revenue, Adults(35-64) remained consistent to be the highest-revenue generating age group. 

Select Age_Group, Count(*) as "Number of Sales per age_group", Count(*) * 100.0 / (Select Count(*) from Sales) As "Percentage"
FROM Sales
Group by Age_group
ORDER BY Count(*) DESC

Select Year, Age_Group, Count(*) as "Number of Sales transaction per age_group", Count(*) * 100.0 / (Select Count(*) from Sales) As "Percentage"
FROM Sales
Group by Year, Age_group
ORDER BY YEAR, Count(*) DESC

___________________________________________________________________________________________________________________________________________
--Which specific Product_category had the highest sales  from 2011 to 2016?


Select Year, Product_Category, COUNT(*) AS "Number of Sales Transaction", SUM(Order_Quantity) AS Order_Quantity, SUM(Profit) as Profit, SUM(Profit) * 100.0 /(Select SUM(Profit) From sales) AS "Percentage of Profit"
FROM Sales
GROUP BY Product_Category, Year
Order By Year,SUM(Profit) DESC
--The "bike" category maintains consistent profitability, revenue, and sales volume from 2011 to 2016.
--The increase in profit and sales volume in 2013 was attributable to the store's introduction of new product categories during that year.


Select Year, Product_Category,  SUM(Revenue) AS Revenue
FROM Sales
GROUP BY Product_Category, Year
Order By Year,SUM(Revenue) DESC
--In terms of revenue, Bikes remain consistent 


Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Profit) AS Profit, SUM(Profit) * 100.0/ (Select SUM(Profit) FROM sales) AS "Percentage of Profit", SUM(Revenue) as Revenue
FROM Sales
WHERE Product_Category = 'Bikes'
GROUP BY Sub_Category
ORDER by SUM(Profit) DESC
--In the Bike category, road bikes got the highest. Touring bike got the lowest.

Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Profit) AS Profit, SUM(Profit) * 100.0/ (Select SUM(Profit) FROM sales) AS "Percentage of Profit", SUM(Revenue) as Revenue
FROM Sales
WHERE Product_Category = 'Bikes'
GROUP BY Sub_Category
ORDER by SUM(Order_Quantity) DESC

Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Revenue) as Revenue
FROM Sales
WHERE Product_Category = 'Bikes'
GROUP BY Sub_Category
ORDER by SUM(Revenue) DESC
--In the Bike category, road bikes got the highest. Touring bike got the lowest across Profir, Revenue and Sales Volume


Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Profit) AS Profit, SUM(Profit) * 100.0/ (Select SUM(Profit) FROM sales) AS "Percentage of Profit", SUM(Revenue) as Revenue
FROM Sales
WHERE Product_Category = 'Clothing'
GROUP BY Sub_Category
ORDER by SUM(Order_Quantity) DESC

Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Revenue) as Revenue
FROM Sales
WHERE Product_Category = 'Clothing'
GROUP BY Sub_Category
ORDER by SUM(Revenue) DESC

Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Profit) as Profit
FROM Sales
WHERE Product_Category = 'Clothing'
GROUP BY Sub_Category
ORDER by SUM(Profit) DESC


--In terms of profitability, shorts ranked highest, while caps had the lowest profit margin.
--jerseys got the highest and vests the lowesr, it is interesting that caps got the lowesr profit but came 2nd when it comes to sales volume
--The implication of this statement is that there is a surprising or unexpected relationship between the profit margin and sales volume of caps. 
--Despite caps having the lowest profit margin, they managed to achieve the second-highest sales volume. 
--This suggests that caps may have a strong market demand or a large customer base, 
--which compensates for their lower profit margin. It also raises the possibility of exploring strategies to increase the profitability of caps without compromising their popularity among customers.
--In terms of revenue,  Jerseys ranked highest, while socks had the lowest profit margin.

Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Profit) AS Profit, SUM(Profit) * 100.0/ (Select SUM(Profit) FROM sales) AS "Percentage of Profit"
FROM Sales
WHERE Product_Category = 'Accessories'
GROUP BY Sub_Category
ORDER by SUM(Order_Quantity) DESC
--When it comes to sales volume, tires and tubes were the top performers, while bike stands had the lowest sales.
--Helmets generated the highest profit but took the third spot in terms of sales volume.

Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Revenue) as Revenue
FROM Sales
WHERE Product_Category = 'Accessories'
GROUP BY Sub_Category
ORDER by SUM(Revenue) DESC

Select Sub_Category, SUM(Order_Quantity) AS "Total Sales Volume", SUM(Profit) as Profit
FROM Sales
WHERE Product_Category = 'Accessories'
GROUP BY Sub_Category
ORDER by SUM(Profit) DESC


__________________________________________________________________________________________________________________________________________
Select Product, Unit_Cost, Unit_price
FROM SALES
WHERE Unit_cost = (Select MAX(Unit_cost)FROM SALES)


-- Create a view with the Markup column
CREATE VIEW SalesWithMarkup AS
Select Product_Category, Sub_Category, Product, MAX(Unit_Cost) as Unit_Cost, MAX(Unit_Price) as Unit_Price, (CAST(MAX(unit_cost) AS DECIMAL) / CAST(MAX(unit_price) AS DECIMAL))* 100 AS Markup
FROM Sales
GROUP BY  Product, Sub_Category, Product_Category 

Select Product_Category Sub_Category, Product, Markup
FROM SalesWithMarkup
Where Markup = (Select MAX(Markup) FROM SalesWithMarkup)
-- The highest markup, which stands at 77.77, is associated with six products from the Clothing category and one from the Accessories category.

Select Product_Category, Sub_Category, Markup
FROM SalesWithMarkup
Where Product_Category LIKE '%Accessories%' 
ORDER BY Markup DESC
--It is interesting to note that the Helmet sub-category yielded the highest profit, yet it didn't secure a top position in terms of markup value.

Select Product_Category, Sub_Category, Markup
FROM SalesWithMarkup
Where Product_Category LIKE '%Bikes%' 
ORDER BY Markup DESC

Select Product_Category, Sub_Category, Markup
FROM SalesWithMarkup
Where Product_Category LIKE '%Clothing%' 
ORDER BY Markup DESC

Select Year, Month, Product_Category, Sub_Category, Product, MAX(Unit_Cost) as Unit_Cost, MAX(Unit_Price) as Unit_Price, (CAST(MAX(unit_cost) AS DECIMAL) / CAST(MAX(unit_price) AS DECIMAL))* 100 AS Markup
FROM Sales
Where Product_Category LIKE '%Bikes%' and Sub_Category LIKE '%Road Bikes%'
GROUP BY Year, Month, Product, Sub_Category, Product_Category 
ORDER BY Markup DESC

Select Year, Month, Product_Category, Sub_Category, Product, MAX(Unit_Cost) as Unit_Cost, MAX(Unit_Price) as Unit_Price, (CAST(MAX(unit_cost) AS DECIMAL) / CAST(MAX(unit_price) AS DECIMAL))* 100 AS Markup
FROM Sales
Where Product_Category LIKE '%Clothing%' and Sub_Category LIKE '%Jersey%'
GROUP BY Year, Month, Product, Sub_Category, Product_Category 
ORDER BY Markup DESC

-- The unit cost and unit price also fluctuates

__________________________________________________________________________________________________________________________________________
Select s1.Age_Group, s1.Country, s2.Profit_Country, s2.Percentage as "Profit_Country%", s1.Profit as "Profit per age_group", s1.Percentage
FROM
(
	Select Age_Group, Country, SUM(Profit) as "Profit", SUM(Profit) * 100.0/ (Select SUM(Profit) FROM Sales) AS "Percentage"
	FROM SALES
	GROUP BY Age_Group, Country
) s1
JOIN
(
	Select  Country, SUM(Profit) AS "Profit_Country", SUM(Profit) * 100.0 / (SELECT SUM(Profit) FROM Sales) AS "Percentage"
	FROM Sales
	Group by  Country
) s2
ON s1.Country = s2.Country
ORDER by s2.Profit_Country DESC


--In terms of location, the USA has the highest profit, while France has the lowest.

Select s1.Age_Group, s1.Country, s2.Revenue_Country, s2.Percentage as "Revenue_Country%", s1.Revenue as "Revenue per age_group", s1.Percentage
FROM
(
	Select Age_Group, Country, SUM(Revenue) as "Revenue", SUM(Revenue) * 100.0/ (Select SUM(Revenue) FROM Sales) AS "Percentage"
	FROM SALES
	GROUP BY Age_Group, Country
) s1
JOIN
(
	Select  Country, SUM(Revenue) AS "Revenue_Country", SUM(Revenue) * 100.0 / (SELECT SUM(Revenue) FROM Sales) AS "Percentage"
	FROM Sales
	Group by  Country
) s2
ON s1.Country = s2.Country
ORDER by s2.Revenue_Country DESC


_______________________________________________________________________________________________________________________________________
Select Customer_Gender, SUM(Order_Quantity) as SALES Volume
FROM Sales
GROUP BY Customer_Gender
ORDER BY SUM(Order_Quantity)  DESC

Select Customer_Gender, Country, SUM(Order_Quantity) as Sales , SUM(Profit) as Profit
FROM Sales
GROUP BY Country, Customer_Gender
ORDER BY SUM(Order_Quantity) DESC
--"It's intriguing to notice that in the USA, Australia, and Canada, Germany the majority of customers are male.
--This could suggest a strong male demographic interest in cycling-related products in these countries. 
--Conversely, in the United Kingdom, Franc  where the customer base leans more towards females,

Select s1.Country, s1. Customer_Gender, s1."Order_Quantity", s1."Profit"
FROM
(
	Select Customer_Gender, Country, SUM(Order_Quantity) AS "Order_Quantity", SUM(Profit) AS "Profit"
	FROM Sales
	GROUP BY Customer_Gender, Country
) s1
JOIN
(  Select Customer_Gender, SUM(Profit) AS "Profit_Gender"
	FROM Sales
	GROUP BY Customer_Gender
) s2
ON s1.Customer_Gender = s2.Customer_Gender
ORDER by s1.Profit Desc

--When considering gender by country, the distribution is as follows:

--USA: More males
--Australia: More females
--United Kingdom: More females
--Canada: More males
--Germany: More females
--France: More males

--It's interesting to note that the distribution of gender in terms of profit and sales volume doesn't necessarily match in every country. For example, in the USA, there are more males contributing to both profit and sales volume. However, in the United Kingdom, more females contribute to profit, but more males contribute to sales volume.



Select Country, State, SUM(Profit) as "Profit"
FROM Sales
GROUP BY State, Country
Having Country = 'United States'
ORDER BY SUM(Profit) DESC
--In the USA, California has the highest profit, while Alabama has the lowest.

Select Country, State, SUM(Profit) as "Profit", COUNT(*)
FROM Sales
GROUP BY State, Country
Having Country = 'Australia'
ORDER BY SUM(Profit) DESC
--In Australia , New South Waleshas the highest profit, while Tasmania has the lowest.

Select Country, State, SUM(Profit) as "Profit", COUNT(*)
FROM Sales
GROUP BY State, Country
Having Country = 'Canada'
ORDER BY SUM(Profit) DESC
--In Canada, British Columbia the highest profit, while Ontario has the lowest.


Select Country, State, SUM(Profit) as "Profit", COUNT(*)
FROM Sales
GROUP BY State, Country
Having Country = 'Germany'
ORDER BY SUM(Profit) DESC
--In Germany , Hessen the highest profit, while Brandenburg has the lowest.


Select Country, State, SUM(Profit) as "Profit", COUNT(*)
FROM Sales
GROUP BY State, Country
Having Country = 'France'
ORDER BY SUM(Profit) DESC
--In France , Seine (Paris) the highest profit, while Pas de Calais has the lowest.


--What is the most selling product in each country
Select Country, Product,  Product_Category, SUM(Profit) as Profit_by_Product
FROM Sales
GROUP BY Country, Product,  Product_Category
Having Country = 'United States'
ORDER BY  SUM(Profit) DESC 
--In the US, top 2 most selling products are "Mountain-200 Silver, 42" and "Road-150 Red, 52". Both Bikes category.

Select Country, Product,  Product_Category, SUM(Profit)
FROM Sales
GROUP BY Country, Product,  Product_Category
Having Country = 'Canada'
ORDER BY  SUM(Profit) DESC
--In Canada, top 2 most selling products are "Mountain-200 Silver, 42" and "Sport-100 Helmet, Blue". Bikes and Accessories categories


Select Country, Product,  Product_Category, SUM(Profit)
FROM Sales
GROUP BY Country, Product,  Product_Category
Having Country = 'Australia'
ORDER BY  SUM(Profit) DESC
--In Australia, the best-selling bike is the Road-150 Red, 62, while the Mountain-200 Black, 38 takes the second position.

Select Country, Product, Product_Category, SUM(Profit) as Profit
FROM Sales
GROUP BY Country, Product, Product_Category
Having Country = 'Germany'
ORDER BY SUM(Profit) DESC
--In Germany, the top two selling bikes are the Mountain-200 Silver, 46 and the Mountain-200 Silver, 42.


Select Country, Product, Product_Category, SUM(Profit) as Profit
FROM Sales
GROUP BY Country, Product, Product_Category
Having Country = 'France'
ORDER BY  SUM(Profit) DESC
--In France, Sport-100 Helmet, Red is the best selling which is an accessory. 

Select Product, SUM(Profit) as Profit
FROm Sales
Group BY Product
Order By SUM(Profit) Desc
--Among all the products, the Mountain-200 Black, 38 contributes the highest to profits.


Select Product, SUM(Order_Quantity) as Total_Order_quantity
FROm Sales
Group BY Product
Order By SUM(Order_Quantity) DESC
--When it comes to the sales volume, the Water Bottle - 30 oz. ranks the highest.
