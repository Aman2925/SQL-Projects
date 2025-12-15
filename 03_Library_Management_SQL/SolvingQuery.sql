USE Library_Mngmt_System;

SELECT * FROM Library_Mngmt_System.members;
SELECT * FROM Library_Mngmt_System.branch;
SELECT * FROM Library_Mngmt_System.employees;
SELECT * FROM Library_Mngmt_System.Books;
SELECT * FROM Library_Mngmt_System.issued_status;
SELECT * FROM Library_Mngmt_System.return_status;

-- CRUD Operation

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO Library_Mngmt_System.books
(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & Co.');

SELECT * FROM Library_Mngmt_System.books;


-- Task 2: Update an Existing Member's Address

UPDATE Library_Mngmt_System.members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

SELECT * FROM Library_Mngmt_System.members;


-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM Library_Mngmt_System.issued_status
WHERE issued_id = 'IS121';

DELETE FROM Library_Mngmt_System.issued_status
WHERE issued_id = 'IS121';

SELECT * FROM Library_Mngmt_System.issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM Library_Mngmt_System.issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
    i.issued_member_id,
    m.member_name
FROM Library_Mngmt_System.issued_status i
JOIN Library_Mngmt_System.members m
    ON i.issued_member_id = m.member_id
GROUP BY 
    i.issued_member_id,
    m.member_name
HAVING 
    COUNT(i.issued_id) > 1
ORDER BY 
    i.issued_member_id;


-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS
	SELECT
		b.isbn,
		b.book_title,
        COUNT(*) as Total_Count
	FROM Library_Mngmt_System.Books b
    JOIN Library_Mngmt_System.issued_status i
    ON b.isbn = i.issued_book_isbn
    GROUP BY b.isbn
    ORDER BY Total_Count;
    
    
SELECT *
	FROM book_cnts;

-- Task 7. Retrieve All Books in a Specific Category:

SELECT
	Category,
    COUNT(*) AS Total_Count
FROM Library_Mngmt_System.Books
	GROUP BY Category
    ORDER BY Total_Count;

        
-- Task 8: Find Total Rental Income by Category:

SELECT
	Category,
    SUM(rental_price) as TOTAL_RENTAL_INCOME
FROM Library_Mngmt_System.Books
	GROUP BY CATEGORY
    ORDER BY TOTAL_RENTAL_INCOME;
		
SELECT * FROM Library_Mngmt_System.Books
WHERE CATEGORY = 'Literary Fiction';
		
		
-- List Members Who Registered in the Last 180 Days:

SELECT * FROM Library_Mngmt_System.members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;


UPDATE Library_Mngmt_System.members
SET reg_date = '2025-10-01'
WHERE member_id = 'C101';

UPDATE Library_Mngmt_System.members
SET reg_date = '2025-12-01'
WHERE member_id = 'C102';


-- Task 10 List Employees with Their Branch Manager's Name and their branch details:

SELECT
	e1.*,
    b.manager_id,
    e2.emp_name as Manager 
FROM Library_Mngmt_System.employees e1
JOIN Library_Mngmt_System.branch b
ON b.branch_id = e1.branch_id
JOIN Library_Mngmt_System.employees as e2
ON b.manager_id = e2.emp_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE books_price_greater_than_seven
AS 
SELECT * FROM Library_Mngmt_System.Books
WHERE rental_price > 7.0;

SELECT * FROM books_price_greater_than_seven;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
	DISTINCT(ist.issued_book_name)
FROM Library_Mngmt_System.issued_status AS ist
LEFT JOIN Library_Mngmt_System.return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;


    
	
	


