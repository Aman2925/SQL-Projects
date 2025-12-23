-- SQL Library Management Advance Queries

USE Library_Mngmt_System;

SELECT * FROM Library_Mngmt_System.members;
SELECT * FROM Library_Mngmt_System.branch;
SELECT * FROM Library_Mngmt_System.employees;
SELECT * FROM Library_Mngmt_System.Books;
SELECT * FROM Library_Mngmt_System.issued_status;
SELECT * FROM Library_Mngmt_System.return_status;


/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 15-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/


SELECT 
	ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
        GREATEST(
        DATEDIFF(
            COALESCE(rs.return_date, CURRENT_DATE()),
            ist.issued_date + INTERVAL 15 DAY
        ),
        0
    ) AS days_overdues
FROM Library_Mngmt_System.issued_status ist
	JOIN Library_Mngmt_System.members m 
ON ist.issued_member_id = m.member_id
	JOIN Library_Mngmt_System.Books bk
ON ist.issued_book_isbn = bk.isbn
	LEFT JOIN Library_Mngmt_System.return_status rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_date IS NULL
	  AND 
      (GREATEST(
        DATEDIFF(
            COALESCE(rs.return_date, CURRENT_DATE()),
            ist.issued_date + INTERVAL 15 DAY
        ),
        0
    ) ) > 15 
ORDER BY ist.issued_member_id;


-- 
/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/


-- Manually 

SELECT * FROM  Library_Mngmt_System.issued_status
WHERE issued_book_isbn = '978-0-451-52994-2';

SELECT * FROM Library_Mngmt_System.Books
WHERE isbn = '978-0-451-52994-2';

UPDATE Library_Mngmt_System.Books
SET Status = 'No'
WHERE isbn = '978-0-451-52994-2';

SELECT * FROM Library_Mngmt_System.return_status
WHERE issued_id = 'IS130';

INSERT INTO Library_Mngmt_System.return_status
(return_id,issued_id,return_date,book_quality)
VALUES
('RS125','IS130',CURRENT_DATE(),'Good');
	
    
SELECT * FROM Library_Mngmt_System.return_status
WHERE issued_id = 'IS130';

UPDATE Library_Mngmt_System.Books
SET Status = 'Yes'
WHERE isbn = '978-0-451-52994-2';


-- Stored Procedure

DROP PROCEDURE IF EXISTS add_return_records;
DELIMITER $$

CREATE PROCEDURE add_return_records (
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    -- Variable declarations MUST be inside BEGIN...END and at the top
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- Insert into return_status
    INSERT INTO return_status (
        return_id,
        issued_id,
        return_date,
        book_quality
    )
    VALUES (
        p_return_id,
        p_issued_id,
        CURRENT_DATE(),
        p_book_quality
    );

    -- Fetch book details
    SELECT 
        issued_book_isbn,
        issued_book_name
    INTO 
        v_isbn,
        v_book_name
    FROM Library_Mngmt_System.issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status
    UPDATE Library_Mngmt_System.books
    SET status = 'Yes'
    WHERE isbn = v_isbn;

    -- Message to user
    SELECT 
        'Thank you for returning the book' AS message,
        v_book_name AS book_name;

END$$

DELIMITER ;




SHOW PROCEDURE STATUS
WHERE Db = 'Library_Mngmt_System';


-- Calling Functions

-- CALL add_return_records()
    



SELECT * FROM Library_Mngmt_System.issued_status
WHERE issued_id = IS135;

SELECT * FROM Library_Mngmt_System.Books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM Library_Mngmt_System.Books
WHERE status = 'no';



CALL add_return_records ('RS138','IS135','Good');

-- 
/*  
 Task 15: Branch Performance Report
 Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

*/

CREATE TABLE branch_reports
AS 
SELECT 
	b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS Number_books_issued,
    COUNT(rs.return_id) AS Number_books_returned,
    SUM(bk.rental_price) AS total_revenue
	FROM Library_Mngmt_System.issued_status AS ist
JOIN 
	Library_Mngmt_System.employees AS e
ON 
	e.emp_id = ist.issued_emp_id
JOIN 
	Library_Mngmt_System.branch as b
ON 
	e.branch_id = b.branch_id
JOIN 
	Library_Mngmt_System.Books as bk
ON
	ist.issued_book_isbn = bk.isbn
LEFT JOIN
	Library_Mngmt_System.return_status as rs
ON 	
	rs.issued_id = ist.issued_id
GROUP BY b.branch_id , b.manager_id;

SELECT * FROM branch_reports;

-- 
/*  

Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
	
*/

CREATE TABLE active_members
AS
SELECT * FROM 
Library_Mngmt_System.members
WHERE member_id IN (
				SELECT DISTINCT(issued_member_id) 
					   FROM Library_Mngmt_System.issued_status
				WHERE 
					   issued_date >= DATE('2025-12-31') - INTERVAL 2 MONTH
					);


SELECT * FROM active_members;

-- 
/* 

Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

*/

SELECT 
	e.emp_name,
    b.branch_id,
    b.branch_address,
    emp_cnt.TotalCount
FROM (
		SELECT
			issued_emp_id,
			COUNT(*) AS TotalCount
		FROM Library_Mngmt_System.issued_status
        GROUP BY issued_emp_id
	 ) emp_cnt
JOIN 
	Library_Mngmt_System.employees e
ON 
	e.emp_id = emp_cnt.issued_emp_id
JOIN 
	Library_Mngmt_System.branch b
ON
	e.branch_id = b.branch_id;
    
/*
Task 19: Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 

If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

*/

SELECT * FROM Library_Mngmt_System.Books;

SELECT * FROM Library_Mngmt_System.issued_status;


-- Stored Procedure

-- Change the default delimiter so MySQL
-- does not end the procedure at the first semicolon

DELIMITER $$

-- Create a stored procedure to issue a book
DROP PROCEDURE IF EXISTS issue_book;

CREATE PROCEDURE issue_book (
	IN p_issued_id VARCHAR(10),
    IN p_issued_member_id VARCHAR(30),   -- Member who is issuing the book
    IN p_issued_book_isbn VARCHAR(30),    -- ISBN of the book
    IN p_issued_emp_id VARCHAR(10)        -- Employee issuing the book
)
BEGIN
    -- Step 1: Declare a local variable to store book availability status
    DECLARE v_status VARCHAR(10);

    -- Step 2: Fetch the current status of the book from books table
    -- 'yes'  → book is available
    -- 'no'   → book is already issued
    SELECT status
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    -- Step 3: Check if the book is available
    IF v_status = 'yes' THEN

        -- Step 4: Insert a new record into issued_status table
        -- issued_id is provided manually as a primary key

        -- CURDATE() captures today's date
        INSERT INTO issued_status
        (issued_id,issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id,p_issued_member_id, CURDATE(), p_issued_book_isbn, p_issued_emp_id);

        -- Step 5: Update the book status to 'no' (unavailable)
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

		

    ELSE
        -- Step 6: If the book is not available, show an informative message
        SELECT 'Sorry, the requested book is currently unavailable.' AS Message;
    END IF;

-- End of procedure logic
END$$

-- Restore the default statement delimiter
DELIMITER ;


SELECT * FROM Library_Mngmt_System.Books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM Library_Mngmt_System.issued_status;


SELECT * FROM Library_Mngmt_System.issued_status
WHERE issued_book_isbn = '978-0-553-29698-2';

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');

CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM Library_Mngmt_System.Books
WHERE isbn = '978-0-553-29698-2';




