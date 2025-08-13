CREATE DATABASE employee;
USE employee;
SHOW TABLES;
/* 3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
and make a list of employees and details of their department. */

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table;

/* 4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four 
●	between two and four
 */
 
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
 FROM emp_record_table
 WHERE
 EMP_RATING < 2
 OR EMP_RATING > 4
 OR (EMP_RATING BETWEEN 2 AND 4); 
 
 /* 5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department 
 from the employee table and then give the resultant column alias as NAME. */
 
 SELECT concat(FIRST_NAME, ' ', LAST_NAME) AS NAME
 FROM emp_record_table
 WHERE DEPT = 'Finance';
 
 /* 6.	Write a query to list only those employees who have someone reporting to them. 
 Also, show the number of reporters (including the President). */
 
 SELECT 
    m.EMP_ID AS Manager_ID,
    m.FIRST_NAME AS Manager_First_Name,
    m.LAST_NAME AS Manager_Last_Name,
    m.ROLE AS Manager_Role,
    COUNT(r.EMP_ID) AS Number_of_Reporters
FROM 
    emp_record_table m
LEFT JOIN 
    emp_record_table r ON m.EMP_ID = r.MANAGER_ID
GROUP BY 
    m.EMP_ID, m.FIRST_NAME, m.LAST_NAME, m.ROLE
HAVING 
    COUNT(r.EMP_ID) > 0
ORDER BY 
    Number_of_Reporters DESC;
 
 /* 7.	Write a query to list down all the employees from the healthcare and finance departments
 using union. Take data from the employee record table. */
 
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT FROM emp_record_table
 WHERE DEPT = "HEALTHCARE"
 UNION
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT FROM emp_record_table
 WHERE DEPT = "FINANCE"
 ORDER BY DEPT, EMP_ID;
 
 /* 8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, 
 ROLE, DEPARTMENT, and EMP_RATING grouped by dept.
 Also include the respective employee rating along with the max emp rating for the department. */
 
 SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    e.DEPT,
    e.EMP_RATING,
    MAX(e.EMP_RATING) OVER (PARTITION BY e.DEPT) AS MAX_DEPT_RATING
FROM 
    emp_record_table e
ORDER BY 
    e.DEPT, 
    e.EMP_RATING DESC;
 
 /* 9.	Write a query to calculate the minimum and the maximum salary 
 of the employees in each role. Take data from the employee record table. */
 
 SELECT ROLE, 
 MIN(SALARY) AS Min_Salary,
 MAX(SALARY) AS Max_Salary 
 FROM emp_record_table
 GROUP BY ROLE;
 
 /*10.	Write a query to assign ranks to each employee based on their experience. 
 Take data from the employee record table*/
 
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP,
 RANK() OVER (ORDER BY EXP DESC) AS EXP_RANK
 FROM 
 emp_record_table;
 
 USE employee;
 SHOW TABLES;
 
 /* 11.	Write a query to create a view that displays employees in various countries
 whose salary is more than six thousand. Take data from the employee record table */
 
 CREATE VIEW empsal AS
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY FROM emp_record_table; 
 
SHOW FULL TABLES WHERE table_type = 'view';
SELECT * FROM empsal
 WHERE SALARY > 6000;
 
 /*12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.*/
 
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP FROM emp_record_table
 WHERE EXP > (SELECT 10);
 
 /*13.	Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. 
 Take data from the employee record table.*/
  
 DELIMITER //
 CREATE PROCEDURE expemployees()
 BEGIN
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
 FROM emp_record_table
 WHERE EXP > 3;
 END //
 
CALL expemployees();

/* 14.	Write a query using stored functions in the project table to check whether the job profile 
assigned to each employee in the data science team matches the organization’s set standard.

The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'. */

DELIMITER //
CREATE FUNCTION job_profile(EXP INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
DECLARE job_profile VARCHAR(50);
IF EXP > 12 AND 16 THEN
SET job_profile = "MANAGER";
ELSEIF EXP > 10 AND 12 THEN
SET job_profile = "LEAD DATA SCIENTIST";
ELSEIF EXP > 5 AND 10 THEN
SET job_profile = "SENIOR DATA SCIENTIST";
ELSEIF EXP > 2 AND 5 THEN
SET job_profile = "ASSOCIATE DATA SCIENTIST";
ELSEIF EXP <= 2 THEN
SET job_profile = "JUNIOR DATA SCIENTIST";
END IF;
RETURN (job_profile);
END // 

/*15.	Create an index to improve the cost and performance of the query to find the employee 
whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.*/

EXPLAIN SELECT * FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

CREATE INDEX idx_employee_first_name ON emp_record_table(FIRST_NAME(50));
 
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

/*16.	Write a query to calculate the bonus for all the employees, 
based on their ratings and salaries (Use the formula: 5% of salary * employee rating */

ALTER TABLE emp_record_table ADD COLUMN bonus DECIMAL(10, 2);
UPDATE emp_record_table 
SET bonus = 0.05 * SALARY * EMP_RATING;

SET sql_safe_updates = 0;

SELECT * FROM emp_record_table;

/*17.	Write a query to calculate the average salary 
distribution based on the continent and country. Take data from the employee record table.*/

SELECT FIRST_NAME, LAST_NAME, SALARY, COUNTRY, CONTINENT,
AVG(SALARY) AS Average_salary FROM emp_record_table
GROUP BY FIRST_NAME, LAST_NAME, SALARY, COUNTRY, CONTINENT
ORDER BY FIRST_NAME, LAST_NAME, SALARY, COUNTRY, CONTINENT;
