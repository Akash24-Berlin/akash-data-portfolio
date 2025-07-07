-- Grocery Store Sales Analysis Project
-- Author: Akash B.
-- Description:
-- This project analyzes sales, customers, employees, and item performance 
-- for a grocery business using SQL Server. It includes 10 business-relevant 
-- questions answered with optimized SQL queries demonstrating advanced joins, 
-- grouping, aggregations, HAVING filters, subqueries, and CTEs.
-- Database: GROCERY2
-- Tables used: CUSTOMER, ORDERS, SALEITEM, ITEM, EMPLOYEE, DEPARTMENT
-- Each section includes a clear question, explanation, and SQL query.
USE GROCERY2;
SELECT * FROM CUSTOMER;
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;
SELECT * FROM ITEM;
SELECT * FROM ORDERS;
SELECT * FROM SALEITEM;

Question:
-- Which customers have total purchases exceeding $500 across all their orders?
-- Explanation:
-- This query joins CUSTOMER, ORDERS, and SALEITEM tables to calculate the total amount spent by each customer (sum of SalePrice multiplied by QtySold). It filters the results to only include customers whose total purchases exceed $500, and orders them by the highest spenders.
SELECT 
    CUSTOMER.CustId,
    CUSTOMER.CustName,
    CUSTOMER.CustCity,
    CUSTOMER.Prov,
    SUM(SALEITEM.SalePrice * SALEITEM.QtySold) AS TotalPurchase
FROM 
    CUSTOMER
JOIN 
    ORDERS ON CUSTOMER.CustId = ORDERS.CustId
JOIN 
    SALEITEM ON ORDERS.OrderNo = SALEITEM.OrderNo
GROUP BY 
    CUSTOMER.CustId, CUSTOMER.CustName, CUSTOMER.CustCity, CUSTOMER.Prov
HAVING 
    SUM(SALEITEM.SalePrice * SALEITEM.QtySold) > 500
ORDER BY 
    TotalPurchase DESC;

-- Question:
-- Which item has generated the highest total revenue?
--
-- Explanation:
-- This query joins ITEM and SALEITEM tables to calculate total revenue for each item
-- (sum of SalePrice multiplied by QtySold). It orders the items by total revenue in
-- descending order and returns the single top-selling item.
SELECT TOP 1
    ITEM.ItemId,
    ITEM.ItemDesc,
    SUM(SALEITEM.SalePrice * SALEITEM.QtySold) AS TotalRevenue
FROM 
    ITEM
JOIN 
    SALEITEM ON SALEITEM.ItemId = ITEM.ItemId
GROUP BY 
    ITEM.ItemId, ITEM.ItemDesc
ORDER BY 
    TotalRevenue DESC;


-- Question:
-- Which city has generated the highest total sales revenue?
--
-- Explanation:
-- This query joins CUSTOMER, ORDERS, and SALEITEM tables, calculates total sales revenue
-- per city by summing SalePrice multiplied by QtySold, and returns the city with the
-- highest total revenue using TOP 1.

SELECT TOP 1 
    CUSTOMER.CustCity, 
    SUM(SALEITEM.SalePrice * SALEITEM.QtySold) AS TotalSalesRevenue
FROM 
    CUSTOMER
JOIN 
    ORDERS ON CUSTOMER.CustId = ORDERS.CustId
JOIN 
    SALEITEM ON ORDERS.OrderNo = SALEITEM.OrderNo
GROUP BY 
    CUSTOMER.CustCity
ORDER BY 
    TotalSalesRevenue DESC;

	-- Question:
-- Which employee has processed the highest number of orders?
--
-- Explanation:
-- This query joins EMPLOYEE and ORDERS tables, counts distinct orders processed by each
-- employee, and returns the employee with the highest total orders using TOP 1.

SELECT TOP 1 
    EMPLOYEE.EmpId, 
    EMPLOYEE.EmpName, 
    COUNT(DISTINCT ORDERS.OrderNo) AS TotalOrders
FROM 
    EMPLOYEE
JOIN 
    ORDERS ON EMPLOYEE.EmpId = ORDERS.EmpId
GROUP BY 
    EMPLOYEE.EmpId, EMPLOYEE.EmpName
