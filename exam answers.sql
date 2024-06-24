 
 -----------------------------------------------------------------------------
 -- 3
 
 CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Marks INT
);

CREATE TABLE Grades (
    Grade INT PRIMARY KEY,
    Min_Mark INT,
    Max_Mark INT
);


INSERT INTO Students (ID, Name, Marks) VALUES
(1, 'Alice', 85),
(2, 'Bob', 92),
(3, 'Charlie', 67),
(4, 'David', 53),
(5, 'Eve', 48),
(6, 'Frank', 75),
(7, 'Grace', 32),
(8, 'Hank', 25),
(9, 'Ivy', 15),
(10, 'Jack', 5);

INSERT INTO Grades (Grade, Min_Mark, Max_Mark) VALUES
(1, 0, 2),
(2, 3, 19),
(3, 20, 29),
(4, 30, 39),
(5, 40, 49),
(6, 50, 59),
(7, 60, 69),
(8, 70, 79),
(9, 80, 89),
(10, 90, 100);


select 
    case 
        when g.grade < 8 then 'null'
        else s.name 
    end as name,
    g.grade,
    s.marks
from students s
join grades g
on s.marks between g.min_mark and g.max_mark
order by 
    g.grade desc,
    case 
        when g.grade >= 8 then s.name
        else null
    end asc,
    case
        when g.grade < 8 then s.marks
        else null
    end asc;
	---------------------

with studentgrades as (
    select 
        s.name,
        g.grade,
        s.marks,
        case 
            when g.grade < 8 then 'null'
            else s.name 
        end as display_name
    from students s
    join grades g
    on s.marks between g.min_mark and g.max_mark
)
select display_name as name, grade, marks from studentgrades
order by grade desc,
    case 
        when grade >= 8 then display_name
        else null
    end asc,
    case
        when grade < 8 then marks
        else null
    end asc;



-- -------------------------- 4 ------------------------------------------------------------

