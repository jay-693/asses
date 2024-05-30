
/*1.Select all departments in all locations where the Total Salary of a Department is Greater than twice the Average Salary for the department.
And max basic for the department is at least thrice the Min basic for the department*/

create table deptable(id int,name varchar(20),dep varchar(20),city varchar(20),sal int);
insert into deptable values(100,'a','hr','hyderabad',60000);
insert into deptable values(101,'g','hr','hyderabad',40000);
insert into deptable values(102,'h','marketing','chennai',90000);
insert into deptable values(108,'i','marketing','chennai',30000);
insert into deptable values(109,'j','marketing','chennai',20000);
insert into deptable values(110,'c','finance','hyderabad',16000);
insert into deptable values(105,'d','hr','hyderabad',15000);
insert into deptable values(106,'e','finanace','hyderabad',10000);
insert into deptable values(107,'f','finance','hyderabad',57000);
select dep,city from deptable group by dep,city having (sum(sal)>2*(avg(sal)) and max(sal)>3*(min(sal)));


/*2. As per the companies rule if an employee has put up service of 1 Year 3 Months and 15 days in office, Then She/he would be eligible for a Bonus.
the Bonus would be Paid on the first of the Next month after which a person has attained eligibility. Find out the eligibility date for all the employees. 
And also find out the age of the Employee On the date of Payment of the First bonus. Display the Age in Years, Months, and Days.
Also Display the weekday Name, week of the year, Day of the year and week of the month of the date on which the person has attained the eligibility*/
create table bonusdate(id int identity,doj date,dob date);
insert into bonusdate values('2024-05-21','2002-05-13');
insert into bonusdate values('2022-11-30','2000-03-17');
insert into bonusdate values('2024-01-31','2001-08-13');
insert into bonusdate values('2021-06-05','1999-12-09');
insert into bonusdate values('2024-02-14','2003-01-15');
insert into bonusdate values('2020-12-20','1997-08-22');
insert into bonusdate values('2023-11-16','2001-05-19');
select * from bonusdate;
with datedifference as(
select id,doj,dob,
dateadd(month,3,dateadd(day,15,dateadd(year,1,doj))) as eligible_date,
dateadd(month,datediff(month,0,dateadd(month,3,dateadd(day,15,dateadd(year,1,doj))))+1,0) as BonusPaymentDate,
datename(weekday,dateadd(month,3,dateadd(day,15,dateadd(year,1,doj)))) as EligibleWeekday_Name,
datepart(week,dateadd(month,3,dateadd(day,15,dateadd(year,1,doj)))) as Eligible_WeekoftheYear,
datepart(dayofyear,dateadd(month,3,dateadd(day,15,dateadd(year,1,doj)))) as Eligibile_DayoftheYear,
((datepart(day,dateadd(month,3,dateadd(day,15,dateadd(year,1,doj))))/7)+1) as Eligibile_weekofthemonth from bonusdate
)
select *,dbo.age_dif(dob,eligible_date) as age_diff from datedifference;
CREATE FUNCTION age_dif(
    @dob DATE,
    @curda DATE
)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @years INT,@months INT,@days INT,@tmpdate DATE;
SET @tmpdate = @dob;
SET @years = DATEDIFF(yy, @tmpdate, @curda) - 
CASE 
WHEN (MONTH(@dob) > MONTH(@curda)) OR (MONTH(@dob) = MONTH(@curda) AND DAY(@dob) > DAY(@curda)) 
THEN 1 
ELSE 0 
END;
SET @tmpdate = DATEADD(yy, @years, @tmpdate)
SET @months = DATEDIFF(m, @tmpdate, @curda) - 
CASE WHEN DAY(@dob) > DAY(@curda) THEN 1 ELSE 0 END;
SET @tmpdate = DATEADD(m, @months, @tmpdate);
SET @days = DATEDIFF(d, @tmpdate, @curda);
RETURN CAST(@years AS VARCHAR(10)) + ' years ' + CAST(@months AS VARCHAR(10)) + ' months ' + CAST(@days AS VARCHAR(10)) + ' days';
END;


