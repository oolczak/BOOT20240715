-- alter session set "_ORACLE_SCRIPT"=true;

-- create user alumno identified by alumno;
-- GRANT CONNECT, CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO alumno;
-- GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE , UNLIMITED TABLESPACE TO alumno;
-- DROP USER alumno CASCADE;

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

-- ---------------------------------------------------------------------------------------------------------------------
-- create tables, sequences and constraint
-- ---------------------------------------------------------------------------------------------------------------------

REM ********************************************************************
REM Create the REGIONS table to hold region information for locations
REM HR.LOCATIONS table has a foreign key to this table.

Prompt ******  Creating REGIONS table ....

create table regions (
	region_id   number
		constraint region_id_nn not null,
	region_name varchar2(25)
);

	create unique index reg_id_pk on
		regions (
			region_id
		);

alter table regions add (
	constraint reg_id_pk primary key ( region_id )
);

REM ********************************************************************
REM Create the COUNTRIES table to hold country information for customers
REM and company locations. 
REM OE.CUSTOMERS table and HR.LOCATIONS have a foreign key to this table.

Prompt ******  Creating COUNTRIES table ....

create table countries (
	country_id   char(2)
		constraint country_id_nn not null,
	country_name varchar2(40),
	region_id    number,
	constraint country_c_id_pk primary key ( country_id )
)
organization index;

alter table countries add (
	constraint countr_reg_fk foreign key ( region_id )
		references regions ( region_id )
);

REM ********************************************************************
REM Create the LOCATIONS table to hold address information for company departments.
REM HR.DEPARTMENTS has a foreign key to this table.

Prompt ******  Creating LOCATIONS table ....

create table locations (
	location_id    number(4),
	street_address varchar2(40),
	postal_code    varchar2(12),
	city           varchar2(30)
		constraint loc_city_nn not null,
	state_province varchar2(25),
	country_id     char(2)
);

	create unique index loc_id_pk on
		locations (
			location_id
		);

alter table locations add (
	constraint loc_id_pk primary key ( location_id ),
	constraint loc_c_id_fk foreign key ( country_id )
		references countries ( country_id )
);

Rem 	Useful for any subsequent addition of rows to locations table
Rem 	Starts with 3300

create sequence locations_seq start with 3300 increment by 100 maxvalue 9900 nocache nocycle;

REM ********************************************************************
REM Create the DEPARTMENTS table to hold company department information.
REM HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.

Prompt ******  Creating DEPARTMENTS table ....

create table departments (
	department_id   number(4),
	department_name varchar2(30)
		constraint dept_name_nn not null,
	manager_id      number(6),
	location_id     number(4)
);

	create unique index dept_id_pk on
		departments (
			department_id
		);

alter table departments add (
	constraint dept_id_pk primary key ( department_id ),
	constraint dept_loc_fk foreign key ( location_id )
		references locations ( location_id )
);

Rem 	Useful for any subsequent addition of rows to departments table
Rem 	Starts with 280 

create sequence departments_seq start with 280 increment by 10 maxvalue 9990 nocache nocycle;

REM ********************************************************************
REM Create the JOBS table to hold the different names of job roles within the company.
REM HR.EMPLOYEES has a foreign key to this table.

Prompt ******  Creating JOBS table ....

create table jobs (
	job_id     varchar2(10),
	job_title  varchar2(35)
		constraint job_title_nn not null,
	min_salary number(6),
	max_salary number(6)
);

	create unique index job_id_pk on
		jobs (
			job_id
		);

alter table jobs add (
	constraint job_id_pk primary key ( job_id )
);

REM ********************************************************************
REM Create the EMPLOYEES table to hold the employee personnel 
REM information for the company.
REM HR.EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Creating EMPLOYEES table ....

create table employees (
	employee_id    number(6),
	first_name     varchar2(20),
	last_name      varchar2(25)
		constraint emp_last_name_nn not null,
	email          varchar2(25)
		constraint emp_email_nn not null,
	phone_number   varchar2(20),
	hire_date      date
		constraint emp_hire_date_nn not null,
	job_id         varchar2(10)
		constraint emp_job_nn not null,
	salary         number(8,2),
	commission_pct number(2,2),
	manager_id     number(6),
	department_id  number(4),
	constraint emp_salary_min check ( salary > 0 ),
	constraint emp_email_uk unique ( email )
);

	create unique index emp_emp_id_pk on
		employees (
			employee_id
		);


alter table employees add (
	constraint emp_emp_id_pk primary key ( employee_id ),
	constraint emp_dept_fk foreign key ( department_id )
		references departments,
	constraint emp_job_fk foreign key ( job_id )
		references jobs ( job_id ),
	constraint emp_manager_fk foreign key ( manager_id )
		references employees
);

alter table departments add (
	constraint dept_mgr_fk foreign key ( manager_id )
		references employees ( employee_id )
);


Rem 	Useful for any subsequent addition of rows to employees table
Rem 	Starts with 207 


create sequence employees_seq start with 207 increment by 1 nocache nocycle;

REM ********************************************************************
REM Create the JOB_HISTORY table to hold the history of jobs that 
REM employees have held in the past.
REM HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.

Prompt ******  Creating JOB_HISTORY table ....

create table job_history (
	employee_id   number(6)
		constraint jhist_employee_nn not null,
	start_date    date
		constraint jhist_start_date_nn not null,
	end_date      date
		constraint jhist_end_date_nn not null,
	job_id        varchar2(10)
		constraint jhist_job_nn not null,
	department_id number(4),
	constraint jhist_date_interval check ( end_date > start_date )
);

	create unique index jhist_emp_id_st_date_pk on
		job_history (
			employee_id,
			start_date
		);

alter table job_history add (
	constraint jhist_emp_id_st_date_pk primary key ( employee_id,
	                                                 start_date ),
	constraint jhist_job_fk foreign key ( job_id )
		references jobs,
	constraint jhist_emp_fk foreign key ( employee_id )
		references employees,
	constraint jhist_dept_fk foreign key ( department_id )
		references departments
);

REM ********************************************************************
REM Create the EMP_DETAILS_VIEW that joins the employees, jobs, 
REM departments, jobs, countries, and locations table to provide details
REM about employees.

Prompt ******  Creating EMP_DETAILS_VIEW view ...

create or replace view emp_details_view ( employee_id,
job_id,
manager_id,
department_id,
location_id,
country_id,
first_name,
last_name,
salary,
commission_pct,
department_name,
job_title,
city,
state_province,
country_name,
region_name ) as
	select e.employee_id,
	       e.job_id,
	       e.manager_id,
	       e.department_id,
	       d.location_id,
	       l.country_id,
	       e.first_name,
	       e.last_name,
	       e.salary,
	       e.commission_pct,
	       d.department_name,
	       j.job_title,
	       l.city,
	       l.state_province,
	       c.country_name,
	       r.region_name
	  from employees e,
	       departments d,
	       jobs j,
	       locations l,
	       countries c,
	       regions r
	 where e.department_id = d.department_id
	   and d.location_id = l.location_id
	   and l.country_id = c.country_id
	   and c.region_id = r.region_id
	   and j.job_id = e.job_id
