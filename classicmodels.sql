-- 1
SELECT DISTINCT(city)
FROM classicmodels.offices
ORDER BY city DESC;

-- 2
SELECT employeenumber, lastname, firstname, extension
FROM classicmodels.employees
WHERE officecode = '4';

-- 3
SELECT productcode, productname, productvendor, quantityinstock, productline
FROM classicmodels.products
WHERE quantityinstock BETWEEN 200 AND 1200;

-- 4
SELECT productcode, productname, productvendor, buyprice, msrp
FROM classicmodels.products
WHERE msrp = (
SELECT MIN(msrp) FROM classicmodels.products
);

-- 5
SELECT Productname, msrp - buyprice AS "Profit"
FROM classicmodels.products
WHERE msrp - buyprice =(
SELECT MAX(msrp - buyprice)
FROM classicmodels.products);

-- 6
SELECT country, COUNT(customernumber) AS "Customers"
FROM classicmodels.customers
GROUP BY country
HAVING COUNT(customernumber) = 2
ORDER BY country DESC;

-- 7
SELECT P.productcode, P.productname, COUNT(O.ordernumber)
FROM classicmodels.products P
JOIN classicmodels.orderdetails O
ON P.productcode = O.productcode
GROUP BY P.productcode, P.productname
HAVING COUNT(O.ordernumber) = 25;

-- 8
SELECT employeenumber, CONCAT(firstName, " ", lastName) AS "Name", reportsto
FROM classicmodels.employees
WHERE reportsto IN ('1002', '1102');

-- 9
SELECT employeenumber, lastname, firstname
FROM classicmodels.employees
WHERE reportsto IS NULL;

-- 10
SELECT productname, productline
FROM classicmodels.products
WHERE productline = 'Classic Cars'
AND productname LIKE '195%'
ORDER BY productname;

-- 11
SELECT COUNT(ordernumber), MONTHNAME(orderdate) AS ordermonth  
FROM classicmodels.orders  
WHERE EXTRACT(YEAR FROM orderdate) = '2004' 
GROUP BY ordermonth 
ORDER BY 1 DESC LIMIT 1;

-- 12
SELECT lastname, firstname
FROM classicmodels.employees e 
LEFT OUTER JOIN classicmodels.customers c 
ON e.employeenumber = c.salesRepEmployeeNumber
WHERE customername IS NULL
AND jobtitle = "Sales Rep";

-- 13
SELECT customername, country
FROM classicmodels.customers c 
LEFT OUTER JOIN classicmodels.orders o
ON c.customernumber = o.customernumber
WHERE o.customernumber IS NULL
AND country = 'Switzerland';

-- 14
SELECT customername, SUM(quantityordered) AS "total"
FROM classicmodels.customers c 
JOIN classicmodels.orders o
ON c.customernumber = o.customernumber
JOIN classicmodels.orderdetails d 
ON o.ordernumber = d.ordernumber
GROUP BY customername
HAVING SUM(quantityordered) > 1650;

-- DM/ DDL Queries
-- 1
CREATE TABLE IF NOT EXISTS TopCustomers ( 
 	Customernumber INT NOT NULL,  
	ContactDate DATE NOT NULL, 
     OrderTotal DECIMAL(9,2) NOT NULL DEFAULT 0, 
     CONSTRAINT PKTopCustomers PRIMARY KEY (CustomerNumber) 
 );
 
 -- 2
INSERT INTO TopCustomers 
	SELECT c.customernumber, CURRENT_DATE, 
			  SUM(priceEach * Quantityordered) 
 	   	FROM classicmodels.Customers c, classicmodels.Orders o,classicmodels.OrderDetails d  	 	
			where c.Customernumber = o.Customernumber  
      	  and o.Ordernumber = d.Ordernumber 
 	group by c.Customernumber 
 	having SUM(priceEach * Quantityordered) > 140000;
    
