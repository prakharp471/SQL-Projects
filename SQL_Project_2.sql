
-- ---------------------------------------------
-- SIT772 Assignment 5.1P SQL Script
-- Author: Prakhar Pandey
-- Description: Basic SQL DDL and DML with SELECT Queries
-- ---------------------------------------------

-- DROP TABLES IF THEY EXIST
DROP TABLE IF EXISTS manages;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS employee;

-- CREATE TABLES

CREATE TABLE employee (
  employeeName CHAR(15) NOT NULL,
  street CHAR(15),
  city CHAR(10),
  PRIMARY KEY (employeeName)
);

CREATE TABLE company (
  companyName CHAR(15) NOT NULL,
  city CHAR(10) NOT NULL,
  PRIMARY KEY (companyName, city)
);

CREATE TABLE works (
  employeeName CHAR(15) NOT NULL,
  companyName CHAR(15) NOT NULL,
  salary NUMERIC(7),
  PRIMARY KEY (employeeName, companyName),
  CHECK (salary >= 0)
);

CREATE TABLE manages (
  employeeName CHAR(15) NOT NULL,
  managerName CHAR(15),
  PRIMARY KEY (employeeName)
);

-- INSERT DATA INTO employee
INSERT INTO employee VALUES ('Jones', 'Main', 'Harrison');
INSERT INTO employee VALUES ('Smith', 'North', 'Rye');
INSERT INTO employee VALUES ('Hayes', 'Main', 'Harrison');
INSERT INTO employee VALUES ('Curry', 'North', 'Rye');
INSERT INTO employee VALUES ('Lindsay', 'Park', 'Pittsfield');
INSERT INTO employee VALUES ('Turner', 'Putname', 'Stamford');
INSERT INTO employee VALUES ('Williams', 'Nassus', 'Princeton');
INSERT INTO employee VALUES ('Adams', 'Spring', 'Pittsfield');

-- INSERT DATA INTO company
INSERT INTO company VALUES ('Waltons', 'Harrison');
INSERT INTO company VALUES ('Meyer', 'Rye');
INSERT INTO company VALUES ('Waltons', 'Rye');
INSERT INTO company VALUES ('Woolworths', 'Pittsfield');
INSERT INTO company VALUES ('Tweeties', 'Harrison');
INSERT INTO company VALUES ('Firebrand', 'Woodside');

-- INSERT DATA INTO works
INSERT INTO works VALUES ('Jones', 'Tweeties', 91000);
INSERT INTO works VALUES ('Smith', 'Waltons', 92000);
INSERT INTO works VALUES ('Hayes', 'Woolworths', 69000);
INSERT INTO works VALUES ('Curry', 'Meyer', 85000);
INSERT INTO works VALUES ('Lindsay', 'Meyer', 79000);
INSERT INTO works VALUES ('Turner', 'Firebrand', 70000);
INSERT INTO works VALUES ('Williams', 'Tweeties', 78000);
INSERT INTO works VALUES ('Adams', 'Meyer', 82000);

-- INSERT DATA INTO manages
INSERT INTO manages VALUES ('Jones', 'Collins');
INSERT INTO manages VALUES ('Smith', 'Collins');
INSERT INTO manages VALUES ('Hayes', 'Wills');
INSERT INTO manages VALUES ('Curry', 'Wills');
INSERT INTO manages VALUES ('Lindsay', 'Mulhare');
INSERT INTO manages VALUES ('Turner', 'Mulhare');
INSERT INTO manages VALUES ('Williams', 'Bond');
INSERT INTO manages VALUES ('Adams', 'Bond');

-- SELECT QUERIES

-- 1. Names and salary of employees
SELECT employeeName AS "Employee Name", salary FROM works;

-- 2. Name, street, and city of employees ordered by name
SELECT employeeName, street, city FROM employee ORDER BY employeeName ASC;

-- 3. Manages table sorted by manager desc, employee asc
SELECT * FROM manages ORDER BY managerName DESC, employeeName ASC;

-- 4. Unique city-street combinations sorted
SELECT DISTINCT city, street FROM employee ORDER BY city ASC, street ASC;

-- 5. Name and salary of employees in Tweeties
SELECT employeeName, salary FROM works WHERE companyName = 'Tweeties' ORDER BY salary ASC;