with read only;

commit;

-- ---------------------------------------------------------------------------------------------------------------------
-- populate tables
-- ---------------------------------------------------------------------------------------------------------------------

REM ***************************insert data

   SET VERIFY OFF
alter session set nls_language = american; 

REM ***************************insert data into the REGIONS table

Prompt ******  Populating REGIONS table ....

insert into regions values (
	1,
	'Europe'
);

insert into regions values (
	2,
	'Americas'
);

insert into regions values (
	3,
	'Asia'
);

insert into regions values (
	4,
	'Middle East and Africa'
);

REM ***************************insert data into the COUNTRIES table

Prompt ******  Populating COUNTIRES table ....

insert into countries values (
	'IT',
	'Italy',
	1
);

insert into countries values (
	'JP',
	'Japan',
	3
);

insert into countries values (
	'US',
	'United States of America',
	2
);

insert into countries values (
	'CA',
	'Canada',
	2
);

insert into countries values (
	'CN',
	'China',
	3
);

insert into countries values (
	'IN',
	'India',
	3
);

insert into countries values (
	'AU',
	'Australia',
	3
);

insert into countries values (
	'ZW',
	'Zimbabwe',
	4
);

insert into countries values (
	'SG',
	'Singapore',
	3
);

insert into countries values (
	'UK',
	'United Kingdom',
	1
);

insert into countries values (
	'FR',
	'France',
	1
);

insert into countries values (
	'DE',
	'Germany',
	1
);

insert into countries values (
	'ZM',
	'Zambia',
	4
);

insert into countries values (
	'EG',
	'Egypt',
	4
);

insert into countries values (
	'BR',
	'Brazil',
	2
);

insert into countries values (
	'CH',
	'Switzerland',
	1
);

insert into countries values (
	'NL',
	'Netherlands',
	1
);

insert into countries values (
	'MX',
	'Mexico',
	2
);

insert into countries values (
	'KW',
	'Kuwait',
	4
);

insert into countries values (
	'IL',
	'Israel',
	4
);

insert into countries values (
	'DK',
	'Denmark',
	1
);

insert into countries values (
	'ML',
	'Malaysia',
	3
);

insert into countries values (
	'NG',
	'Nigeria',
	4
);

insert into countries values (
	'AR',
	'Argentina',
	2
);

insert into countries values (
	'BE',
	'Belgium',
	1
);


REM ***************************insert data into the LOCATIONS table

Prompt ******  Populating LOCATIONS table ....

insert into locations values (
	1000,
	'1297 Via Cola di Rie',
	'00989',
	'Roma',
	null,
	'IT'
);

insert into locations values (
	1100,
	'93091 Calle della Testa',
	'10934',
	'Venice',
	null,
	'IT'
);

insert into locations values (
	1200,
	'2017 Shinjuku-ku',
	'1689',
	'Tokyo',
	'Tokyo Prefecture',
	'JP'
);

insert into locations values (
	1300,
	'9450 Kamiya-cho',
	'6823',
	'Hiroshima',
	null,
	'JP'
);

insert into locations values (
	1400,
	'2014 Jabberwocky Rd',
	'26192',
	'Southlake',
	'Texas',
	'US'
);

insert into locations values (
	1500,
	'2011 Interiors Blvd',
	'99236',
	'South San Francisco',
	'California',
	'US'
);

insert into locations values (
	1600,
	'2007 Zagora St',
	'50090',
	'South Brunswick',
	'New Jersey',
	'US'
);

insert into locations values (
	1700,
	'2004 Charade Rd',
	'98199',
	'Seattle',
	'Washington',
	'US'
);

insert into locations values (
	1800,
	'147 Spadina Ave',
	'M5V 2L7',
	'Toronto',
	'Ontario',
	'CA'
);

insert into locations values (
	1900,
	'6092 Boxwood St',
	'YSW 9T2',
	'Whitehorse',
	'Yukon',
	'CA'
);

insert into locations values (
	2000,
	'40-5-12 Laogianggen',
	'190518',
	'Beijing',
	null,
	'CN'
);

insert into locations values (
	2100,
	'1298 Vileparle (E)',
	'490231',
	'Bombay',
	'Maharashtra',
	'IN'
);

insert into locations values (
	2200,
	'12-98 Victoria Street',
	'2901',
	'Sydney',
	'New South Wales',
	'AU'
);

insert into locations values (
	2300,
	'198 Clementi North',
	'540198',
	'Singapore',
	null,
	'SG'
);

insert into locations values (
	2400,
	'8204 Arthur St',
	null,
	'London',
	null,
	'UK'
);

insert into locations values (
	2500,
	'Magdalen Centre, The Oxford Science Park',
	'OX9 9ZB',
	'Oxford',
	'Oxford',
	'UK'
);

insert into locations values (
	2600,
	'9702 Chester Road',
	'09629850293',
	'Stretford',
	'Manchester',
	'UK'
);

insert into locations values (
	2700,
	'Schwanthalerstr. 7031',
	'80925',
	'Munich',
	'Bavaria',
	'DE'
);

insert into locations values (
	2800,
	'Rua Frei Caneca 1360 ',
	'01307-002',
	'Sao Paulo',
	'Sao Paulo',
	'BR'
);

insert into locations values (
	2900,
	'20 Rue des Corps-Saints',
	'1730',
	'Geneva',
	'Geneve',
	'CH'
);

insert into locations values (
	3000,
	'Murtenstrasse 921',
	'3095',
	'Bern',
	'BE',
	'CH'
);

insert into locations values (
	3100,
	'Pieter Breughelstraat 837',
	'3029SK',
	'Utrecht',
	'Utrecht',
	'NL'
);

insert into locations values (
	3200,
	'Mariano Escobedo 9991',
	'11932',
	'Mexico City',
	'Distrito Federal,',
	'MX'
);


REM ****************************insert data into the DEPARTMENTS table

Prompt ******  Populating DEPARTMENTS table ....

REM disable integrity constraint to EMPLOYEES to load data

alter table departments disable constraint dept_mgr_fk;

insert into departments values (
	10,
	'Administration',
	200,
	1700
);

insert into departments values (
	20,
	'Marketing',
	201,
	1800
);

insert into departments values (
	30,
	'Purchasing',
	114,
	1700
);

insert into departments values (
	40,
	'Human Resources',
	203,
	2400
);

insert into departments values (
	50,
	'Shipping',
	121,
	1500
);

insert into departments values (
	60,
	'IT',
	103,
	1400
);

insert into departments values (
	70,
	'Public Relations',
	204,
	2700
);

