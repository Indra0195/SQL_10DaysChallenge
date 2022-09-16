/* 	<<< QL Internship - 10 Days Challenge : Aug-Sep 2022 >>>	*/

CREATE 
	Database SQL_Internship;

USE 
	SQL_Internship;

/* 	< Day 1 : 29.08.2022 >
	Referring to the Zomato Case Study comprising of two datasets: Find the Top Countries with the 4.9 rating businesses. 
	Output the Country Name along with the number of '4.9' Rating businesses and order records by the City names in Descending Order. 
	In case there are two countries with the same result, sort them in alphabetical order. 
*/

CREATE 
	Table Zomato_data (
	RestaurantID INT PRIMARY KEY
,	RestaurantName TEXT
,	CountryCode INT REFERENCES Country_details(`Country Code`)
,	City VARCHAR(50)
,	Address TEXT
,	Locality TEXT
,	LocalityVerbose TEXT
,	Longitude INT
,	Latitude INT
,	Cuisines TEXT
,	Currency VARCHAR(100)
,	Has_Table_booking CHAR(20)
,	Has_Online_delivery	CHAR(20)
,	Is_delivering_now CHAR(20)
,	Switch_to_order_menu CHAR(20)
,	Price_range	INT
,	Votes INT
,	Average_Cost_for_two INT
,	Rating DECIMAL(2,1)
)	DEFAULT CHARSET = latin2;

DESCRIBE 
	Zomato_data;

CREATE 
	Table Country_details (
    `Country Code` INT PRIMARY KEY
,	Country CHAR(30)
);

DESCRIBE 
	Country_details;

SELECT *
	From Zomato_data
    LIMIT 5;

SELECT *
	From Country_details;

SELECT c.Country, z.city, Count(*) AS RatingCount FROM Zomato_data z, Country_details c 
WHERE z.CountryCode = c.`Country Code` AND z.Rating = 4.9 
AND c.Country IN (WITH CTE AS 
					(SELECT Country, Count, Rank()over (order by Count DESC) as TOPn 
						FROM (SELECT c.Country, COUNT(*) as Count
								FROM Zomato_data z, Country_details c
								WHERE z.CountryCode = c.`Country Code` AND z.Rating = 4.9
								GROUP BY c.Country
								ORDER BY 2 DESC) AS TT)
					SELECT Country FROM CTE WHERE TOPn = 1)
GROUP BY z.City
ORDER BY 1, 2 DESC;



/* 	< Day 2 : 31.08.2022 >
Ivy Pro School wants you to work on a Project data that has a table. The table has three columns-Task_ID,Start_Date and End_Date.
It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
If the End_Date of the tasks are consecutive, then they are part of the same project. Ivy is interested in finding the total number of different projects completed.
 Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order.
 If there is more than one project that have the same number of completion days, then order by the start date of the project. 
*/

USE 
	SQL_Internship;
    
CREATE 
	TABLE Project_data (
    Task_ID INT 
,	`Start Date` CHAR(50)
,	`End Date` CHAR(50)
);	
	
SELECT *
	FROM Project_data;

ALTER 
	Table Project_data
ADD 
	Column Start_Date DATE,
ADD 
	Column End_Date DATE;

SET 
	SQL_SAFE_UPDATES = 0;

UPDATE 
	Project_data
SET 
	Start_Date = str_to_date(`Start Date`, "%d-%m-%Y"),
	End_Date = str_to_date(`End Date`, "%d-%m-%Y");

ALTER 
	Table Project_data
DROP 
	Column `Start Date`,
DROP 
	Column `End Date`;

SELECT Start_Date, EndDt 
	FROM (SELECT SD.Start_Date, Min(ED.End_Date) AS EndDt
			   FROM (SELECT Start_Date 
						FROM Project_Data 
						WHERE Start_Date NOT IN (SELECT End_Date FROM Project_data)) AS SD,
					(SELECT End_Date 
						FROM Project_data
						WHERE End_Date NOT IN (SELECT Start_Date FROM Project_data)) AS ED
			   WHERE Start_Date < End_Date
			   GROUP BY SD.Start_date) AS TT1
	ORDER BY DATEDIFF(EndDt, Start_Date), Start_Date;



/* 	< Day 3 : 02.09.2022 >
There are two tables-Customers and Orders.

Table Customers:
+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| customer_id         | int     |
| customer_name       | varchar |
+---------------------+---------+
Customer_Id is the Primary key for this table. Customer_Name is the name of the customer.

Table Orders:
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_name  | varchar |
+---------------+---------+
Order_Id is the Primary key for this table. Customer_Id is the id of the customer who bought the product "product_name".

Write an SQL query :
- To report the Id and Names of customers who bought products “C”, “B” but did not buy the product “A” since we want to recommend them buy this product.
- Return the result table ordered by Customer_Id.
*/

