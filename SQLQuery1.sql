
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
CREATE TABLE Calendar
(
    [Date] DATE PRIMARY KEY,
    DayOfYear INT,
    Week INT,
    DayOfWeek INT,
    Month INT,
    DayOfMonth INT
);
CREATE PROCEDURE GenerateCalendarForYear
    @Year INT
AS
BEGIN
    -- Clear any existing data for the specified year
    DELETE FROM Calendar WHERE YEAR([Date]) = @Year;
    
    -- Declare variables
    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(@Year, 12, 31);
    DECLARE @CurrentDate DATE = @StartDate;
    
    -- Loop through each day of the year
    WHILE @CurrentDate <= @EndDate
    BEGIN
        -- Calculate the required attributes
        DECLARE @DayOfYear INT = DATEPART(DAYOFYEAR, @CurrentDate);
        DECLARE @Week INT = DATEPART(WEEK, @CurrentDate);
        DECLARE @DayOfWeek INT = DATEPART(WEEKDAY, @CurrentDate);
        DECLARE @Month INT = DATEPART(MONTH, @CurrentDate);
        DECLARE @DayOfMonth INT = DATEPART(DAY, @CurrentDate);
        
        -- Insert the data into the Calendar table
        INSERT INTO Calendar ([Date], DayOfYear, Week, DayOfWeek, Month, DayOfMonth)
        VALUES (@CurrentDate, @DayOfYear, @Week, @DayOfWeek, @Month, @DayOfMonth);
        
        -- Move to the next day
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
END
EXEC GenerateCalendarForYear @Year = 2017;