insert into departments values (
	80,
	'Sales',
	145,
	2500
);

insert into departments values (
	90,
	'Executive',
	100,
	1700
);

insert into departments values (
	100,
	'Finance',
	108,
	1700
);

insert into departments values (
	110,
	'Accounting',
	205,
	1700
);

insert into departments values (
	120,
	'Treasury',
	null,
	1700
);

insert into departments values (
	130,
	'Corporate Tax',
	null,
	1700
);

insert into departments values (
	140,
	'Control And Credit',
	null,
	1700
);

insert into departments values (
	150,
	'Shareholder Services',
	null,
	1700
);

insert into departments values (
	160,
	'Benefits',
	null,
	1700
);

insert into departments values (
	170,
	'Manufacturing',
	null,
	1700
);

insert into departments values (
	180,
	'Construction',
	null,
	1700
);

insert into departments values (
	190,
	'Contracting',
	null,
	1700
);

insert into departments values (
	200,
	'Operations',
	null,
	1700
);

insert into departments values (
	210,
	'IT Support',
	null,
	1700
);

insert into departments values (
	220,
	'NOC',
	null,
	1700
);

insert into departments values (
	230,
	'IT Helpdesk',
	null,
	1700
);

insert into departments values (
	240,
	'Government Sales',
	null,
	1700
);

insert into departments values (
	250,
	'Retail Sales',
	null,
	1700
);

insert into departments values (
	260,
	'Recruiting',
	null,
	1700
);

insert into departments values (
	270,
	'Payroll',
	null,
	1700
);


REM ***************************insert data into the JOBS table

Prompt ******  Populating JOBS table ....

insert into jobs values (
	'AD_PRES',
	'President',
	20080,
	40000
);
insert into jobs values (
	'AD_VP',
	'Administration Vice President',
	15000,
	30000
);

insert into jobs values (
	'AD_ASST',
	'Administration Assistant',
	3000,
	6000
);

insert into jobs values (
	'FI_MGR',
	'Finance Manager',
	8200,
	16000
);

insert into jobs values (
	'FI_ACCOUNT',
	'Accountant',
	4200,
	9000
);

insert into jobs values (
	'AC_MGR',
	'Accounting Manager',
	8200,
	16000
);

insert into jobs values (
	'AC_ACCOUNT',
	'Public Accountant',
	4200,
	9000
);
insert into jobs values (
	'SA_MAN',
	'Sales Manager',
	10000,
	20080
);

insert into jobs values (
	'SA_REP',
	'Sales Representative',
	6000,
	12008
);

insert into jobs values (
	'PU_MAN',
	'Purchasing Manager',
	8000,
	15000
);

insert into jobs values (
	'PU_CLERK',
	'Purchasing Clerk',
	2500,
	5500
);

insert into jobs values (
	'ST_MAN',
	'Stock Manager',
	5500,
	8500
);
insert into jobs values (
	'ST_CLERK',
	'Stock Clerk',
	2008,
	5000
);

insert into jobs values (
	'SH_CLERK',
	'Shipping Clerk',
	2500,
	5500
);

insert into jobs values (
	'IT_PROG',
	'Programmer',
	4000,
	10000
);

insert into jobs values (
	'MK_MAN',
	'Marketing Manager',
	9000,
	15000
);

insert into jobs values (
	'MK_REP',
	'Marketing Representative',
	4000,
	9000
);

insert into jobs values (
	'HR_REP',
	'Human Resources Representative',
	4000,
	9000
);

insert into jobs values (
	'PR_REP',
	'Public Relations Representative',
	4500,
	10500
);


REM ***************************insert data into the EMPLOYEES table

Prompt ******  Populating EMPLOYEES table ....

insert into employees values (
	100,
	'Steven',
	'King',
	'SKING',
	'515.123.4567',
	to_date('17-06-2003','dd-MM-yyyy'),
	'AD_PRES',
	24000,
	null,
	null,
	90
);

insert into employees values (
	101,
	'Neena',
	'Kochhar',
	'NKOCHHAR',
	'515.123.4568',
	to_date('21-09-2005','dd-MM-yyyy'),
	'AD_VP',
	17000,
	null,
	100,
	90
);

insert into employees values (
	102,
	'Lex',
	'De Haan',
	'LDEHAAN',
	'515.123.4569',
	to_date('13-01-2001','dd-MM-yyyy'),
	'AD_VP',
	17000,
	null,
	100,
	90
);

insert into employees values (
	103,
	'Alexander',
	'Hunold',
	'AHUNOLD',
	'590.423.4567',
	to_date('03-01-2006','dd-MM-yyyy'),
	'IT_PROG',
	9000,
	null,
	102,
	60
);

insert into employees values (
	104,
	'Bruce',
	'Ernst',
	'BERNST',
	'590.423.4568',
	to_date('21-05-2007','dd-MM-yyyy'),
	'IT_PROG',
	6000,
	null,
	103,
	60
);

insert into employees values (
	105,
	'David',
	'Austin',
	'DAUSTIN',
	'590.423.4569',
	to_date('25-06-2005','dd-MM-yyyy'),
	'IT_PROG',
	4800,
	null,
	103,
	60
);

insert into employees values (
	106,
	'Valli',
	'Pataballa',
	'VPATABAL',
	'590.423.4560',
	to_date('05-02-2006','dd-MM-yyyy'),
	'IT_PROG',
	4800,
	null,
	103,
	60
);

insert into employees values (
	107,
	'Diana',
	'Lorentz',
	'DLORENTZ',
	'590.423.5567',
	to_date('07-02-2007','dd-MM-yyyy'),
	'IT_PROG',
	4200,
	null,
	103,
	60
);

insert into employees values (
	108,
	'Nancy',
	'Greenberg',
	'NGREENBE',
	'515.124.4569',
	to_date('17-08-2002','dd-MM-yyyy'),
	'FI_MGR',
	12008,
	null,
	101,
	100
);

insert into employees values (
	109,
	'Daniel',
	'Faviet',
	'DFAVIET',
	'515.124.4169',
	to_date('16-08-2002','dd-MM-yyyy'),
	'FI_ACCOUNT',
	9000,
	null,
	108,
	100
);

insert into employees values (
	110,
	'John',
	'Chen',
	'JCHEN',
	'515.124.4269',
	to_date('28-09-2005','dd-MM-yyyy'),
	'FI_ACCOUNT',
	8200,
	null,
	108,
	100
);

insert into employees values (
	111,
	'Ismael',
	'Sciarra',
	'ISCIARRA',
	'515.124.4369',
	to_date('30-09-2005','dd-MM-yyyy'),
	'FI_ACCOUNT',
	7700,
	null,
	108,
	100
);

insert into employees values (
	112,
	'Jose Manuel',
	'Urman',
	'JMURMAN',
	'515.124.4469',
	to_date('07-03-2006','dd-MM-yyyy'),
	'FI_ACCOUNT',
	7800,
	null,
	108,
	100
);

