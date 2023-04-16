#calender year,gender,no of employees

SELECT 
	emp_no, from_date,to_date
FROM
	t_dept_emp;
    
SELECT distinct
	emp_no, from_date, to_date
FROM 
	t_dept_emp;
    
    SELECT 
		YEAR(d.from_date) as calender_year,
        gender,
        count(e.emp_no) as num_of_employee
	FROM
        t_employees e
        join
        t_dept_emp d on d.emp_no=e.emp_no
	group by calender_year,e.gender
    having calender_year >= 1990;
    
  SELECT 
	d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calender_year,
    CASE
		WHEN YEAR(dm.to_date) >= e.calender_year AND YEAR (dm.from_date) <= e.calender_year THEN 1
        ELSE 0
        END AS actives
	FROM 
    (select year (hire_date) as calender_year
    FROM 
		t_employees
	group by calender_year) e
		cross join
	t_dept_manager dm
        join
	t_departments d on dm.dept_no = d.dept_no
		join
	t_employees ee on dm.emp_no = ee.emp_no
    order by dm.emp_no, calender_year;
    
    select * from 
    (select year (hire_date) as calender_year
    FROM 
		t_employees
	group by calender_year) e
		cross join
	t_dept_manager dm
        join
	t_departments d on dm.dept_no = d.dept_no
		join
	t_employees ee on dm.emp_no = ee.emp_no
    order by dm.emp_no, calender_year;
    
SELECT 
    e.gender,d.dept_name,round(avg(s.salary),2) as salary,year(s.from_date) as calender_year
FROM
t_salaries  as s 
join
t_employees as e on s.emp_no = e.emp_no
join
t_dept_emp as de on de.emp_no = e.emp_no
join 
t_departments as d on d.dept_no = de.dept_no
group by d.dept_no,e.gender,calender_year
having calender_year <=2002
order by d.dept_no;
	
    
SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calender_year
FROM
    t_salaries AS s
        JOIN
    t_employees AS e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp AS de ON de.emp_no = e.emp_no
        JOIN
    t_departments AS d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calender_year
HAVING calender_year <= 2002
ORDER BY d.dept_no;



drop procedure if exists filter_salary;

delimiter $$
create procedure filter_salary (in p_min_salary float, in p_max_salary float)
begin
select
	e.gender,d.dept_name,avg(s.salary) as avg_salary
from
	 t_salaries AS s
        JOIN
    t_employees AS e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp AS de ON de.emp_no = e.emp_no
        JOIN
    t_departments AS d ON d.dept_no = de.dept_no
    where s.salary between p_min_salary and p_max_salary
    group by d.dept_no,e.gender;
    end $$
    delimiter ;
    call filter_salary(50000,90000);
    