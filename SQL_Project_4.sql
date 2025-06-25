
-- ---------------------------------------------
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



-- ---------------------------------------------
-- SIT772 SQL Project: DDL and Other DML Queries
-- ---------------------------------------------

-- Drop tables if they exist
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS EMP;

-- 1. Create EMPLOYEE table
CREATE TABLE EMPLOYEE (
  EMP_NUM INT PRIMARY KEY,
  EMP_TITLE VARCHAR(5),
  EMP_LNAME VARCHAR(25) NOT NULL,
  EMP_FNAME VARCHAR(25) NOT NULL,
  EMP_INITIAL CHAR(1) NOT NULL,
  EMP_DOB DATE,
  EMP_HIRE_DATE DATE,
  EMP_AREACODE CHAR(3) DEFAULT '001',
  EMP_PHONE CHAR(8),
  EMP_MGR INT
);

-- 2. Rename column EMP_MGR to EMP_MGR_NUM
ALTER TABLE EMPLOYEE RENAME COLUMN EMP_MGR TO EMP_MGR_NUM;

-- 3. Add foreign key constraint (self-reference)
ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_mgr
FOREIGN KEY (EMP_MGR_NUM)
REFERENCES EMPLOYEE(EMP_NUM);

-- 4. Insert records into EMPLOYEE table
INSERT INTO EMPLOYEE VALUES (100, 'Mr.', 'Kolmycz', 'George', 'G', '1970-01-01', '2000-01-01', '001', '11110000', NULL);
INSERT INTO EMPLOYEE VALUES (101, 'Mr.', 'Hamilton', 'James', 'J', '1980-01-01', '2005-05-10', '001', '11110001', 100);
INSERT INTO EMPLOYEE VALUES (102, 'Ms.', 'Simmonds', 'Sarah', 'S', '1985-03-15', '2010-07-23', '001', '11110002', 100);
INSERT INTO EMPLOYEE VALUES (103, 'Mr.', 'Bailey', 'Tim', 'T', '1990-02-20', '2012-11-30', '001', '11110003', 101);
INSERT INTO EMPLOYEE VALUES (104, 'Ms.', 'Garcia', 'Maria', 'M', '1988-06-22', '2015-04-15', '001', '11110004', 102);
INSERT INTO EMPLOYEE VALUES (105, 'Mrs.', 'Lopez', 'Anna', 'A', '1987-10-11', '2014-08-01', '001', '11110005', 102);
INSERT INTO EMPLOYEE VALUES (106, 'Mr.', 'Wong', 'David', 'D', '1992-09-01', '2017-03-19', '001', '11110006', 101);
INSERT INTO EMPLOYEE VALUES (107, 'Ms.', 'Lee', 'Angela', 'A', '1991-12-12', '2018-09-09', '001', '11110007', 103);
INSERT INTO EMPLOYEE VALUES (108, 'Mr.', 'Wiesenbach', 'Paul', 'P', '1975-05-05', '1999-12-31', '001', '11110008', NULL);

-- 5. Update: Set manager of Paul Wiesenbach to George Kolmycz
UPDATE EMPLOYEE
SET EMP_MGR_NUM = 100
WHERE EMP_NUM = 108;

-- 6. Delete employees managed by Paul Wiesenbach (EMP_NUM = 108)
DELETE FROM EMPLOYEE
WHERE EMP_MGR_NUM = 108;



-- ---------------------------------------------
-- Airbnb-Inspired Mini Project: SQL Implementation
-- ---------------------------------------------

-- 1. Create tables

CREATE TABLE Host (
    HostID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Property (
    PropertyID INT PRIMARY KEY,
    HostID INT,
    Title VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50),
    PricePerNight DECIMAL(10,2),
    FOREIGN KEY (HostID) REFERENCES Host(HostID)
);

CREATE TABLE Guest (
    GuestID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    GuestID INT,
    PropertyID INT,
    CheckInDate DATE,
    CheckOutDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

-- 2. Insert sample data

-- Hosts
INSERT INTO Host VALUES (1, 'Alice', 'Brown', 'alice@example.com');
INSERT INTO Host VALUES (2, 'Bob', 'Smith', 'bob@example.com');
INSERT INTO Host VALUES (3, 'Charlie', 'Johnson', 'charlie@example.com');
INSERT INTO Host VALUES (4, 'Diana', 'Clark', 'diana@example.com');
INSERT INTO Host VALUES (5, 'Edward', 'Davis', 'edward@example.com');

-- Properties
INSERT INTO Property VALUES (101, 1, 'Cozy Loft', 'Melbourne', 'Australia', 120.00);
INSERT INTO Property VALUES (102, 2, 'Beachside Bungalow', 'Sydney', 'Australia', 180.00);
INSERT INTO Property VALUES (103, 3, 'Downtown Apartment', 'Brisbane', 'Australia', 100.00);
INSERT INTO Property VALUES (104, 4, 'Mountain Cabin', 'Hobart', 'Australia', 150.00);
INSERT INTO Property VALUES (105, 5, 'City Studio', 'Perth', 'Australia', 90.00);

-- Guests
INSERT INTO Guest VALUES (201, 'Eve', 'Miller', 'eve@example.com');
INSERT INTO Guest VALUES (202, 'Frank', 'Wilson', 'frank@example.com');
INSERT INTO Guest VALUES (203, 'Grace', 'Taylor', 'grace@example.com');
INSERT INTO Guest VALUES (204, 'Hannah', 'Moore', 'hannah@example.com');
INSERT INTO Guest VALUES (205, 'Ian', 'Anderson', 'ian@example.com');

-- Bookings
INSERT INTO Booking VALUES (301, 201, 101, '2025-03-01', '2025-03-05', 480.00);
INSERT INTO Booking VALUES (302, 202, 102, '2025-03-10', '2025-03-15', 900.00);
INSERT INTO Booking VALUES (303, 203, 103, '2025-03-12', '2025-03-14', 200.00);
INSERT INTO Booking VALUES (304, 204, 104, '2025-04-01', '2025-04-04', 450.00);
INSERT INTO Booking VALUES (305, 205, 105, '2025-04-05', '2025-04-07', 180.00);

-- 3. Add new column with default value
ALTER TABLE Guest ADD COLUMN IsVerified BOOLEAN DEFAULT FALSE;

-- 4. Update IsVerified to TRUE for guests with GuestID <= 202
UPDATE Guest SET IsVerified = TRUE WHERE GuestID <= 202;

-- 5a. SELECT with INNER JOIN and ORDER BY
SELECT B.BookingID, G.FirstName, G.LastName, P.Title, B.CheckInDate
FROM Booking B
INNER JOIN Guest G ON B.GuestID = G.GuestID
INNER JOIN Property P ON B.PropertyID = P.PropertyID
ORDER BY B.CheckInDate ASC;

-- 5b. SELECT with WHERE and IN
SELECT * FROM Property
WHERE City IN ('Melbourne', 'Sydney');

-- 5c. SELECT using DATE function
SELECT GuestID, DATEDIFF(CheckOutDate, CheckInDate) AS StayDuration
FROM Booking;

-- 5d. CREATE VIEW with JOIN
CREATE VIEW BookingSummary AS
SELECT 
    B.BookingID, 
    G.FirstName AS GuestFirstName,
    G.LastName AS GuestLastName,
    P.Title AS PropertyTitle,
    B.TotalAmount
FROM Booking B
JOIN Guest G ON B.GuestID = G.GuestID
JOIN Property P ON B.PropertyID = P.PropertyID;

-- Display the VIEW
SELECT * FROM BookingSummary;