-- 6. Name and Monthly Salary
SELECT employeeName AS "Employee Name", salary/12 AS "Monthly Salary" FROM works;

-- 7. Employees in Meyer earning > 80000
SELECT employeeName, salary FROM works WHERE companyName = 'Meyer' AND salary > 80000;

-- 8. Employees earning between 80000 and 85000
SELECT employeeName, companyName FROM works WHERE salary BETWEEN 80000 AND 85000;

-- 9. Employees whose managers have 'll'
SELECT employeeName FROM manages WHERE managerName LIKE '%ll%';

-- 10. Highest earning employee(s) per company
SELECT employeeName, companyName, salary FROM works w
WHERE salary = (
  SELECT MAX(salary) FROM works WHERE companyName = w.companyName
);

-- 11. Companies with avg salary >= 84000
SELECT companyName FROM works GROUP BY companyName HAVING AVG(salary) >= 84000;

-- 12. Employees working in companies in Pittsfield
SELECT * FROM works WHERE companyName IN (
  SELECT companyName FROM company WHERE city = 'Pittsfield'
);

-- 13. Number of managers
SELECT COUNT(DISTINCT managerName) AS num_managers FROM manages;



-- ---------------------------------------------
-- SIT772 SQL Project: Advanced SELECT with JOINs
-- ---------------------------------------------

-- Assumes the following tables are already created via Task6_1P-library.sql:
-- BOOK, PATRON, AUTHOR, CHECKOUT

-- 1. Books currently checked out: book number, title, patron ID, last name, and patron type
SELECT 
    B.BookNumber,
    B.Title,
    P.PatronID,
    P.LastName,
    P.PatronType
FROM 
    BOOK B
JOIN 
    PATRON P ON B.PatronID = P.PatronID
WHERE 
    B.PatronID IS NOT NULL
ORDER BY 
    B.Title;

-- 2. Books never checked out: book number, title, cost
SELECT 
    B.BookNumber,
    B.Title,
    B.Cost
FROM 
    BOOK B
LEFT JOIN 
    CHECKOUT C ON B.BookNumber = C.BookNumber
WHERE 
    C.BookNumber IS NULL
ORDER BY 
    B.Cost DESC, B.Title ASC;

-- 3. Books in "Programming": book title, patron ID, full name, patron type
SELECT 
    B.Title,
    P.PatronID,
    CONCAT(P.FirstName, ' ', P.LastName) AS FullName,
    P.PatronType
FROM 
    BOOK B
JOIN 
    PATRON P ON B.PatronID = P.PatronID
WHERE 
    B.Subject = 'Programming'
ORDER BY 
    B.Title, P.LastName, P.FirstName;

-- 4. Books in "Database": author ID, name, book number and title
SELECT 
    A.AuthorID,
    A.FirstName,
    A.LastName,
    B.BookNumber,
    B.Title
FROM 
    BOOK B
JOIN 
    WRITTENBY W ON B.BookNumber = W.BookNumber
JOIN 
    AUTHOR A ON W.AuthorID = A.AuthorID
WHERE 
    B.Subject = 'Database'
ORDER BY 
    B.Title ASC, A.LastName ASC;

-- 5. Times each book has been checked out
SELECT 
    B.BookNumber,
    B.Title,
    COUNT(C.CheckoutNumber) AS "Times Checked Out"
FROM 
    BOOK B
LEFT JOIN 
    CHECKOUT C ON B.BookNumber = C.BookNumber
GROUP BY 
    B.BookNumber, B.Title
ORDER BY 
    "Times Checked Out" DESC, B.Title ASC;

-- 6. Average days kept (only books checked out 4+ times), rounded to 2 decimals
SELECT 
    B.BookNumber,
    B.Title,
    ROUND(AVG(DATEDIFF(C.DateReturned, C.DateOut)), 2) AS "Average Days Kept"
FROM 
    BOOK B
JOIN 
    CHECKOUT C ON B.BookNumber = C.BookNumber
GROUP BY 
    B.BookNumber, B.Title
HAVING 
    COUNT(*) >= 4
ORDER BY 
    "Average Days Kept" DESC;