insert into employees values (
	113,
	'Luis',
	'Popp',
	'LPOPP',
	'515.124.4567',
	to_date('07-12-2007','dd-MM-yyyy'),
	'FI_ACCOUNT',
	6900,
	null,
	108,
	100
);

insert into employees values (
	114,
	'Den',
	'Raphaely',
	'DRAPHEAL',
	'515.127.4561',
	to_date('07-12-2002','dd-MM-yyyy'),
	'PU_MAN',
	11000,
	null,
	100,
	30
);

insert into employees values (
	115,
	'Alexander',
	'Khoo',
	'AKHOO',
	'515.127.4562',
	to_date('18-05-2003','dd-MM-yyyy'),
	'PU_CLERK',
	3100,
	null,
	114,
	30
);

insert into employees values (
	116,
	'Shelli',
	'Baida',
	'SBAIDA',
	'515.127.4563',
	to_date('24-12-2005','dd-MM-yyyy'),
	'PU_CLERK',
	2900,
	null,
	114,
	30
);

insert into employees values (
	117,
	'Sigal',
	'Tobias',
	'STOBIAS',
	'515.127.4564',
	to_date('24-07-2005','dd-MM-yyyy'),
	'PU_CLERK',
	2800,
	null,
	114,
	30
);

insert into employees values (
	118,
	'Guy',
	'Himuro',
	'GHIMURO',
	'515.127.4565',
	to_date('15-11-2006','dd-MM-yyyy'),
	'PU_CLERK',
	2600,
	null,
	114,
	30
);

insert into employees values (
	119,
	'Karen',
	'Colmenares',
	'KCOLMENA',
	'515.127.4566',
	to_date('10-08-2007','dd-MM-yyyy'),
	'PU_CLERK',
	2500,
	null,
	114,
	30
);

insert into employees values (
	120,
	'Matthew',
	'Weiss',
	'MWEISS',
	'650.123.1234',
	to_date('18-07-2004','dd-MM-yyyy'),
	'ST_MAN',
	8000,
	null,
	100,
	50
);

insert into employees values (
	121,
	'Adam',
	'Fripp',
	'AFRIPP',
	'650.123.2234',
	to_date('10-04-2005','dd-MM-yyyy'),
	'ST_MAN',
	8200,
	null,
	100,
	50
);

insert into employees values (
	122,
	'Payam',
	'Kaufling',
	'PKAUFLIN',
	'650.123.3234',
	to_date('01-05-2003','dd-MM-yyyy'),
	'ST_MAN',
	7900,
	null,
	100,
	50
);

insert into employees values (
	123,
	'Shanta',
	'Vollman',
	'SVOLLMAN',
	'650.123.4234',
	to_date('10-10-2005','dd-MM-yyyy'),
	'ST_MAN',
	6500,
	null,
	100,
	50
);

insert into employees values (
	124,
	'Kevin',
	'Mourgos',
	'KMOURGOS',
	'650.123.5234',
	to_date('16-11-2007','dd-MM-yyyy'),
	'ST_MAN',
	5800,
	null,
	100,
	50
);

insert into employees values (
	125,
	'Julia',
	'Nayer',
	'JNAYER',
	'650.124.1214',
	to_date('16-07-2005','dd-MM-yyyy'),
	'ST_CLERK',
	3200,
	null,
	120,
	50
);

insert into employees values (
	126,
	'Irene',
	'Mikkilineni',
	'IMIKKILI',
	'650.124.1224',
	to_date('28-09-2006','dd-MM-yyyy'),
	'ST_CLERK',
	2700,
	null,
	120,
	50
);

insert into employees values (
	127,
	'James',
	'Landry',
	'JLANDRY',
	'650.124.1334',
	to_date('14-01-2007','dd-MM-yyyy'),
	'ST_CLERK',
	2400,
	null,
	120,
	50
);

insert into employees values (
	128,
	'Steven',
	'Markle',
	'SMARKLE',
	'650.124.1434',
	to_date('08-03-2008','dd-MM-yyyy'),
	'ST_CLERK',
	2200,
	null,
	120,
	50
);

insert into employees values (
	129,
	'Laura',
	'Bissot',
	'LBISSOT',
	'650.124.5234',
	to_date('20-08-2005','dd-MM-yyyy'),
	'ST_CLERK',
	3300,
	null,
	121,
	50
);

insert into employees values (
	130,
	'Mozhe',
	'Atkinson',
	'MATKINSO',
	'650.124.6234',
	to_date('30-10-2005','dd-MM-yyyy'),
	'ST_CLERK',
	2800,
	null,
	121,
	50
);

insert into employees values (
	131,
	'James',
	'Marlow',
	'JAMRLOW',
	'650.124.7234',
	to_date('16-02-2005','dd-MM-yyyy'),
	'ST_CLERK',
	2500,
	null,
	121,
	50
);

insert into employees values (
	132,
	'TJ',
	'Olson',
	'TJOLSON',
	'650.124.8234',
	to_date('10-04-2007','dd-MM-yyyy'),
	'ST_CLERK',
	2100,
	null,
	121,
	50
);

insert into employees values (
	133,
	'Jason',
	'Mallin',
	'JMALLIN',
	'650.127.1934',
	to_date('14-06-2004','dd-MM-yyyy'),
	'ST_CLERK',
	3300,
	null,
	122,
	50
);

insert into employees values (
	134,
	'Michael',
	'Rogers',
	'MROGERS',
	'650.127.1834',
	to_date('26-08-2006','dd-MM-yyyy'),
	'ST_CLERK',
	2900,
	null,
	122,
	50
);

insert into employees values (
	135,
	'Ki',
	'Gee',
	'KGEE',
	'650.127.1734',
	to_date('12-12-2007','dd-MM-yyyy'),
	'ST_CLERK',
	2400,
	null,
	122,
	50
);

insert into employees values (
	136,
	'Hazel',
	'Philtanker',
	'HPHILTAN',
	'650.127.1634',
	to_date('06-02-2008','dd-MM-yyyy'),
	'ST_CLERK',
	2200,
	null,
	122,
	50
);

insert into employees values (
	137,
	'Renske',
	'Ladwig',
	'RLADWIG',
	'650.121.1234',
	to_date('14-07-2003','dd-MM-yyyy'),
	'ST_CLERK',
	3600,
	null,
	123,
	50
);

insert into employees values (
	138,
	'Stephen',
	'Stiles',
	'SSTILES',
	'650.121.2034',
	to_date('26-10-2005','dd-MM-yyyy'),
	'ST_CLERK',
	3200,
	null,
	123,
	50
);

insert into employees values (
	139,
	'John',
	'Seo',
	'JSEO',
	'650.121.2019',
	to_date('12-02-2006','dd-MM-yyyy'),
	'ST_CLERK',
	2700,
	null,
	123,
	50
);

