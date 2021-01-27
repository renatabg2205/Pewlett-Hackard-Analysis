/*
  Deliverable 1: The Number of Retiring Employees by Title
	Create a Retirement Titles table that holds all the titles of current employees 
	who were born between January 1, 1952 and December 31, 1955. 
	Because some employees may have multiple titles in the database—for example, 
	due to promotions—you’ll need to use the DISTINCT ON statement to create a 
	table that contains the most recent title of each employee. 
	Then, use the COUNT() function to create a final table that
	has the number of retirement-age employees by most recent job title.
*/
/*
  1. Retrieve the emp_no, first_name, and last_name columns from the Employees table.
  2. Retrieve the title, from_date, and to_date columns from the Titles table.
  3. Create a new table using the INTO clause.
  4. Join both tables on the primary key.
  5. Filter the data on the birth_date column to retrieve the employees 
who were born between 1952 and 1955. Then, order by the employee number.
*/
SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	t.title, 
	t.from_date, 
	t.to_date
INTO retirement_titles
FROM employees as e
LEFT JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

/*
  9. Retrieve the employee number, first and last name, and title columns from 
  the Retirement Titles table
  10. Use the DISTINCT ON statement to retrieve the first occurrence of the 
  employee number for each set of rows defined by the ON () clause
  11. Create a Unique Titles table using the INTO clause
  12. Sort the Unique Titles table in ascending order by the employee number and 
  descending order by the last date (i.e. to_date) of the most recent title.
*/
--Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

/*
  15. Write another query to retrieve the number of employees by 
  their most recent job title who are about to retire.
  16. First, retrieve the number of titles from the Unique Titles table.
  17. Then, create a Retiring Titles table to hold the required information.
  18. Group the table by title, then sort the count column in descending order.
*/
SELECT COUNT(ut.title), 
	ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;

/*
  Deliverable 2: The Employees Eligible for the Mentorship Program
	Create a mentorship-eligibility table that holds the current employees who 
	were born between January 1, 1965 and December 31, 1965.
*/
/*
  1. Retrieve the emp_no, first_name, last_name, and birth_date columns from 
  the Employees table.
  2. Retrieve the from_date and to_date columns from the Department Employee table.
  3. Retrieve the title column from the Titles table.
  4. Use a DISTINCT ON statement to retrieve the first occurrence of 
  the employee number for each set of rows defined by the ON () clause.
  5. Create a new table using the INTO clause.
  6. Join the Employees and the Department Employee tables on the primary key.
  7. Join the Employees and the Titles tables on the primary key.
  8. Filter the data on the to_date column to get current employees whose 
  birth dates are between January 1, 1965 and December 31, 1965.
*/

SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (t.to_date = '9999-01-01') AND
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Count mentorship eligibility grouping by title
SELECT COUNT(me.title), 
	me.title
INTO mentorship_titles
FROM mentorship_eligibility as me
GROUP BY me.title
ORDER BY COUNT(me.title) DESC;

-- Create table to retrieve dept_name for eligible to retire
SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	d.dept_name
INTO retirement_depts
FROM employees as e
LEFT JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
LEFT JOIN departments as d
ON (d.dept_no = de.dept_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

--Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rd.emp_no) rd.emp_no,
	rd.first_name,
	rd.last_name,
	rd.dept_name
INTO unique_depts
FROM retirement_depts as rd
ORDER BY rd.emp_no;

-- Count retirement eligibility grouping by department
SELECT COUNT(ud.dept_name), 
	ud.dept_name
INTO retiring_depts
FROM unique_depts as ud
GROUP BY ud.dept_name
ORDER BY COUNT(ud.dept_name) DESC;

-- Create table for mentorship eligibility with Department
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title,
	d.dept_name
INTO mentor_eligib_dept
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (t.to_date = '9999-01-01') AND
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Count mentorship eligibility grouping by department
SELECT COUNT(med.dept_name), 
	med.dept_name
INTO mentorship_depts
FROM mentor_eligib_dept as med
GROUP BY med.dept_name
ORDER BY COUNT(med.dept_name) DESC;