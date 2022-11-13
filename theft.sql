--creating view and storing the suspects according to clue of their location and date
CREATE VIEW suspect AS
SELECT * FROM vehicle_location_histories
WHERE 
city = 'new york' 
AND lat BETWEEN -74.997 AND -74.9968 
AND long BETWEEN 40.5 AND 40.6
AND "public"."vehicle_location_histories"."timestamp"::date = '2020-06-23'::date;


--finding out distinct name of the user according to thier vehicle id
SELECT DISTINCT r.vehicle_id, u.name AS "Owner Name" FROM suspect AS s
JOIN rides AS r ON s.ride_id = r.id
JOIN vehicles AS v ON v.id = r.vehicle_id
JOIN users AS u ON u.id = v.owner_id;

--selecting all rider names as the vehicle owner wasn't guilty
SELECT DISTINCT r.vehicle_id, r.rider_id, u.name AS "rider Name" FROM suspect AS s
JOIN rides AS r ON s.ride_id = r.id
--join vehicles as v on v.id = r.vehicle_id
JOIN users AS u ON u.id = r.rider_id;


--creating a view that has names of the rider
CREATE VIEW sus_name AS
SELECT DISTINCT  
 split_part( u.name,' ', 1) AS "first_name",
 split_part( u.name,' ', 2) AS "last_name"
FROM suspect AS s
JOIN rides AS r ON s.ride_id = r.id
JOIN users AS u ON u.id = r.rider_id;


--SELECT * from sus_name

--To create extension dblink
CREATE EXTENSION dblink;

--compare 2 table to find the culprit
SELECT *
FROM dblink('host=localhost user=postgres password=postgres dbname=Employees', 'SELECT first_name,last_name FROM employees;') 
AS t1(first_name NAME, last_name NAME) 

