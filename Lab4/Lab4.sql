DROP FUNCTION IF EXISTS customer_spent;
CREATE FUNCTION customer_spent(start_number INT, end_customer INT)
RETURNS DOUBLE
    DETERMINISTIC
BEGIN
    DECLARE result DOUBLE;

    SELECT SUM(p.amount) INTO result
     FROM payments p
        JOIN customers c ON p.customerNumber = c.customerNumber
        WHERE p.customerNumber BETWEEN start_number AND  end_customer;

   RETURN ROUND(result, 2);
END;

SELECT customer_spent(100, 1000);

CREATE FUNCTION get_customer_status(customer_number INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
   DECLARE customer_amount INT;
   SELECT SUM(p.amount) INTO customer_amount FROM payments p
    JOIN customers c ON p.customerNumber = c.customerNumber
    WHERE c.customerNumber = customer_number;

    IF customer_amount BETWEEN 20000 AND 50000 THEN
         RETURN "Weak customer";
    ELSEIF customer_amount BETWEEN 50000 AND 100000 THEN
         RETURN "Solid customer";
    END IF;

   RETURN "Great customer";
END;

SELECT get_customer_status(107);

ALTER TABLE customers
    ADD customerType TEXT NULL;

CREATE PROCEDURE get_customer_status_procedure(IN customer_number INT, OUT customer_status TEXT)
BEGIN
    SET customer_status = get_customer_status(customer_number);
    UPDATE customers c
    SET c.customerType = customer_status
    WHERE c.customerNumber = customer_number;
END;

SET @customer_status = NULL;
CALL get_customer_status_procedure(107, @customer_status);
SELECT @customer_status;


DROP PROCEDURE IF EXISTS trigger_both_functions;
CREATE PROCEDURE trigger_both_functions
    (IN start_customer_number INT, IN end_customer_number INT, OUT end_customer_number_status TEXT, OUT total_customers_spent DOUBLE)
BEGIN
    SET total_customers_spent = customer_spent(start_customer_number, end_customer_number);
    SET end_customer_number_status = get_customer_status(end_customer_number);
END;

SET @end_customer_number_status = NULL;
SET @total_customers_spent = NULL;
CALL trigger_both_functions(100, 107, @end_customer_number_status, @total_customers_spent);
SELECT @end_customer_number_status, @total_customers_spent;

CREATE PROCEDURE GetProductPriceHistory(
    IN ProductID INT
)
BEGIN
    SELECT
        p.Name AS ProductName,
        pp.ListPrice,
        pp.StartDate,
        pp.EndDate
    FROM
        Product AS p
            JOIN
        ProductListPriceHistory AS pp ON p.ProductID = pp.ProductID
    WHERE
        p.ProductID = ProductID
    ORDER BY
        pp.StartDate DESC;
END;

CALL GetProductPriceHistory(707)