USE 
	SQL_Internship;

CREATE 
	TABLE Customers (
    Customer_ID INT PRIMARY KEY
,	Customer_Name VARCHAR(50)
);	

CREATE 
	TABLE Orders (
    Order_ID INT PRIMARY KEY
,   Customer_ID INT REFERENCES Customers(Customer_ID)
,	Product_Name VARCHAR(20)
);	

SELECT *
	FROM Customers;

SELECT *
	FROM Orders;

SELECT *
	FROM Customers
	WHERE Customer_ID IN
		(SELECT DISTINCT Customer_ID
		 FROM Orders
		 WHERE Product_Name = "C") AND
		 Customer_ID IN
		(SELECT DISTINCT Customer_ID
		 FROM Orders
		 WHERE Product_Name = "B") AND
		 Customer_ID NOT IN
		(SELECT DISTINCT Customer_ID
		 FROM Orders
		 WHERE Product_Name = "A") 
	ORDER BY Customer_ID ASC;
    
    
    
/* 	< Day 4 : 04.09.2022 >
You are given a Sequence Table:

+--------+-------+----------+
| Sl No. | Group | Sequence |
+--------+-------+----------+
| 	1    | 	 A   | 	   1    |
+--------+-------+----------+
| 	2    | 	 A   | 	   2    |
+--------+-------+----------+
| 	3    | 	 A   | 	   3    |
+--------+-------+----------+
| 	4    | 	 A   | 	   5    |
+--------+-------+----------+
| 	5    | 	 A   | 	   6    |
+--------+-------+----------+
| 	6    | 	 A   | 	   8    |
+--------+-------+----------+
| 	7    | 	 A   | 	   9    |
+--------+-------+----------+
| 	8    | 	 B   | 	   11   |
+--------+-------+----------+
| 	9    | 	 C   | 	   1    |
+--------+-------+----------+
|   10   | 	 C   | 	   2    |
+--------+-------+----------+
| 	11   | 	 C   | 	   3    |
+--------+-------+----------+

 Using the exact table :
Write a SQL query to find the maximum and minimum values of continuous ‘Sequence’ in each ‘Group’.
*/

USE 
	SQL_Internship;

CREATE 
	TABLE GrpSeq_Data (
    `Sl No.` INT UNIQUE
,	`Group` VARCHAR(10)
,	Sequence INT
);	

SELECT *
	FROM GrpSeq_Data;
    
SELECT  
	`Group`
,	MIN(Sequence) Min_Seq
,   MAX(Sequence) Max_Seq
	FROM (
		SELECT
			`Group`
		,	Sequence
		,	Sequence - ROW_NUMBER() OVER (PARTITION BY `Group` 
											ORDER BY Sequence) Grp_Split
			FROM GrpSeq_Data
		) AS tt1
	GROUP BY `Group`, Grp_Split;



/* 	< Day 5 : 06.09.2022 >
You are given three tables: Students, Friends and Packages. 

Students contains two columns: ID and Name. 
Table Students:
+-----------------------+
| Column Name |  Type   |
+-----------------------+
| ID          | integer |
| Name        | String  |
+-----------------------+

Friends contains two columns: ID and Friend_ID (ID of the ONLY friend). 
Table Friends:
+-----------------------+
| Column Name |  Type   |
+-----------------------+
| ID          | integer |
| Friend_ID   | integer |
+-----------------------+

Packages contains two columns: ID and Salary (offered salary in $ thousands per month)
Table Packages:
+-----------------------+
| Column Name |  Type   |
+-----------------------+
| ID          | integer |
| Salary      | Float   |
+-----------------------+
Write a query to output the names of those students whose friends got offered a higher salary than them. 
Names must be ordered by the salary amount offered to the friends. It is guaranteed that no two students got same salary offer.
*/

USE 
	SQL_Internship;

CREATE 
	TABLE Students (
    ID INT PRIMARY KEY
,	`Name` VARCHAR(20)
);	

CREATE 
	TABLE Friends (
    ID INT REFERENCES Students(ID)
,   Friend_ID INT PRIMARY KEY
);	

CREATE 
	TABLE Packages (
    ID INT REFERENCES Friends(Friend_ID)
,	Salary FLOAT
);	
    
INSERT 
	INTO Students (ID, `Name`)
	VALUES
		(1, 'Ashley')
	,	(2, 'Samantha')
    ,	(3, 'Julia')
    ,	(4, 'Scarlet');

