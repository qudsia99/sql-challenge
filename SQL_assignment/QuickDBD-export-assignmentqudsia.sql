-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

--Creating all tables matching the CSV files, in order of Primary Key holders to Foreign Key holders 
--to minimize importing issues
--Important information to remember about Primary keys: These values must NOT repeat in the rows

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

-- Note: dept_emp.csv will be a Junction table
-- Despite 'emp_no' fitting the criteria of a primary key, it will not be one because of it holding the position of 
-- a junction table 

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--SECTION 2 DATA ANALYSIS

-- For quicker acccess to tables and double check columns, listing all columns from tables below
SELECT * FROM departments
SELECT * FROM dept_emp
SELECT * FROM dept_manager
SELECT * FROM employees
SELECT * FROM salaries
SELECT * FROM titles

--Listing the employee number, last name, first name, sex, and salary of each employee.

SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no

--Listing the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name,last_name,hire_date
FROM employees 
WHERE hire_date LIKE '%1986'


--Listing the manager of each department along with their department number, department name, 
--employee number, last name, and first name.
SELECT m.emp_no,m.dept_no,d.dept_name,e.last_name,e.first_name
FROM dept_manager m
LEFT OUTER JOIN departments d
ON m.dept_no = d.dept_no
	LEFT OUTER JOIN employees e
	ON m.emp_no = e.emp_no

--Listing the department number for each employee along with that employee’s employee number,
--last name, first name, and department name.
SELECT e.emp_no,e.last_name, e.first_name,de.dept_no,d.dept_name
FROM employees e
LEFT OUTER JOIN dept_emp de
ON e.emp_no = de.emp_no
	LEFT OUTER JOIN departments d
		ON d.dept_no = de.dept_no
		
--Listing first name, last name, and sex of each employee whose first name is Hercules 
--and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'

--Listing each employee in the Sales department, including their employee number, last name, and first name.
SELECT e.emp_no, e.last_name, e.first_name,de.dept_no, d.dept_name
FROM employees e
LEFT OUTER JOIN dept_emp de
ON e.emp_no = de.emp_no
	LEFT OUTER JOIN departments d
	ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales'

--Listing each employee in the Sales and Development departments, including their employee number, 
--last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name,de.dept_no, d.dept_name
FROM employees e
LEFT OUTER JOIN dept_emp de
ON e.emp_no = de.emp_no
	LEFT OUTER JOIN departments d
	ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales' OR dept_name = 'Development'

--Listing the frequency counts, in descending order, of all the employee last names 
--(that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "last name count"
FROM employees
GROUP BY last_name
ORDER BY "last name count" DESC
