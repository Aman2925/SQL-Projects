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