INSERT 
	INTO Friends (ID, Friend_ID)
	VALUES
		(1, 2)
	,	(2, 3)
    ,	(3, 4)
    ,	(4, 1);
    
INSERT 
	INTO Packages (ID, Salary)
	VALUES
		(1, 15.20)
	,	(2, 10.06)
    ,	(3, 11.55)
    ,	(4, 12.12);
    
SELECT *
	FROM Students;

SELECT *
	FROM Friends;
    
SELECT *
	FROM Packages;

SELECT s.`Name` 
	FROM Students s 
	JOIN Friends f
	,	Packages p 
	WHERE s.ID = f.ID AND 
		f.Friend_ID = p.ID AND 
		p.Salary > (SELECT p1.Salary 
						FROM Packages p1 
						WHERE p1.ID = s.ID) 
	ORDER BY p.Salary;
  
  
  
/* 	< Day 6 : 08.09.2022 >
Write a query to print the sum of total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for the policy holders who meet the following criteria: 
1.Have the same TIV_2015 value as one or more other policyholders.
2. Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique). 
Input Format: The insurance table is described as follows:
+-----------------------------+
| Column Name |   Type        |
+-----------------------------+
|PID		  |	INT(11)   	  |
|TIV_2015     |	NUMERIC(15,2) |
|TIV_2016     |	NUMERIC(15,2) |
|LAT		  |	NUMERIC(5,2)  |
|LON		  |	NUMERIC(5,2)  |
+-----------------------------+
where PID is the policyholder’s policy ID, TIV_2015 is the total investment value in 2015, TIV_2016 is the total investment value in 2016, 
LAT is the latitude of the policy holder’s city, and LON is the longitude of the policy holder’s city
*/

USE 
	SQL_Internship;
    
CREATE 
	TABLE Insurance (
	PID INT
,	TIV_2015 NUMERIC(15,2)
, 	TIV_2016 NUMERIC(15,2)
,	LAT NUMERIC(5,2)
,	LON NUMERIC(5,2)
);

INSERT 
	INTO Insurance
		(PID, TIV_2015, TIV_2016, LAT, LON) 
    VALUES
		(1, 10, 5, 10, 10)
	,	(2, 20, 20, 20, 20)
    ,	(3, 10, 30, 20, 20)
    ,	(4, 10, 40, 40, 40);
    
SELECT *
	FROM Insurance;

SELECT 
	SUM(ip.TIV_2016) AS `Sum of TIV_2016`
	FROM Insurance ip
	WHERE ip.TIV_2015 IN
	(SELECT 
		TIV_2015 
        FROM Insurance
		GROUP BY TIV_2015 
		HAVING COUNT(*) > 1
	) AND CONCAT(LAT,LON) IN
	(SELECT 
		CONCAT(LAT,LON) 
		FROM Insurance
		GROUP BY LAT, LON
		HAVING COUNT(*) = 1
	);
    
    
    
/* 	< Day 7 : 10.09.2022 >
Table Name: Marks_Data
+-------------------------+
 Col_name       Type     
+-------------------------+
 student_id		int
 subject		string
 marks			int
+-------------------------+

Input Table:
+--------------------------------+
student_id		subject		marks
+--------------------------------+
1001			English		88
1001			Science		90
1001			Maths		85
1002			English		70
1002			Science		80
1002			Maths		83
+--------------------------------+
Problem Statement:
Reproduce the Table into given format below:

Output:
+-----------------------------------------+
student_id	English		Science		Maths
+-----------------------------------------+
1001			88			90		  85
1002			70			80		  83
+-----------------------------------------+
*/

USE 
	SQL_Internship;
    
CREATE 
	TABLE Marks_Data (
	student_id INT
,	`subject` VARCHAR(20)
, 	marks INT
);

INSERT 
	INTO Marks_Data
		(student_id, `subject`, marks) 
    VALUES
		(1001, 'English', 88)
	,	(1001, 'Science', 90)
	,	(1001, 'Maths', 85)
    ,	(1002, 'English', 70)
    ,	(1002, 'Science', 80)
    ,	(1002, 'Maths', 83);
    
SELECT *
	FROM Marks_Data;
    
SELECT 
	student_id
,	MAX(CASE WHEN `subject` = 'English' THEN marks ELSE 0 END) AS English
,	MAX(CASE WHEN `subject` = 'Science' THEN marks ELSE 0 END) AS Science
,	MAX(CASE WHEN `subject` = 'Maths' THEN marks ELSE 0 END) AS Maths
	FROM Marks_Data
	GROUP BY student_id
	ORDER BY 1;
    
    