insert into employees values (
	140,
	'Joshua',
	'Patel',
	'JPATEL',
	'650.121.1834',
	to_date('06-04-2006','dd-MM-yyyy'),
	'ST_CLERK',
	2500,
	null,
	123,
	50
);

insert into employees values (
	141,
	'Trenna',
	'Rajs',
	'TRAJS',
	'650.121.8009',
	to_date('17-10-2003','dd-MM-yyyy'),
	'ST_CLERK',
	3500,
	null,
	124,
	50
);

insert into employees values (
	142,
	'Curtis',
	'Davies',
	'CDAVIES',
	'650.121.2994',
	to_date('29-01-2005','dd-MM-yyyy'),
	'ST_CLERK',
	3100,
	null,
	124,
	50
);

insert into employees values (
	143,
	'Randall',
	'Matos',
	'RMATOS',
	'650.121.2874',
	to_date('15-03-2006','dd-MM-yyyy'),
	'ST_CLERK',
	2600,
	null,
	124,
	50
);

insert into employees values (
	144,
	'Peter',
	'Vargas',
	'PVARGAS',
	'650.121.2004',
	to_date('09-07-2006','dd-MM-yyyy'),
	'ST_CLERK',
	2500,
	null,
	124,
	50
);

insert into employees values (
	145,
	'John',
	'Russell',
	'JRUSSEL',
	'011.44.1344.429268',
	to_date('01-10-2004','dd-MM-yyyy'),
	'SA_MAN',
	14000,
	.4,
	100,
	80
);

insert into employees values (
	146,
	'Karen',
	'Partners',
	'KPARTNER',
	'011.44.1344.467268',
	to_date('05-01-2005','dd-MM-yyyy'),
	'SA_MAN',
	13500,
	.3,
	100,
	80
);

insert into employees values (
	147,
	'Alberto',
	'Errazuriz',
	'AERRAZUR',
	'011.44.1344.429278',
	to_date('10-03-2005','dd-MM-yyyy'),
	'SA_MAN',
	12000,
	.3,
	100,
	80
);

insert into employees values (
	148,
	'Gerald',
	'Cambrault',
	'GCAMBRAU',
	'011.44.1344.619268',
	to_date('15-10-2007','dd-MM-yyyy'),
	'SA_MAN',
	11000,
	.3,
	100,
	80
);

insert into employees values (
	149,
	'Eleni',
	'Zlotkey',
	'EZLOTKEY',
	'011.44.1344.429018',
	to_date('29-01-2008','dd-MM-yyyy'),
	'SA_MAN',
	10500,
	.2,
	100,
	80
);

insert into employees values (
	150,
	'Peter',
	'Tucker',
	'PTUCKER',
	'011.44.1344.129268',
	to_date('30-01-2005','dd-MM-yyyy'),
	'SA_REP',
	10000,
	.3,
	145,
	80
);

insert into employees values (
	151,
	'David',
	'Bernstein',
	'DBERNSTE',
	'011.44.1344.345268',
	to_date('24-03-2005','dd-MM-yyyy'),
	'SA_REP',
	9500,
	.25,
	145,
	80
);

insert into employees values (
	152,
	'Peter',
	'Hall',
	'PHALL',
	'011.44.1344.478968',
	to_date('20-08-2005','dd-MM-yyyy'),
	'SA_REP',
	9000,
	.25,
	145,
	80
);

insert into employees values (
	153,
	'Christopher',
	'Olsen',
	'COLSEN',
	'011.44.1344.498718',
	to_date('30-03-2006','dd-MM-yyyy'),
	'SA_REP',
	8000,
	.2,
	145,
	80
);

insert into employees values (
	154,
	'Nanette',
	'Cambrault',
	'NCAMBRAU',
	'011.44.1344.987668',
	to_date('09-12-2006','dd-MM-yyyy'),
	'SA_REP',
	7500,
	.2,
	145,
	80
);

insert into employees values (
	155,
	'Oliver',
	'Tuvault',
	'OTUVAULT',
	'011.44.1344.486508',
	to_date('23-11-2007','dd-MM-yyyy'),
	'SA_REP',
	7000,
	.15,
	145,
	80
);

insert into employees values (
	156,
	'Janette',
	'King',
	'JKING',
	'011.44.1345.429268',
	to_date('30-01-2004','dd-MM-yyyy'),
	'SA_REP',
	10000,
	.35,
	146,
	80
);

insert into employees values (
	157,
	'Patrick',
	'Sully',
	'PSULLY',
	'011.44.1345.929268',
	to_date('04-03-2004','dd-MM-yyyy'),
	'SA_REP',
	9500,
	.35,
	146,
	80
);

insert into employees values (
	158,
	'Allan',
	'McEwen',
	'AMCEWEN',
	'011.44.1345.829268',
	to_date('01-08-2004','dd-MM-yyyy'),
	'SA_REP',
	9000,
	.35,
	146,
	80
);

insert into employees values (
	159,
	'Lindsey',
	'Smith',
	'LSMITH',
	'011.44.1345.729268',
	to_date('10-03-2005','dd-MM-yyyy'),
	'SA_REP',
	8000,
	.3,
	146,
	80
);

insert into employees values (
	160,
	'Louise',
	'Doran',
	'LDORAN',
	'011.44.1345.629268',
	to_date('15-12-2005','dd-MM-yyyy'),
	'SA_REP',
	7500,
	.3,
	146,
	80
);

insert into employees values (
	161,
	'Sarath',
	'Sewall',
	'SSEWALL',
	'011.44.1345.529268',
	to_date('03-11-2006','dd-MM-yyyy'),
	'SA_REP',
	7000,
	.25,
	146,
	80
);

insert into employees values (
	162,
	'Clara',
	'Vishney',
	'CVISHNEY',
	'011.44.1346.129268',
	to_date('11-11-2005','dd-MM-yyyy'),
	'SA_REP',
	10500,
	.25,
	147,
	80
);

insert into employees values (
	163,
	'Danielle',
	'Greene',
	'DGREENE',
	'011.44.1346.229268',
	to_date('19-03-2007','dd-MM-yyyy'),
	'SA_REP',
	9500,
	.15,
	147,
	80
);

insert into employees values (
	164,
	'Mattea',
	'Marvins',
	'MMARVINS',
	'011.44.1346.329268',
	to_date('24-01-2008','dd-MM-yyyy'),
	'SA_REP',
	7200,
	.10,
	147,
	80
);

insert into employees values (
	165,
	'David',
	'Lee',
	'DLEE',
	'011.44.1346.529268',
	to_date('23-02-2008','dd-MM-yyyy'),
	'SA_REP',
	6800,
	.1,
	147,
	80
);

