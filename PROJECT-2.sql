/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.*/
Select EMP_ID, FIRST_NAME, LAST_NAME, GENDER,DEPT from emp_record_table;

/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: */
/*1.less than two*/

Select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table  WHERE EMP_RATING < 2 ;
/*4.greater than four*/

Select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table  WHERE EMP_RATING > 4 ;

 

/*3.between two and four*/
Select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table  WHERE EMP_RATING BETWEEN 2 AND 4 ;

/*Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.*/
select * from emp_record_table as emp;
select CONCAT(FIRST_NAME, ''  ,LAST_NAME) as NAME from emp_record_table where DEPT = "FINANCE";

/*Write a query to list only those employees who have someone reporting to them. .*/

Select * from emp_record_table where  ROLE = "MANAGER";

/*Also, show the number of reporters (including the President)*/

SELECT *,
       (SELECT COUNT(EMP_ID) FROM emp_record_table WHERE ROLE != 'MANAGER') as non_reporters FROM emp_record_table
       WHERE ROLE != 'MANAGER';

/*Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.*/

Select * from emp_record_table where DEPT = 'HEALTHCARE'
UNION
Select * from emp_record_table where DEPT = 'FINANCE';

/* Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.*/
select* from emp_record_table;
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT,EMP_RATING,MAX(EMP_RATING) AS MAX_RATING from emp_record_table group by DEPT  ;


/* Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.*/

select ROLE,MIN(SALARY) AS MINIMUM_SALARY , MAX(SALARY) AS MAXIMUM_SALARY from emp_record_table group by ROLE;

/*Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.*/

Select   dense_rank() OVER( order by EXP DESC )as EMP_RANK,EMP_ID,FIRST_NAME,LAST_NAME,EXP,DEPT FROM emp_record_table ;

/*Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.*/

create view  high_salary_employee as select * from emp_record_table where SALARY> 6000  group by COUNTRY;
select * from high_salary_employee;

/*Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.*/

select * from emp_record_table where EXP>10;

/*Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.*/

DELIMITER //
create procedure employee_exp() 
BEGIN
      select * from emp_record_table where EXP > 3 ;
END //
DELIMITER ;
CALL employee_exp();

/*Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.*/
-- Create a stored function to get the job profile based on experience
DELIMITER //

CREATE FUNCTION GetJobProfile(EXP INT)
RETURNS VARCHAR(50) deterministic
BEGIN
    DECLARE ROLE VARCHAR(50);

    IF EXP <= 2 THEN
        SET ROLE = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXP <= 5 THEN
        SET ROLE = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXP <= 10 THEN
        SET ROLE = 'SENIOR DATA SCIENTIST';
    ELSEIF EXP <= 12 THEN
        SET ROLE = 'LEAD DATA SCIENTIST';
    ELSEIF EXP <= 16 THEN
        SET ROLE = 'MANAGER';
    ELSE
        SET ROLE = 'UNKNOWN';
    END IF;

    RETURN ROLE;
END //

DELIMITER ;

select * from data_science_team;

SELECT
    EMP_ID,
    EXP,
    GetJobProfile(EXP) AS assigned_job_profile,
    CASE
        WHEN GetJobProfile(EXP) IN ('JUNIOR DATA SCIENTIST', 'ASSOCIATE DATA SCIENTIST', 'SENIOR DATA SCIENTIST', 'LEAD DATA SCIENTIST', 'MANAGER') THEN 'Match'
        ELSE 'Mismatch'
    END AS match_status
FROM
    data_science_team;

-- Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
select * from emp_record_table;

-- Create a non-clustered index on the FIRST_NAME column
CREATE INDEX idx_first_name ON emp_record_table (FIRST_NAME(255) );
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

-- Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

select EMP_RATING,SALARY ,(EMP_RATING/100)*SALARY AS Bonus from emp_record_table;

-- Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

select e.* ,
avg(salary) over(partition by CONTINENT,COUNTRY) as Average_Salary

from emp_record_table e;