/* 	< Day 8_1 : 12.09.2022 >
Use the Cabs Dataset and answer the following question:
Write a query to return the number of good days and bad days in May 2020 based on number of daily rentals.
Return the results in one row with 2 columns from left to right: good_days, bad_days.
good day: > 100 rentals.
bad day: <= 100 rentals.

Table: rental
   col_name   | col_type
--------------+--------------------------
 rental_id    | integer
 rental_ts    | timestamp with time zone
 inventory_id | integer
 customer_id  | smallint
 return_ts    | timestamp with time zone
 staff_id     | smallint

Sample results:
good_days | bad_days
-----------+----------
         7 |       24
*/

USE 
	SQL_Internship;
    
CREATE 
	TABLE Rental (
	rental_id INT
,   rental_ts CHAR(50)
,	inventory_id INT
,	customer_id SMALLINT
,   return_ts CHAR(50)
,	staff_id SMALLINT
);

SELECT *
	FROM Rental;

ALTER 
	Table Rental
ADD 
	Column `Rental ts` DATETIME,
ADD 
	Column `Return ts` DATETIME;

SET 
	SQL_SAFE_UPDATES = 0;

UPDATE 
	Rental
SET 
	`Rental ts` = str_to_date(rental_ts, "%m/%d/%Y %H:%i"),
	`Return ts` = str_to_date(return_ts, "%m/%d/%Y %H:%i");

ALTER 
	Table Rental
DROP 
	Column rental_ts,
DROP 
	Column return_ts;

WITH daily_rentals AS (
SELECT
	DATE(`Rental ts`) AS dt
,	COUNT(*) AS num_rentals
	FROM Rental
	WHERE DATE(`Rental ts`) >= '2020-05-01'
		AND DATE(`Rental ts`) <= '2020-05-31'
	GROUP BY dt
	)
SELECT
	SUM(CASE WHEN num_rentals > 100 THEN 1 ELSE 0 END) AS good_days,
	31 - SUM(CASE WHEN num_rentals > 100 THEN 1 ELSE 0 END) AS bad_days
	FROM daily_rentals;
   


/* 	< Day 8_2 : 12.09.2022 >
Table: 
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id is the primary key column for this table.
This table has the information about all people waiting for an elevator.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table
The maximum weight the elevator can hold is 1000.

Write an SQL query to find the person_name of the last person who will fit in the elevator without exceeding the weight limit.
It is guaranteed that the person who is first in the Queue can fit in the elevator.

The query result format is in the following example:
Queue table:
+-----------+-------------------+--------+------+
| person_id | person_name       | weight | turn |
+-----------+-------------------+--------+------+
| 5         | George Washington | 250    | 1    |
| 3         | John Adams        | 350    | 2    |
| 6         | Thomas Jefferson  | 400    | 3    |
| 2         | Will Johnliams    | 200    | 4    |
| 4         | Thomas Jefferson  | 175    | 5    |
| 1         | James Elephant    | 500    | 6    |
+-----------+-------------------+--------+------+
Result table:
+-------------------+
| person_name       |
+-------------------+
| Thomas Jefferson  |
+-------------------+
*/

USE 
	SQL_Internship;
    
CREATE 
	TABLE Queue (
	person_id INT
,   person_name VARCHAR(30)
,	weight INT
,	turn INT
);

INSERT
	INTO Queue
		(person_id, person_name, weight, turn)
	VALUES
		(5,'George Washington',250,1)
	,	(3,'John Adams',350,2)
	,	(6,'Thomas Jefferson',400,3)
	,	(2,'Will Johnliams',200,4)
	,	(4,'Thomas Jefferson',175,5)
	,	(1,'James Elephant',500,6);

SELECT *
	FROM Queue;

SELECT 
	person_name 
FROM 
	Queue q
WHERE (SELECT 
			SUM(weight)
		FROM 
			Queue 
		WHERE 
			turn <= q.turn
	  ) <= 1000
ORDER BY 
	turn DESC 
LIMIT 1;



/* 	< Day 9 : 14.09.2022 >
Table: Activity
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
We define the install date of a player to be the first login day of that player.
We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X,
divided by the number of players whose install date is X, rounded to 2 decimal places.
Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.
The query result format is in the following example:
Sample Input
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+
Sample Output:
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Explanation:
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00
*/

USE 
	SQL_Internship;

CREATE 
	TABLE Activity (
    player_id INT
,	device_id INT
,	event_date DATE
,	games_played INT
);

INSERT 
	INTO Activity
		(player_id, device_id, event_date, games_played)
	VALUES
		(1, 2, '2016-03-01', 5)
	,	(1, 2, '2016-03-02', 6)
	,	(2, 3, '2017-06-25', 1)
	,	(3, 1, '2016-03-01', 0)
	,	(3, 4, '2016-07-03', 5);

