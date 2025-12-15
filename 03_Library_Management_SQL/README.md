# 📚 Library Management System – SQL Project

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `Library_Mngmt_System_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.


## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.


### 1. Database Setup



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
