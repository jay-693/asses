
--Write a script to extracts all the numerics from Alphanumeric String
CREATE FUNCTION dbo.get_numeric
(
  @string VARCHAR(256)
)
RETURNS VARCHAR(256)
AS
BEGIN
  DECLARE @Alpha INT
  SET @Alpha = PATINDEX('%[^0-9]%', @string)
  
  WHILE @Alpha > 0
  BEGIN
    SET @string = STUFF(@string, @Alpha, 1, '')
    SET @Alpha = PATINDEX('%[^0-9]%', @string)
  END

  RETURN CASE when LEN(@string) > 0 THEN @string ELSE '0' END
END
GO
select dbo.get_numeric('24gsehjn34') as num;



--Write a script to calculate age based on the Input DOB
create table emp(empid int,empname nvarchar(100),dob datetime);
insert into emp values(123,'a','2002-09-30');
insert into emp values(156,'b','2001-05-15');
insert into emp values(197,'c','1998-08-16');
select * from emp;
CREATE FUNCTION dbo.cal_age
(
  @birthdate DATE
)
RETURNS INT
AS
BEGIN
  DECLARE @age INT;
  SET @age = DATEDIFF(YEAR, @birthdate, GETDATE()) - 
             CASE 
               WHEN DATEADD(YEAR, DATEDIFF(YEAR, @birthdate, GETDATE()), @birthdate) > GETDATE() 
               THEN 1 
               ELSE 0 
             END;
  RETURN @age;
END
GO
drop function cal_age;
select empid,empname,dbo.cal_age(dob) as age from emp;



--Create a column in a table and that should throw an error when we do SELECT * or SELECT of that column. If we select other columns then we should see results
Alter table emp add tot as (1/0);
select empid,empname,dob from emp;
select * from emp;
select tot from emp;



-- Display Calendar Table based on the input year
CREATE TABLE Calendar
(
    [Date] DATE PRIMARY KEY,
    DayOfYear INT,
    Week INT,
    DayOfWeek INT,
    Month INT,
    DayOfMonth INT
);
CREATE PROCEDURE CalendarForYear
    @Year INT
AS
BEGIN
    DELETE FROM Calendar;
    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(@Year, 12, 31);
    DECLARE @CurrentDate DATE = @StartDate;
    WHILE @CurrentDate <= @EndDate
    BEGIN
        DECLARE @DayOfYear INT = DATEPART(DAYOFYEAR, @CurrentDate);
        DECLARE @Week INT = DATEPART(WEEK, @CurrentDate);
        DECLARE @DayOfWeek INT = DATEPART(WEEKDAY, @CurrentDate);
        DECLARE @Month INT = DATEPART(MONTH, @CurrentDate);
        DECLARE @DayOfMonth INT = DATEPART(DAY, @CurrentDate);
        INSERT INTO Calendar ([Date], DayOfYear, Week, DayOfWeek, Month, DayOfMonth)
        VALUES (@CurrentDate, @DayOfYear, @Week, @DayOfWeek, @Month, @DayOfMonth);
        
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
END
drop procedure CalendarForYear;
EXEC CalendarForYear @Year = 2023;
select * from Calendar;
create table tr(iden int,dob date,nm varchar);
drop table tr;
insert into tr values(1,'2002-05-13',123);
SELECT TRY_CONVERT(char,iden) as dob_in_date FROM tr;
insert into tr values(1,'2002-05-13');


--Display Emp and Manager Hierarchies based on the input till the topmost hierarchy. (Input would be empid) Output: Empid, empname, managername, heirarchylevel
create table Employee(empid INT PRIMARY KEY,empname VARCHAR(100),managerid INT);
drop table Employee;
insert into Employee VALUES(1,'John', 4);
insert into Employee VALUES(2, 'Alice', 3);
insert into Employee VALUES(3, 'Bob', 4);
insert into Employee VALUES(4, 'Carol', 5);
insert into Employee VALUES(5, 'David', NULL);
select * from employee;

CREATE PROCEDURE GetEmployeeHierarchy
    @InputEmployeeId INT
AS
BEGIN
    WITH EmployeeHierarchy AS (
        SELECT 
            empid, 
            empname, 
            CAST(NULL AS VARCHAR(100)) AS managername, 
            0 AS hierarchy_level
        FROM 
            Employee
        WHERE 
            empid = @InputEmployeeId 

        UNION ALL

        SELECT 
            e.empid, 
            e.empname, 
            CAST(m.empname AS VARCHAR(100)) AS managername,
            eh.hierarchy_level + 1
        FROM 
            Employee e
        INNER JOIN 
            EmployeeHierarchy eh ON e.managerid = eh.empid
        JOIN 
            Employee m ON e.managerid = m.empid
    )
    SELECT 
        empid, 
        empname, 
        managername, 
        hierarchy_level
    FROM 
        EmployeeHierarchy;
END;
EXEC GetEmployeeHierarchy @InputEmployeeId = 4; 