insert into employees values (
	166,
	'Sundar',
	'Ande',
	'SANDE',
	'011.44.1346.629268',
	to_date('24-03-2008','dd-MM-yyyy'),
	'SA_REP',
	6400,
	.10,
	147,
	80
);

insert into employees values (
	167,
	'Amit',
	'Banda',
	'ABANDA',
	'011.44.1346.729268',
	to_date('21-04-2008','dd-MM-yyyy'),
	'SA_REP',
	6200,
	.10,
	147,
	80
);

insert into employees values (
	168,
	'Lisa',
	'Ozer',
	'LOZER',
	'011.44.1343.929268',
	to_date('11-03-2005','dd-MM-yyyy'),
	'SA_REP',
	11500,
	.25,
	148,
	80
);

insert into employees values (
	169,
	'Harrison',
	'Bloom',
	'HBLOOM',
	'011.44.1343.829268',
	to_date('23-03-2006','dd-MM-yyyy'),
	'SA_REP',
	10000,
	.20,
	148,
	80
);

insert into employees values (
	170,
	'Tayler',
	'Fox',
	'TFOX',
	'011.44.1343.729268',
	to_date('24-01-2006','dd-MM-yyyy'),
	'SA_REP',
	9600,
	.20,
	148,
	80
);

insert into employees values (
	171,
	'William',
	'Smith',
	'WSMITH',
	'011.44.1343.629268',
	to_date('23-02-2007','dd-MM-yyyy'),
	'SA_REP',
	7400,
	.15,
	148,
	80
);

insert into employees values (
	172,
	'Elizabeth',
	'Bates',
	'EBATES',
	'011.44.1343.529268',
	to_date('24-03-2007','dd-MM-yyyy'),
	'SA_REP',
	7300,
	.15,
	148,
	80
);

insert into employees values (
	173,
	'Sundita',
	'Kumar',
	'SKUMAR',
	'011.44.1343.329268',
	to_date('21-04-2008','dd-MM-yyyy'),
	'SA_REP',
	6100,
	.10,
	148,
	80
);

insert into employees values (
	174,
	'Ellen',
	'Abel',
	'EABEL',
	'011.44.1644.429267',
	to_date('11-05-2004','dd-MM-yyyy'),
	'SA_REP',
	11000,
	.30,
	149,
	80
);

insert into employees values (
	175,
	'Alyssa',
	'Hutton',
	'AHUTTON',
	'011.44.1644.429266',
	to_date('19-03-2005','dd-MM-yyyy'),
	'SA_REP',
	8800,
	.25,
	149,
	80
);

insert into employees values (
	176,
	'Jonathon',
	'Taylor',
	'JTAYLOR',
	'011.44.1644.429265',
	to_date('24-03-2006','dd-MM-yyyy'),
	'SA_REP',
	8600,
	.20,
	149,
	80
);

insert into employees values (
	177,
	'Jack',
	'Livingston',
	'JLIVINGS',
	'011.44.1644.429264',
	to_date('23-04-2006','dd-MM-yyyy'),
	'SA_REP',
	8400,
	.20,
	149,
	80
);

insert into employees values (
	178,
	'Kimberely',
	'Grant',
	'KGRANT',
	'011.44.1644.429263',
	to_date('24-05-2007','dd-MM-yyyy'),
	'SA_REP',
	7000,
	.15,
	149,
	null
);

insert into employees values (
	179,
	'Charles',
	'Johnson',
	'CJOHNSON',
	'011.44.1644.429262',
	to_date('04-01-2008','dd-MM-yyyy'),
	'SA_REP',
	6200,
	.10,
	149,
	80
);

insert into employees values (
	180,
	'Winston',
	'Taylor',
	'WTAYLOR',
	'650.507.9876',
	to_date('24-01-2006','dd-MM-yyyy'),
	'SH_CLERK',
	3200,
	null,
	120,
	50
);

insert into employees values (
	181,
	'Jean',
	'Fleaur',
	'JFLEAUR',
	'650.507.9877',
	to_date('23-02-2006','dd-MM-yyyy'),
	'SH_CLERK',
	3100,
	null,
	120,
	50
);

insert into employees values (
	182,
	'Martha',
	'Sullivan',
	'MSULLIVA',
	'650.507.9878',
	to_date('21-06-2007','dd-MM-yyyy'),
	'SH_CLERK',
	2500,
	null,
	120,
	50
);

insert into employees values (
	183,
	'Girard',
	'Geoni',
	'GGEONI',
	'650.507.9879',
	to_date('03-02-2008','dd-MM-yyyy'),
	'SH_CLERK',
	2800,
	null,
	120,
	50
);

insert into employees values (
	184,
	'Nandita',
	'Sarchand',
	'NSARCHAN',
	'650.509.1876',
	to_date('27-01-2004','dd-MM-yyyy'),
	'SH_CLERK',
	4200,
	null,
	121,
	50
);

insert into employees values (
	185,
	'Alexis',
	'Bull',
	'ABULL',
	'650.509.2876',
	to_date('20-02-2005','dd-MM-yyyy'),
	'SH_CLERK',
	4100,
	null,
	121,
	50
);

insert into employees values (
	186,
	'Julia',
	'Dellinger',
	'JDELLING',
	'650.509.3876',
	to_date('24-06-2006','dd-MM-yyyy'),
	'SH_CLERK',
	3400,
	null,
	121,
	50
);

insert into employees values (
	187,
	'Anthony',
	'Cabrio',
	'ACABRIO',
	'650.509.4876',
	to_date('07-02-2007','dd-MM-yyyy'),
	'SH_CLERK',
	3000,
	null,
	121,
	50
);

insert into employees values (
	188,
	'Kelly',
	'Chung',
	'KCHUNG',
	'650.505.1876',
	to_date('14-06-2005','dd-MM-yyyy'),
	'SH_CLERK',
	3800,
	null,
	122,
	50
);

insert into employees values (
	189,
	'Jennifer',
	'Dilly',
	'JDILLY',
	'650.505.2876',
	to_date('13-08-2005','dd-MM-yyyy'),
	'SH_CLERK',
	3600,
	null,
	122,
	50
);

insert into employees values (
	190,
	'Timothy',
	'Gates',
	'TGATES',
	'650.505.3876',
	to_date('11-07-2006','dd-MM-yyyy'),
	'SH_CLERK',
	2900,
	null,
	122,
	50
);

insert into employees values (
	191,
	'Randall',
	'Perkins',
	'RPERKINS',
	'650.505.4876',
	to_date('19-12-2007','dd-MM-yyyy'),
	'SH_CLERK',
	2500,
	null,
	122,
	50
);

insert into employees values (
	192,
	'Sarah',
	'Bell',
	'SBELL',
	'650.501.1876',
	to_date('04-02-2004','dd-MM-yyyy'),
	'SH_CLERK',
	4000,
	null,
	123,
	50
);

