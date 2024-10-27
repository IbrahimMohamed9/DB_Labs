USE classicmodels;
# Task 1
SELECT country,
       city,
       MAX(creditLimit) AS max_credit_limit,
       MIN(creditLimit) AS min_credit_limit,
       SUM(creditLimit) AS total_credit_limit
FROM customers
WHERE city IS NOT NULL
  AND country IS NOT NULL
GROUP BY country, city
ORDER BY country DESC, city DESC;

# Task 2
SELECT c.customerNumber, SUM(p.amount) AS total_payments
FROM customers c
         JOIN payments p ON p.customerNumber = c.customerNumber
GROUP BY c.customerNumber
ORDER BY SUM(p.amount) DESC
LIMIT 10;

# Task 3
SELECT status, COUNT(orderNumber) AS order_count
FROM orders
WHERE orderDate BETWEEN '2003-10-10' AND '2004-09-09'
GROUP BY status;

# Task 4
SELECT c.customerNumber, MAX(p.amount) AS max_payments, AVG(p.amount) AS avg_payments
FROM customers c
         JOIN payments p ON p.customerNumber = c.customerNumber
GROUP BY c.customerNumber

# Task 5
SELECT productLine,
       MAX(quantityInStock) AS max_quantityInStock,
       MIN(quantityInStock) AS min_quantityInStock,
       AVG(quantityInStock) AS avg_quantityInStock
FROM products
WHERE productLine IN ('Classic Cars', 'Trucks and Buses', 'Motorcycles')
GROUP BY productLine;

# Task 6
SELECT productCode, orderLineNumber, AVG(priceEach) AS avg_priceEach
FROM orderdetails
WHERE priceEach > 100
GROUP BY productCode, orderLineNumber
ORDER BY productCode DESC, orderLineNumber;

# Task 7
Select country, GROUP_CONCAT(customerName SEPARATOR ',') AS customer_names
FROM customers
GROUP BY country
ORDER BY country DESC;

# Task 8
SELECT
    customerName,
    phone,
    COALESCE(state, addressLine2, country) AS state_or_address_line2_or_country
FROM
    customers
WHERE
    creditLimit > 20000 AND creditLimit < 100000;

# Task 9
SELECT
    customerNumber,
    IF(amount > 10000, amount / 100, amount) AS adjusted_amount
FROM
    payments
WHERE
    checkNumber LIKE 'HQ%';


# Task 10
SELECT
    city,
    phone,
    addressLine2,
    COALESCE(state, 'N/A') AS state
FROM
    offices
WHERE
    country = 'USA';

# Task 11
SELECT *
FROM orders
WHERE
    comments IS NOT NULL
    AND status = 'Shipped'
    AND shippedDate BETWEEN '2003-01-25' AND '2003-03-20';


# Task 12
SELECT
    productCode,
    (MSRP - buyPrice) AS retail_earnings
FROM
    products
WHERE
    productCode LIKE 'S12%' OR productCode LIKE 'S18%';

# Task 13
SELECT
    productCode,
    (quantityOrdered * priceEach) AS subtotal
FROM
    orderdetails
WHERE
    quantityOrdered > 20
    AND priceEach < 120;

# Task 14
SELECT
    firstName,
    lastName,
    reportsTo,
    jobTitle,
    REPLACE(email, 'classicmodelcars.com', 'ibu.edu.ba') AS updatedEmail
FROM
    employees
WHERE
    jobTitle IN ('President', 'VP Sales', 'Sales Rep')
    OR officeCode = 1
ORDER BY
    jobTitle DESC;

# Task 15
SELECT *
FROM productlines
WHERE productLine LIKE '%Cars%';

USE adventureworks;
# Task 16
SELECT
    pr.ProductReviewID,
    pr.ReviewerName
FROM
    product p
JOIN
    productreview pr ON p.ProductID = pr.ProductID;

# Task 17
SELECT
    p.productNumber,
    pr.ReviewerName
FROM
    product p
CROSS JOIN
    productreview pr;

# Task 18
SELECT
    p.productNumber,
    pr.ReviewerName
FROM
    product p
LEFT JOIN
    productreview pr ON p.ProductID = pr.ProductID;

# Task 19
SELECT
    p.productNumber,
    pr.ReviewerName
FROM
    product p
RIGHT JOIN
    productreview pr ON p.ProductID = pr.ProductID;

# Task 20
SELECT
    p.productName,
    p.productLine,
    pl.textDescription
FROM
    products p
JOIN
    productlines pl ON p.productLine = pl.productLine;