CREATE TABLE Hackertable (
    hacker_id INTEGER PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO Hackertable (hacker_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');

CREATE TABLE Difficultytable (
    challenge_id INTEGER PRIMARY KEY,
    difficulty_level INTEGER
);

INSERT INTO Difficultytable (challenge_id, difficulty_level) VALUES
(101, 5),
(102, 3),
(103, 7),
(104, 2);

CREATE TABLE Submissions (
    submission_id INTEGER PRIMARY KEY,
    hacker_id INTEGER,
    challenge_id INTEGER,
    score INTEGER
);

INSERT INTO Submissions (submission_id, hacker_id, challenge_id, score) VALUES
(1, 1, 101, 5),
(2, 1, 102, 3),
(3, 1, 103, 7),
(4, 2, 101, 5),
(5, 2, 102, 3),
(6, 3, 101, 5),
(7, 3, 103, 7),
(8, 3, 104, 2),
(9, 4, 101, 5),
(10, 4, 102, 3),
(11, 4, 103, 7);


WITH FullScoreCounts AS (
    SELECT hacker_id, COUNT(DISTINCT s.challenge_id) AS num_full_scores
    FROM Submissions s
    JOIN Difficultytable d ON s.challenge_id = d.challenge_id
    WHERE s.score = d.difficulty_level
    GROUP BY hacker_id
    HAVING COUNT(DISTINCT s.challenge_id) > 1
)

SELECT h.hacker_id, h.name
FROM Hackertable h
JOIN FullScoreCounts f ON h.hacker_id = f.hacker_id
ORDER BY f.num_full_scores DESC, h.hacker_id ASC;


----------------------------------

SELECT h.hacker_id, h.name
FROM Hackertable h
JOIN (
    SELECT s.hacker_id, COUNT(DISTINCT s.challenge_id) AS num_full_scores
    FROM Submissions s
    JOIN Difficultytable d ON s.challenge_id = d.challenge_id
    WHERE s.score = d.difficulty_level
    GROUP BY s.hacker_id
    HAVING COUNT(DISTINCT s.challenge_id) > 1
) AS full_scores ON h.hacker_id = full_scores.hacker_id
ORDER BY full_scores.num_full_scores DESC, h.hacker_id ASC;



---------------------------------------------------------------------

----------------------------------------5-----------------

CREATE TABLE Wands (
    id INT PRIMARY KEY,
    code INT,
    coins_needed INT,
    [power] INT
);

CREATE TABLE Wands_Property (
    code INTEGER PRIMARY KEY,
    age INTEGER,
    is_evil INTEGER
);

INSERT INTO Wands (id, code, coins_needed, power) VALUES
(1, 4, 3688, 8),
(2, 3, 9365, 3),
(3, 3, 7187, 10),
(4, 3, 734, 8),
(5, 1, 6020, 2),
(6, 2, 6773, 7),
(7, 3, 9873, 9),
(8, 3, 7721, 7),
(9, 1, 1647, 10),
(10, 4, 504, 5),
(11, 2, 7587, 5),
(12, 5, 9897, 10),
(13, 3, 4651, 8),
(14, 2, 5408, 1),
(15, 2, 6018, 7),
(16, 4, 7710, 5),
(17, 2, 8798, 7),
(18, 2, 3312, 3),
(19, 4, 7651, 6),
(20, 5, 5689, 3);



INSERT INTO Wands_Property (code, age, is_evil) VALUES
(1, 45, 0),
(2, 40, 0),
(3, 4, 1),
(4, 20, 0),
(5, 17, 0);
SELECT 
    w.id, 
    wp.age, 
    w.coins_needed, 
    w.[power]
FROM 
    Wands w
JOIN 
    Wands_Property wp ON w.code = wp.code
WHERE 
    wp.is_evil = 0
ORDER BY 
    w.[power] DESC, 
    wp.age DESC;

	----------------
WITH WandsWithProperty AS (
    SELECT 
        w.id, 
        w.code, 
        w.coins_needed, 
        w.power, 
        wp.age
    FROM 
        Wands w
    JOIN 
        Wands_Property wp ON w.code = wp.code
    WHERE 
        wp.is_evil = 0
)
SELECT 
    id, 
    age, 
    coins_needed, 
    power
FROM 
    WandsWithProperty
ORDER BY 
    power DESC, 
    age DESC;


-----------------------------------6-----------------------------------------

CREATE TABLE Hackers (
    hacker_id INT PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE Submissions (
    submission_id INT PRIMARY KEY,
    hacker_id INT,
    challenge_id INT,
    score INT,
    FOREIGN KEY (hacker_id) REFERENCES Hackers(hacker_id)
);

INSERT INTO Hackers VALUES
(4071, 'Rose'),
(4806, 'Angela'),
(26071, 'Frank'),
(49438, 'Patrick'),
(74842, 'Lisa'),
(80305, 'Kimberly'),
(84072, 'Bonnie'),
(87868, 'Michael'),
(92118, 'Todd'),
(95895,'Joe');

INSERT INTO Submissions (submission_id, hacker_id, challenge_id, score) VALUES
(67194, 74842, 63132, 76),
(64479, 74842, 19797, 98),
(40742, 26071, 49593, 20),
(17513, 4806, 49593, 32),
(69846, 80305, 19797, 19),
(41002, 26071, 89343, 36),
(52826, 49438, 49593,9),
(31093, 26071, 19797, 2),
(81614, 84072, 49593, 100),
(44829, 26071, 89343, 17),
(75147, 80305, 49593, 48),
(14115, 4806, 49593,76),
(6943, 4071, 19797, 95),
(12855, 4806, 25917, 13),
(73343, 80305, 49593, 42),
(84264, 84072, 63132,0),
(9951, 4071, 49593, 43),
(45104, 49438, 25917, 34),
(53795, 74842, 19797,5),
(26363, 26071, 19797, 29),
(10083, 4071, 49593, 96);
WITH max_scores AS (
    SELECT
        hacker_id,
        challenge_id,
        MAX(score) AS max_score
    FROM
        Submissions
    WHERE
        score > 0
    GROUP BY
        hacker_id,
        challenge_id
)
SELECT
    h.hacker_id,
    h.name,
    COALESCE(SUM(ms.max_score), 0) AS total_score
FROM
    Hackers h
JOIN
    max_scores ms ON h.hacker_id = ms.hacker_id
GROUP BY
    h.hacker_id,
    h.name
ORDER BY
    total_score DESC,
    h.hacker_id ASC;

	--------------------------

SELECT
    h.hacker_id,
    h.name,
    COALESCE(SUM(max_scores.max_score), 0) AS total_score
FROM
    Hackers h
JOIN (
    SELECT
        hacker_id,
        challenge_id,
        MAX(score) AS max_score
    FROM
        Submissions
    WHERE
        score > 0
    GROUP BY
        hacker_id,
        challenge_id
) AS max_scores ON h.hacker_id = max_scores.hacker_id
GROUP BY
    h.hacker_id,
    h.name
ORDER BY
    total_score DESC,
    h.hacker_id ASC;
-------------------------------------------------------------------------

 
 --------------------------- 7 ------------------------------------------------
create table orders(ord_no int,purch_amt decimal(10,2),ord_date date,cust_id int,salesman_id int);
insert into orders values(70001,150.5,'2012-10-05',3005,5002);
insert into orders values(70009,270.65,'2012-09-10',3001,5005);
insert into orders values(70002,65.26,'2012-10-05',3002,5001);
insert into orders values(70004,110.5,'2012-08-17',3009,5003);
insert into orders values(70007,948.5,'2012-09-10',3005,5002);
insert into orders values(70005,2400.6,'2012-07-27',3007,5001);
insert into orders values(70008,5760,'2012-09-10',3002,5001);
insert into orders values(70010,1983.43,'2012-10-10',3004,5006);
insert into orders values(70003,2840.4,'2012-10-10',3009,5003);
insert into orders values(70012,250.45,'2012-06-27',3008,5002);
insert into orders values(70011,75.29,'2012-08-17',3003,5007);
insert into orders values(70013,3045.6,'2012-04-25',3002,5001);
SELECT ord_date, SUM(purch_amt) AS total_amount
FROM orders
GROUP BY ord_date
HAVING SUM(purch_amt) >= MAX(purch_amt) + 1000.00;

SELECT ord_date, total_amount
FROM (
    SELECT ord_date, SUM(purch_amt) AS total_amount, MAX(purch_amt) AS max_amount
    FROM orders
    GROUP BY ord_date
) AS date_totals
WHERE total_amount >= max_amount + 1000.00;


	

------------------------------------- 8 ----------------------------------------------------------
create table emp_department(
dpt_code int
, dpt_name varchar(20)
, dpt_allotment int
,  primary key(dpt_code))
insert into emp_department values
( 57,'IT',65000),
(63,'Finance',15000),
(47,'HR', 240000),
(27,'RD', 55000),
(89,'QC',75000)
create table emp_details(
emp_idno int,
emp_fname varchar(20),
emp_lname varchar(20),
emp_dept int,
foreign key(emp_dept) references emp_department(dpt_code))
insert into emp_details values
(127323,'Michale','Robbin',57)
,(526689,'Carlos','Snares',63),
(843795, 'Enric', 'Dosio', 57),
(328717, 'Jhon', 'Snares', 63),
(444527, 'Joseph', 'Dosni', 47),
(659831, 'Zanifer', 'Emily', 47),
(847674, 'Kuleswar', 'Sitaraman', 57),
(748681, 'Henrey', 'Gabriel', 47),
(555935, 'Alex', 'Manuel', 57),
(539569, 'George', 'Mardy', 27),
(733843, 'Mario', 'Saule', 63),
(631548, 'Alan', 'Snappy', 27),
(839139, 'Maria', 'Foster', 57);
select emp_department.dpt_name,emp_details.emp_fname,emp_details.emp_lname 
from emp_department 
join emp_details
on emp_department.dpt_code=emp_details.emp_dept 
where emp_department.dpt_allotment=(select min(dpt_allotment) 
from emp_department 
where dpt_allotment not in (select min(dpt_allotment) from emp_department));
----------------------------
select dpt_name,emp_fname,emp_lname from 
(select emp_department.dpt_name, emp_details.emp_fname, emp_details.emp_lname,
DENSE_RANK() OVER (ORDER BY emp_department.dpt_allotment) AS rank_number 
FROM emp_department JOIN emp_details 
ON emp_department.dpt_code = emp_details.emp_dept) as remp where rank_number=2;

