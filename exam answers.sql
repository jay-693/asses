 -- 7
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


--6

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


	--5

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