insert into employees values (
	193,
	'Britney',
	'Everett',
	'BEVERETT',
	'650.501.2876',
	to_date('03-03-2005','dd-MM-yyyy'),
	'SH_CLERK',
	3900,
	null,
	123,
	50
);

insert into employees values (
	194,
	'Samuel',
	'McCain',
	'SMCCAIN',
	'650.501.3876',
	to_date('01-07-2006','dd-MM-yyyy'),
	'SH_CLERK',
	3200,
	null,
	123,
	50
);

insert into employees values (
	195,
	'Vance',
	'Jones',
	'VJONES',
	'650.501.4876',
	to_date('17-03-2007','dd-MM-yyyy'),
	'SH_CLERK',
	2800,
	null,
	123,
	50
);

insert into employees values (
	196,
	'Alana',
	'Walsh',
	'AWALSH',
	'650.507.9811',
	to_date('24-04-2006','dd-MM-yyyy'),
	'SH_CLERK',
	3100,
	null,
	124,
	50
);

insert into employees values (
	197,
	'Kevin',
	'Feeney',
	'KFEENEY',
	'650.507.9822',
	to_date('23-05-2006','dd-MM-yyyy'),
	'SH_CLERK',
	3000,
	null,
	124,
	50
);

insert into employees values (
	198,
	'Donald',
	'OConnell',
	'DOCONNEL',
	'650.507.9833',
	to_date('21-06-2007','dd-MM-yyyy'),
	'SH_CLERK',
	2600,
	null,
	124,
	50
);

insert into employees values (
	199,
	'Douglas',
	'Grant',
	'DGRANT',
	'650.507.9844',
	to_date('13-01-2008','dd-MM-yyyy'),
	'SH_CLERK',
	2600,
	null,
	124,
	50
);

insert into employees values (
	200,
	'Jennifer',
	'Whalen',
	'JWHALEN',
	'515.123.4444',
	to_date('17-09-2003','dd-MM-yyyy'),
	'AD_ASST',
	4400,
	null,
	101,
	10
);

insert into employees values (
	201,
	'Michael',
	'Hartstein',
	'MHARTSTE',
	'515.123.5555',
	to_date('17-02-2004','dd-MM-yyyy'),
	'MK_MAN',
	13000,
	null,
	100,
	20
);

insert into employees values (
	202,
	'Pat',
	'Fay',
	'PFAY',
	'603.123.6666',
	to_date('17-08-2005','dd-MM-yyyy'),
	'MK_REP',
	6000,
	null,
	201,
	20
);

insert into employees values (
	203,
	'Susan',
	'Mavris',
	'SMAVRIS',
	'515.123.7777',
	to_date('07-06-2002','dd-MM-yyyy'),
	'HR_REP',
	6500,
	null,
	101,
	40
);

insert into employees values (
	204,
	'Hermann',
	'Baer',
	'HBAER',
	'515.123.8888',
	to_date('07-06-2002','dd-MM-yyyy'),
	'PR_REP',
	10000,
	null,
	101,
	70
);

insert into employees values (
	205,
	'Shelley',
	'Higgins',
	'SHIGGINS',
	'515.123.8080',
	to_date('07-06-2002','dd-MM-yyyy'),
	'AC_MGR',
	12008,
	null,
	101,
	110
);

insert into employees values (
	206,
	'William',
	'Gietz',
	'WGIETZ',
	'515.123.8181',
	to_date('07-06-2002','dd-MM-yyyy'),
	'AC_ACCOUNT',
	8300,
	null,
	205,
	110
);

REM ********* insert data into the JOB_HISTORY table

Prompt ******  Populating JOB_HISTORY table ....


insert into job_history values (
	102,
	to_date('13-01-2001','dd-MM-yyyy'),
	to_date('24-07-2006','dd-MM-yyyy'),
	'IT_PROG',
	60
);

insert into job_history values (
	101,
	to_date('21-09-1997','dd-MM-yyyy'),
	to_date('27-10-2001','dd-MM-yyyy'),
	'AC_ACCOUNT',
	110
);

insert into job_history values (
	101,
	to_date('28-10-2001','dd-MM-yyyy'),
	to_date('15-03-2005','dd-MM-yyyy'),
	'AC_MGR',
	110
);

insert into job_history values (
	201,
	to_date('17-02-2004','dd-MM-yyyy'),
	to_date('19-12-2007','dd-MM-yyyy'),
	'MK_REP',
	20
);

insert into job_history values (
	114,
	to_date('24-03-2006','dd-MM-yyyy'),
	to_date('31-12-2007','dd-MM-yyyy'),
	'ST_CLERK',
	50
);

insert into job_history values (
	122,
	to_date('01-01-2007','dd-MM-yyyy'),
	to_date('31-12-2007','dd-MM-yyyy'),
	'ST_CLERK',
	50
);

insert into job_history values (
	200,
	to_date('17-09-1995','dd-MM-yyyy'),
	to_date('17-06-2001','dd-MM-yyyy'),
	'AD_ASST',
	90
);

insert into job_history values (
	176,
	to_date('24-03-2006','dd-MM-yyyy'),
	to_date('31-12-2006','dd-MM-yyyy'),
	'SA_REP',
	80
);

insert into job_history values (
	176,
	to_date('01-01-2007','dd-MM-yyyy'),
	to_date('31-12-2007','dd-MM-yyyy'),
	'SA_MAN',
	80
);

insert into job_history values (
	200,
	to_date('01-07-2002','dd-MM-yyyy'),
	to_date('31-12-2006','dd-MM-yyyy'),
	'AC_ACCOUNT',
	90
);

REM enable integrity constraint to DEPARTMENTS

alter table departments enable constraint dept_mgr_fk;

commit;

-- ---------------------------------------------------------------------------------------------------------------------
-- Create indexes
-- ---------------------------------------------------------------------------------------------------------------------

   SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

	create index emp_department_ix on
		employees (
			department_id
		);

	create index emp_job_ix on
		employees (
			job_id
		);

	create index emp_manager_ix on
		employees (
			manager_id
		);

	create index emp_name_ix on
		employees (
			last_name,
			first_name
		);

	create index dept_location_ix on
		departments (
			location_id
		);

	create index jhist_job_ix on
		job_history (
			job_id
		);

	create index jhist_employee_ix on
		job_history (
			employee_id
		);

	create index jhist_department_ix on
		job_history (
			department_id
		);

	create index loc_city_ix on
		locations (
			city
		);

	create index loc_state_province_ix on
		locations (
			state_province
		);

	create index loc_country_ix on
		locations (
			country_id
		);

commit;

-- ---------------------------------------------------------------------------------------------------------------------
-- create procedural objects
-- ---------------------------------------------------------------------------------------------------------------------