SELECT *
	FROM Activity;
    
SELECT 
	install_dt 
,	COUNT(player_id) AS installs 
,	ROUND(COUNT(nxt_dt) / COUNT(*), 2) AS Day1_retention 
FROM (SELECT 
			tt1.player_id
      ,		tt1.install_dt 
      ,		tt2.event_date AS nxt_dt 
	  FROM (SELECT
					player_id
			,		MIN(event_date) AS install_dt 
			FROM Activity 
			GROUP  BY 1
			) AS tt1 
	   LEFT JOIN Activity AS tt2 
		 ON DATEDIFF(tt2.event_date, tt1.install_dt) = 1
			AND tt1.player_id = tt2.player_id
  	 ) AS tt 
GROUP  BY 1; 



/* 	< Day 10 : 16.09.2022 >
An IT Company interviews candidates using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions,
total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0 .
Note: A specific contest can be used to screen candidates at more than one college, but each college only holds screening contest.
Input Format
The following tables hold interview data:
Contests: The contest_id is the id of the contest, hacker_id is the id of the hacker who created the contest, and name is the name of the hacker.
Colleges: The college_id is the id of the college, and contest_id is the id of the contest that the company used to screen the candidates.
Challenges: The challenge_id is the id of the challenge that belongs to one of the contests whose contest_id the company forgot, and college_id is the id
	of the college where the challenge was given to candidates
View_Stats: The challenge_id is the id of the challenge, total_views is the number of times the challenge was viewed by candidates, and total_unique_views
	is the number of times the challenge was viewed by unique candidates.
Submission_Stats: The challenge_id is the id of the challenge, total_submissions is the number of submissions for the challenge, and total_accepted_submission
	is the number of submissions that achieved full scores.
*/

USE 
	SQL_Internship;

CREATE 
	TABLE Contests (
    contest_id INT PRIMARY KEY
,	hacker_id INT UNIQUE
,	`name` VARCHAR(20)
);

CREATE 
	TABLE Colleges (
    college_id INT PRIMARY KEY
,	contest_id INT REFERENCES Contests(contest_id)
);

CREATE 
	TABLE Challenges (
    challenge_id INT PRIMARY KEY
,	college_id INT REFERENCES Colleges(college_id)
);

CREATE 
	TABLE Views_Stats (
    challenge_id INT REFERENCES Challenges(challenge_id)
,	total_views INT
,	total_unique_views INT
);

CREATE 
	TABLE Submission_Stats (
    challenge_id INT REFERENCES Challenges(challenge_id)
,	total_submissions INT
,	total_accepted_submissions INT
);

SELECT * 
	FROM Contests;

SELECT * 
	FROM Colleges;
    
SELECT * 
	FROM Challenges;
    
SELECT * 
	FROM Views_Stats;

SELECT * 
	FROM Submission_Stats;

SELECT 
	con.contest_id
,	con.hacker_id
,	con.`name` 
,	IFNULL(SUM(sg.total_submissions), 0) AS `sum of total_submissions`
,	IFNULL(SUM(sg.total_accepted_submissions), 0) AS `sum of total_accepted_submissions`
,	IFNULL(SUM(vg.total_views), 0) AS `sum of total_views`
,	IFNULL(SUM(vg.total_unique_views), 0) AS `sum of total_unique_views`
FROM Contests con
JOIN Colleges clg 
	ON con.contest_id = clg.contest_id
JOIN Challenges cha 
	ON cha.college_id = clg.college_id
LEFT JOIN (SELECT 
				ss.challenge_id
			,	SUM(ss.total_submissions) AS total_submissions
			,	SUM(ss.total_accepted_submissions) AS total_accepted_submissions 
			FROM Submission_Stats ss 
			GROUP BY ss.challenge_id
		  ) AS sg
	ON cha.challenge_id = sg.challenge_id
LEFT JOIN (SELECT 
				vs.challenge_id
			,	SUM(vs.total_views) AS total_views
			,	SUM(vs.total_unique_views) AS total_unique_views
			FROM Views_Stats vs 
			GROUP BY vs.challenge_id
		  ) AS vg
	ON cha.challenge_id = vg.challenge_id
GROUP BY 
	con.contest_id
,	con.hacker_id
,	con.`name`
HAVING
	SUM(sg.total_submissions) > 0 OR
	SUM(sg.total_accepted_submissions) > 0 OR
	SUM(vg.total_views) > 0 OR
	SUM(vg.total_unique_views) > 0
ORDER BY con.contest_id;