ORDER BY 
    TotalOrders DESC;

--Question:
-- What is the average order value across all orders?
--
-- Explanation:
-- This query first calculates the total value of each order by joining ORDERS and SALEITEM,
-- then takes the average of these order totals across all orders using a common table expression (CTE).

WITH OrderTotals AS (
    SELECT 
        OrderNo,
        SUM(SalePrice * QtySold) AS OrderTotal
    FROM 
        SALEITEM
    GROUP BY 
        OrderNo
)
SELECT 
    AVG(OrderTotal) AS AverageOrderValue
FROM 
    OrderTotals;

-- Question:
-- Which item category has generated the highest total sales revenue?
--
-- Explanation:
-- This query joins ITEM and SALEITEM tables, calculates total revenue per item category
-- by summing SalePrice multiplied by QtySold, and returns the highest-grossing category
-- using OFFSET and FETCH.

SELECT 
    ITEM.ItemCategory, 
    SUM(SALEITEM.SalePrice * SALEITEM.QtySold) AS SalesRevenue
FROM 
    ITEM
JOIN 
    SALEITEM ON ITEM.ItemId = SALEITEM.ItemId
GROUP BY 
    ITEM.ItemCategory
ORDER BY 
    SalesRevenue DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

-- Question:
-- List the top 5 customers with the highest outstanding balances.
--
-- Explanation:
-- This query selects CustId, CustName, and Balance from the CUSTOMER table, orders by Balance
-- in descending order, and limits the results to the top 5 customers with the highest balances
-- using OFFSET and FETCH.

SELECT 
    CUSTOMER.CustId, 
    CUSTOMER.CustName, 
    CUSTOMER.Balance
FROM 
    CUSTOMER
ORDER BY 
    CUSTOMER.Balance DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Question:
-- Which day had the highest total sales revenue?
--
-- Explanation:
-- This query joins ORDERS and SALEITEM tables, calculates total revenue per OrderDate
-- by summing SalePrice multiplied by QtySold, and returns the single day with the highest
-- total sales revenue using TOP 1.

SELECT TOP 1 
    ORDERS.OrderDate, 
    SUM(SALEITEM.SalePrice * SALEITEM.QtySold) AS SalesRevenue
FROM 
    ORDERS
JOIN 
    SALEITEM ON ORDERS.OrderNo = SALEITEM.OrderNo
GROUP BY 
    ORDERS.OrderDate
ORDER BY 
    SalesRevenue DESC;

-- Question:
-- Which items have sold more than 100 units in total, and what is the total quantity sold for each?
--
-- Explanation:
-- This query joins ITEM and SALEITEM tables, sums the quantity sold for each item, filters items with
-- total quantity greater than 100 using HAVING, and orders the results by QuantitySold in descending order.

SELECT 
    ITEM.ItemId, 
    ITEM.ItemDesc, 
    SUM(SALEITEM.QtySold) AS QuantitySold
FROM 
    ITEM
JOIN 
    SALEITEM ON ITEM.ItemId = SALEITEM.ItemId
GROUP BY 
    ITEM.ItemId, ITEM.ItemDesc
HAVING 
    SUM(SALEITEM.QtySold) > 100
ORDER BY 
    QuantitySold DESC;

	-- Question:
-- Which customers placed more than one order on the same day?
--
-- Explanation:
-- This query joins CUSTOMER and ORDERS tables, groups by CustId and OrderDate,
-- and filters with HAVING to include only those groups where customers placed
-- multiple orders on the same day. It returns CustId, CustName, OrderDate, and
-- the number of orders for that day.

SELECT 
    CUSTOMER.CustId, 
    CUSTOMER.CustName, 
    ORDERS.OrderDate, 
    COUNT(ORDERS.OrderNo) AS TotalOrders
FROM 
    CUSTOMER
JOIN 
    ORDERS ON CUSTOMER.CustId = ORDERS.CustId
GROUP BY 
    CUSTOMER.CustId, CUSTOMER.CustName, ORDERS.OrderDate
HAVING 
    COUNT(ORDERS.OrderNo) > 1
ORDER BY 
    CUSTOMER.CustId, ORDERS.OrderDate;