REM procedure and statement trigger to allow dmls during business hours:
create or replace procedure secure_dml is
begin
	if to_char(
		sysdate,
		'HH24:MI'
	) not between '08:00' and '18:00' or to_char(
		sysdate,
		'DY'
	) in ( 'SAT',
	       'SUN' ) then
		raise_application_error(
		                       -20205,
		                       'You may only make changes during normal office hours'
		);
	end if;
end secure_dml;
/

create or replace trigger secure_employees before
	insert or update or delete on employees
begin
	secure_dml;
end secure_employees;
/

alter trigger secure_employees disable;

REM **************************************************************************
REM procedure to add a row to the JOB_HISTORY table and row trigger 
REM to call the procedure when data is updated in the job_id or 
REM department_id columns in the EMPLOYEES table:

create or replace procedure add_job_history (
	p_emp_id        job_history.employee_id%type,
	p_start_date    job_history.start_date%type,
	p_end_date      job_history.end_date%type,
	p_job_id        job_history.job_id%type,
	p_department_id job_history.department_id%type
) is
begin
	insert into job_history (
		employee_id,
		start_date,
		end_date,
		job_id,
		department_id
	) values (
		p_emp_id,
		p_start_date,
		p_end_date,
		p_job_id,
		p_department_id
	);
end add_job_history;
/

create or replace trigger update_job_history after
	update of job_id,department_id on employees
	for each row
begin
	add_job_history(
	               :old.employee_id,
	               :old.hire_date,
	               sysdate,
	               :old.job_id,
	               :old.department_id
	);
end;
/

commit;

-- ---------------------------------------------------------------------------------------------------------------------
-- add comments to tables and columns
-- ---------------------------------------------------------------------------------------------------------------------

comment on table regions is
	'Regions table that contains region numbers and names. Contains 4 rows; references with the Countries table.';
comment on column regions.region_id is
	'Primary key of regions table.';
comment on column regions.region_name is
	'Names of regions. Locations are in the countries of these regions.';

comment on table locations is
	'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';
comment on column locations.location_id is
	'Primary key of locations table';
comment on column locations.street_address is
	'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';
comment on column locations.postal_code is
	'Postal code of the location of an office, warehouse, or production site 
of a company. ';
comment on column locations.city is
	'A not null column that shows city where an office, warehouse, or 
production site of a company is located. ';
comment on column locations.state_province is
	'State or Province where an office, warehouse, or production site of a 
company is located.';
comment on column locations.country_id is
	'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';


REM *********************************************

comment on table departments is
	'Departments table that shows details of departments where employees 
work. Contains 27 rows; references with locations, employees, and job_history tables.';

comment on column departments.department_id is
	'Primary key column of departments table.';

comment on column departments.department_name is
	'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting. ';

comment on column departments.manager_id is
	'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.'
	;

comment on column departments.location_id is
	'Location id where a department is located. Foreign key to location_id column of locations table.';


REM *********************************************

comment on table job_history is
	'Table that stores job history of the employees. If an employee 
changes departments within the job or changes jobs within the department, 
new rows get inserted into this table with old job information of the 
employee. Contains a complex primary key: employee_id+start_date.
Contains 25 rows. References with jobs, employees, and departments tables.';

comment on column job_history.employee_id is
	'A not null column in the complex primary key employee_id+start_date.
Foreign key to employee_id column of the employee table';

comment on column job_history.start_date is
	'A not null column in the complex primary key employee_id+start_date. 
Must be less than the end_date of the job_history table. (enforced by 
constraint jhist_date_interval)';

comment on column job_history.end_date is
	'Last day of the employee in this job role. A not null column. Must be 
greater than the start_date of the job_history table. 
(enforced by constraint jhist_date_interval)';

comment on column job_history.job_id is
	'Job role in which the employee worked in the past; foreign key to 
job_id column in the jobs table. A not null column.';

comment on column job_history.department_id is
	'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';


REM *********************************************

comment on table countries is
	'country table. Contains 25 rows. References with locations table.';

comment on column countries.country_id is
	'Primary key of countries table.';

comment on column countries.country_name is
	'Country name';

comment on column countries.region_id is
	'Region ID for the country. Foreign key to region_id column in the departments table.';

REM *********************************************

comment on table jobs is
	'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';

comment on column jobs.job_id is
	'Primary key of jobs table.';

comment on column jobs.job_title is
	'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';

comment on column jobs.min_salary is
	'Minimum salary for a job title.';

comment on column jobs.max_salary is
	'Maximum salary for a job title';

REM *********************************************

comment on table employees is
	'employees table. Contains 107 rows. References with departments, 
jobs, job_history tables. Contains a self reference.';

comment on column employees.employee_id is
	'Primary key of employees table.';

comment on column employees.first_name is
	'First name of the employee. A not null column.';

comment on column employees.last_name is
	'Last name of the employee. A not null column.';

comment on column employees.email is
	'Email id of the employee';

comment on column employees.phone_number is
	'Phone number of the employee; includes country code and area code';

comment on column employees.hire_date is
	'Date when the employee started on this job. A not null column.';

comment on column employees.job_id is
	'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';

comment on column employees.salary is
	'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint emp_salary_min)';

comment on column employees.commission_pct is
	'Commission percentage of the employee; Only employees in sales 
department elgible for commission percentage';

comment on column employees.manager_id is
	'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';

comment on column employees.department_id is
	'Department id where employee works; foreign key to department_id 
column of the departments table';

commit;


-- ---------------------------------------------------------------------------------------------------------------------
-- job_grades
-- ---------------------------------------------------------------------------------------------------------------------

CREATE TABLE job_grades (
grade 		CHAR(1),
lowest_sal 	NUMBER(8,2) NOT NULL,
highest_sal	NUMBER(8,2) NOT NULL
);

ALTER TABLE job_grades
ADD CONSTRAINT jobgrades_grade_pk PRIMARY KEY (grade);

INSERT INTO job_grades VALUES ('A', 1000, 2999);
INSERT INTO job_grades VALUES ('B', 3000, 5999);
INSERT INTO job_grades VALUES ('C', 6000, 9999);
INSERT INTO job_grades VALUES ('D', 10000, 14999);
INSERT INTO job_grades VALUES ('E', 15000, 24999);
INSERT INTO job_grades VALUES ('F', 25000, 40000);

COMMIT;

-- DROP TABLE MESSAGES;
CREATE TABLE MESSAGES(
  ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 START WITH 1 NOT NULL 
, RESULTS VARCHAR2(500) NOT NULL 
, CREATE_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL 
, CONSTRAINT MESSAGES_PK PRIMARY KEY (ID) ENABLE 
);
ALTER TABLE MESSAGES
ADD CONSTRAINT MESSAGES_RESULTS_NOT_BLANK 
	CHECK (NVL(LENGTH(TRIM(RESULTS)),0) > 0) ENABLE;

INSERT INTO MESSAGES(RESULTS) VALUES('Table created');

COMMIT;

--drop table emp;
create table emp 
as select * from employees;
