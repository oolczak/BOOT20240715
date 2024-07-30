-- lab_07_01
SELECT location_id, street_address, city, country_name
FROM locations NATURAL JOIN countries;

-- lab_07_02
SELECT last_name, department_id, department_name
FROM employees JOIN departments USING(department_id);

-- lab_07_03
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l USING (location_id)
WHERE LOWER(l.city) = 'toronto';

-- lab_07_04
SELECT w.last_name "Employee", w.employee_id "EMP#", 
    m.last_name "Manager", m.employee_id "Mgr#"
FROM employees w INNER JOIN employees m ON w.manager_id = m.employee_id;

-- lab_07_05
SELECT w.last_name "Employee", w.employee_id "EMP#", 
    m.last_name "Manager", m.employee_id "Mgr#"
FROM employees w LEFT JOIN employees m ON w.manager_id = m.employee_id
ORDER BY m.employee_id;

-- lab_07_06
SELECT e.department_id "Department", e.last_name "Employee", c.last_name "Colleague"
FROM employees e INNER JOIN employees c ON e.department_id = c.department_id
WHERE e.employee_id <> c.employee_id
ORDER BY 1, 2, 3;

-- lab_07_07
DESC job_grades;

SELECT e.last_name, e.job_id, e.department_id, d.department_name,
    e.salary, j.grade
FROM employees e 
    JOIN departments d ON e.department_id = d.department_id
    JOIN job_grades j ON (e.salary BETWEEN j.lowest_sal AND j.highest_sal);

-- lab_07_08
SELECT last_name, count(*) FROM employees GROUP BY last_name ORDER BY 2, 1;
SELECT * FROM employees WHERE last_name = 'Davies';
SELECT e.last_name "Employee", e.hire_date
FROM employees e INNER JOIN employees d ON d.last_name = 'Davies'
WHERE d.hire_date < e.hire_date
ORDER BY 2;
SELECT count(*) FROM employees WHERE hire_date > '29-01-2005';

-- lab_07_09
SELECT w.last_name "Employee", w.hire_date "Employee_hire_date", 
    m.last_name "Manager", m.hire_date "Manager_hire_date"
FROM employees w JOIN employees m ON w.manager_id = m.employee_id
WHERE w.hire_date < m.hire_date
ORDER BY 3, 2;
