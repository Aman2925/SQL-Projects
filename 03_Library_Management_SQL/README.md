# 📚 Library Management System – SQL Project

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `Library_Mngmt_System_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library Management Project](library.png)


## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.


### 1. Database Setup

![Library ER Diagram](ER-Model.png)



- **Database Creation**: Created a database named `Library_Mngmt_System_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.


```sql
-- Creating Database

DROP DATABASE IF EXISTS Library_Mngmt_System;

Create Database Library_Mngmt_System;

USE Library_Mngmt_System;


-- Creating Branch Table

TRUNCATE TABLE Branch;

DROP TABLE IF EXISTS Branch;
CREATE TABLE Branch(
		branch_id VARCHAR(10) Primary Key,
        manager_id VARCHAR(10),
        branch_address VARCHAR(55),
        contact_no VARCHAR(10)
);

ALTER TABLE Branch
MODIFY COLUMN contact_no VARCHAR(15);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
		emp_id VARCHAR(10) PRIMARY KEY,
        emp_name VARCHAR(25),
        position VARCHAR(15),
        salary INT,
        branch_id VARCHAR (25)
);


DROP TABLE IF EXISTS books;
CREATE TABLE books(
		isbn VARCHAR(20) PRIMARY KEY,
        book_title VARCHAR(75),
        category VARCHAR(10),
        rental_price FLOAT,
        status VARCHAR(15),
        author VARCHAR(35),
        publisher VARCHAR(55)
);

ALTER TABLE books
MODIFY COLUMN category VARCHAR(35);


DROP TABLE IF EXISTS members;
CREATE TABLE members(
	   member_id VARCHAR(10) PRIMARY KEY,
       member_name VARCHAR(25),
       member_address VARCHAR(75),
       reg_date DATE
);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
	issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR (10), -- FK
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_isbn VARCHAR(25),  -- FK
    issued_emp_id VARCHAR(10)      -- FK
);

DROP TABLE return_status;
CREATE TABLE return_status
(
		return_id VARCHAR(10) PRIMARY KEY,
        issued_id VARCHAR(10),
        return_book_name VARCHAR(75),
        return_date DATE,
        return_book_isbn VARCHAR(20)
);


-- Foreign Key

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);


ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);


ALTER TABLE issued_status
ADD CONSTRAINT fk_emp
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

```


- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.


**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO Library_Mngmt_System.Books
(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
(
	'978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
);
SELECT * FROM Library_Mngmt_System.books;
```

**Task 2: Update an Existing Member's Address**

```sql

UPDATE Library_Mngmt_System.members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

SELECT * FROM Library_Mngmt_System.members;
```


**Task 3: Delete a Record from the Issued Status Table**

-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql

SELECT * FROM Library_Mngmt_System.issued_status
WHERE issued_id = 'IS121';

DELETE FROM Library_Mngmt_System.issued_status
WHERE issued_id = 'IS121';

SELECT * FROM Library_Mngmt_System.issued_status;

```

**Task 4: Retrieve All Books Issued by a Specific Employee**

-- Objective: Select all books issued by the employee with emp_id = 'E101'.

```sql
SELECT * FROM Library_Mngmt_System.issued_status
WHERE issued_emp_id = 'E101';

```

**Task 5: List Members Who Have Issued More Than One Book**

-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql

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
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql

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

```

### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql

SELECT
	Category,
    COUNT(*) AS Total_Count
FROM Library_Mngmt_System.Books
	GROUP BY Category
    ORDER BY Total_Count;

```

8. **Task 8: Find Total Rental Income by Category**:

```sql

SELECT
	Category,
    SUM(rental_price) as TOTAL_RENTAL_INCOME
FROM Library_Mngmt_System.Books
	GROUP BY CATEGORY
    ORDER BY TOTAL_RENTAL_INCOME;

```

9. **List Members Who Registered in the Last 180 Days**:

```sql
SELECT * FROM Library_Mngmt_System.members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;

```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql

SELECT
	e1.*,
    b.manager_id,
    e2.emp_name as Manager 
FROM Library_Mngmt_System.employees e1
JOIN Library_Mngmt_System.branch b
ON b.branch_id = e1.branch_id
JOIN Library_Mngmt_System.employees as e2
ON b.manager_id = e2.emp_id;

```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:

```sql
CREATE TABLE books_price_greater_than_seven
AS 
SELECT * FROM Library_Mngmt_System.Books
WHERE rental_price > 7.0;

SELECT * FROM books_price_greater_than_seven;

```

Task 12: **Retrieve the List of Books Not Yet Returned**

```sql

SELECT * FROM Library_Mngmt_System.issued_status as ist
LEFT JOIN
Library_Mngmt_System.return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
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





```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

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



```

**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql

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

```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql
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

```

**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
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


```

**Task 18: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql
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

```


## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## How to Use

1. Clone the Repository: Clone this repository to your local machine.

```bash
git clone https://github.com/HeyChamp29/SQL-Projects.git
```

2.Navigate to the Library Management project:

```bash
cd SQL-Projects/03_Library_Management_SQL

```

3.Set up the database:
Run database_setup.sql to create the database and tables.

4.Load data:
Import CSV files from the data/ folder using LOAD DATA INFILE or your preferred method.

5.Run analysis:
Execute queries from library_queries.sql to explore and analyze the data.