--3.Company Has decided to Pay a bonus to all its employees. The criteria is as follows
create table bonus(id int,name varchar(20),[servicetype] int,[employeetype] int,dob date,doj date);
insert into bonus values(100,'srinivas',1,1,'1990-05-30','2011-02-19');
insert into bonus values(101,'ruthvik',1,1,'1968-05-30','2011-02-19');
insert into bonus values(102,'jesh',1,2,'1980-05-30','2010-02-19');
insert into bonus values(103,'yesh',1,2,'1980-05-30','2014-02-19');
insert into bonus values(104,'puneeth',1,2,'1988-05-30','2014-02-19');
insert into bonus values(105,'jay',1,3,'1980-05-30','2011-02-19');
insert into bonus values(106,'shiva',2,1,'1975-05-30','2007-02-19');
insert into bonus values(106,'shiva',2,2,'1975-05-30','2015-02-19');
SELECT * FROM bonus
WHERE 
    (ServiceType = 1 AND
    (
        (employeetype = 1 AND DATEDIFF(YEAR,doj,GETDATE()) >= 10 AND (60-abs(datediff(year,dob,getdate())))>=15) OR
        (employeetype = 2 AND DATEDIFF(YEAR,doj,GETDATE()) >= 12 AND (55-abs(datediff(year,dob,getdate())))>= 14) OR
        (employeetype = 3 AND DATEDIFF(YEAR,doj,GETDATE()) >= 12 AND (55-abs(datediff(year,dob,getdate())))>= 12)
    ))
	OR
    (ServiceType IN (2, 3, 4) AND DATEDIFF(YEAR,doj,GETDATE())>=15 AND (65-abs(datediff(year,dob,getdate())))>=20)
	


--4.write a query to Get Max, Min and Average age of employees, service of employees by service Type , Service Status for each Centre(display in years and Months)
alter table bonus add age as datediff(year,dob,getdate());
alter table bonus add calservice as datediff(year,doj,getdate());
alter table bonus drop column calservice;
select * from bonus;
select *,min(age) over(partition by servicetype order by servicetype)as minage,max(age) over(partition by servicetype order by servicetype) as maxage,avg(age) over(partition by servicetype order by servicetype) as avgage from bonus;



--5.Write a query to list out all the employees where any of the words (Excluding Initials) in the Name starts and ends with the samecharacter. (Assume there are not more than 5 words in any name )
create table em(id int,name varchar(20),gender varchar(1));
insert into em values(100,'K Anna','m');
insert into em values(101,'Bos Asa','f');
insert into em values(102,'S bob','m');
insert into em values(103,'M david','m');
insert into em values(104,'N imani','f');
insert into em values(105,'V Vijay','m');
insert into em values(106,'K purandhar','m');
--if the full name is given as firstname+lastname
SELECT name FROM em WHERE 
    SUBSTRING(Name, CHARINDEX(' ',Name) + 1, 1) = 
	SUBSTRING(SUBSTRING(Name, CHARINDEX(' ',Name) + 1, LEN(Name)),
	LEN(SUBSTRING(Name, CHARINDEX(' ',Name) + 1, LEN(Name))), 1)
    AND CHARINDEX(' ',Name) > 0;
--if the full name is given as lastname+firstname
create table em1(id int,nm varchar(20),gender varchar(1));
insert into em1 values(100,'Anna k','m');
insert into em1 values(101,'Asa bos','f');
insert into em1 values(102,'bob S','m');
insert into em1 values(103,'david M','m');
insert into em1 values(104,'imani N','f');
insert into em1 values(105,'Vijay V','m');
insert into em1 values(106,'purandhar K','m');
SELECT nm FROM em1 WHERE
    SUBSTRING(nm,1,1) = 
	SUBSTRING(SUBSTRING(nm, 1,CHARINDEX(' ', nm)-1),
	LEN(SUBSTRING(nm, 1,CHARINDEX(' ', nm)-1)), 1)
    AND CHARINDEX(' ',nm) > 0;