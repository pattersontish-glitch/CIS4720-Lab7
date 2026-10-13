/* ==========================================================================
   lab6_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   This rebuilds everything in_class_lab6 asked you to build, so that whatever
   happened in the lab, you now have the same working database as everyone
   else. The lab PCs are wiped every night, which is why the database you
   built last time is not there any more. A script like this one is the real
   answer to that problem: the file is the database, and the server is
   disposable.

   WHAT IT BUILDS
     1. A schema called cis4720_yourname
     2. One table, PRODUCT, with five columns and a primary key
     3. Four rows of data
     4. One view, PRODUCT_PRICES, showing only the name and the price

   The extra credit from lab6 is deliberately NOT in here.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected, then run it one statement at a
   time, or run the whole file. Lab7 walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you will get errors,
   because the table already exists and the rows are already there. Lab7
   explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the following statements apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice.
CREATE DATABASE IF NOT EXISTS cis4720_yourname;
CREATE DATABASE IF NOT EXISTS cis4720_TishaPatterson;
-- Switch into it. Everything below lands inside this schema.
USE cis4720_TishaPatterson;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
-- INT           whole numbers, used here for the id
-- VARCHAR(40)   text up to 40 characters
-- DECIMAL(7,2)  a number with exactly 2 decimal places, correct for money
-- DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means prod_id must be unique and may never be empty.
-- ======================================================================

CREATE TABLE PRODUCT (
    prod_id     INT          NOT NULL,
    prod_name   VARCHAR(40)  NOT NULL,
    unit_price  DECIMAL(7,2),
    added_on    DATE,
    roast_level VARCHAR(10),
    PRIMARY KEY (prod_id)
);


-- ======================================================================
-- SECTION 3. The data
-- Four rows. In lab6 you added the first three by hand, then Antigua Classic
-- came later. The roast_level column was added with ALTER TABLE in lab6 and
-- is simply part of the table here.
-- ======================================================================

INSERT INTO PRODUCT VALUES (1,'Yirgacheffe',    18.50,'2026-01-15','Light');
INSERT INTO PRODUCT VALUES (2,'Huila Supremo',  15.25,'2026-03-02','Medium');
INSERT INTO PRODUCT VALUES (3,'Cerrado Daily',  12.60,'2026-05-20','Medium');
INSERT INTO PRODUCT VALUES (4,'Antigua Classic',16.80,'2026-07-04','Medium');


-- ======================================================================
-- SECTION 4. The view
-- A view is a stored SELECT statement that you can query as if it were a
-- table. This one shows only the name and the price, so anyone using it
-- cannot reach the id, the date or the roast level.
-- ======================================================================

CREATE VIEW PRODUCT_PRICES AS
SELECT prod_name, unit_price
FROM PRODUCT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so leave
-- them uncommented even after the first run.
-- ======================================================================

-- All four rows, straight from the table.
SELECT * FROM PRODUCT;

-- The view, most expensive first. Two columns, not five.
SELECT * FROM PRODUCT_PRICES ORDER BY unit_price DESC;

-- Should come back as 4 products and 63.15.
SELECT COUNT(*) AS products, SUM(unit_price) AS total_price FROM PRODUCT;

-- PRODUCT is a BASE TABLE and PRODUCT_PRICES is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7 WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 10. Section 5.1, look at your schema
SELECT DATABASE() AS my_schema;
SHOW FULL TABLES;
-- The schema is where the table lives and is housed. You list the schema to see what tables are in it and what the tables look like.  

-- STEP 11. Section 5.2, look at the data types
DESCRIBE PRODUCT;
-- It shows the different data types we specified in the tables. For example we told it to accept a max number of characters with Varchar and how many characters. We also told it to accept no characters in Unit_price and added_on and roast_level.

-- STEP 12. Section 5.3, create a table by copying with a subquery
CREATE TABLE PRODUCT_COPY AS
SELECT prod_id, prod_name, unit_price
FROM PRODUCT;
 
SELECT * FROM PRODUCT_COPY;
SHOW CREATE TABLE PRODUCT_COPY;
----It shows the table was created and the rules for the filtering of the data. 

-- STEP 13. Section 5.4, change the structure of the copy

ALTER TABLE PRODUCT_COPY ADD COLUMN on_sale CHAR(1);
----adds a new column called on_sale to the table. 

ALTER TABLE PRODUCT_COPY MODIFY COLUMN prod_name VARCHAR(60) NOT NULL;
 ---Changes the column to accept 60 charachters instead of 40.
 
ALTER TABLE PRODUCT_COPY ADD PRIMARY KEY (prod_id);
--restores the primary key to the copy table.
 
DESCRIBE PRODUCT_COPY
INSERT INTO PRODUCT_COPY VALUES (1,'Duplicate',9.99,NULL);
---produced error because we already used the primary key was already in use.

ALTER TABLE PRODUCT_COPY DROP COLUMN on_sale;
---removes the column we added called on_sale.

-- STEP 14. Section 5.5, insert, update and delete a row

INSERT INTO PRODUCT_COPY VALUES (5,'Kenya Peaberry',21.40);
SELECT * FROM PRODUCT_COPY WHERE prod_id = 5;
----Added a new row that included the product id of 5, which is Kenya Peaberry order.

UPDATE PRODUCT_COPY SET unit_price = 22.95 WHERE prod_id = 5;
SELECT * FROM PRODUCT_COPY WHERE prod_id = 5;
---it changed the unit price of the product to 22.95.

DELETE FROM PRODUCT_COPY WHERE prod_id = 5;
SELECT COUNT(*) AS rows_left FROM PRODUCT_COPY
--Shows the row with 5 dissapered  because we deleted it.


-- STEP 15. Section 5.6, create a view and update through it
CREATE VIEW CHEAP_PRODUCTS AS
SELECT prod_id, prod_name, unit_price
FROM PRODUCT_COPY
WHERE unit_price < 16.00;
---SHows all the product that have a unit price of less than 16.00.

SELECT * FROM CHEAP_PRODUCTS;
----Shows 2 products taht are priced under 16.00


SELECT prod_id, unit_price FROM PRODUCT_COPY WHERE prod_id = 3;
UPDATE CHEAP_PRODUCTS SET unit_price = 13.99 WHERE prod_id = 3;
SELECT prod_id, unit_price FROM PRODUCT_COPY WHERE prod_id = 3;
-----Shows the the items changed from 12.60 to 13.99 because we updated the view and it updated the table as well.

CREATE VIEW PRICE_SUMMARY AS
SELECT COUNT(*) AS n, SUM(unit_price) AS total
FROM PRODUCT_COPY
UPDATE PRICE_SUMMARY SET total = 99;
-----Shows the table Price_Summary is not a view it is a table.