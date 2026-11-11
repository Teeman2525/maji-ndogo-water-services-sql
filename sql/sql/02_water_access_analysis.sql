-- MAJI NDOGO WATER SERVICES | SQL PROJECT 2
-- Purpose: Explore employee activity, geographic survey coverage,
-- water source access, survey timing, and queue waiting patterns.
-- Database: Maji Ndogo educational dataset (MySQL).
-- Notes: The script contains exploratory SELECT statements and two UPDATE
-- statements that permanently modify employee data. Review UPDATE statements
-- before executing the entire file. Results describe recorded survey data.

-- SECTION 1: EMPLOYEE DATA CLEANING
-- Preview replacing spaces in employee names with dots for email usernames.
SELECT 
	REPLACE (employee_name, ' ', '.')
FROM employee;

-- Preview converting the generated usernames to lowercase.
SELECT 
	LOWER(REPLACE (employee_name, ' ', '.'))
FROM employee;

-- Preview full employee email addresses using the organisation domain.
SELECT 
	CONCAT(LOWER(REPLACE (employee_name, ' ', '.')), '@ndogowater.gov') AS new_email 
FROM employee;

-- DATA CHANGE: Save generated email addresses to the employee table.
-- Review affected records before running this UPDATE on a shared database.
UPDATE employee 
SET email = CONCAT(LOWER(REPLACE (employee_name, ' ', '.')), '@ndogowater.gov');

-- Check the length of stored phone numbers to investigate inconsistent formatting.
SELECT 
	LENGTH(phone_number)
FROM employee;

-- DATA CHANGE: Remove leading and trailing spaces from stored phone numbers.
-- TRIM does not remove spaces between digits.
UPDATE employee
SET phone_number = TRIM(phone_number);

-- SECTION 2: EMPLOYEE ACTIVITY
-- Count employee records by their assigned town.
SELECT town_name, COUNT(*) AS NumberOfEmployees
FROM employee
GROUP BY town_name;

-- Identify the three employees with the most recorded survey visits.
-- Count visit records, not the visit_count field within each record.
SELECT
    e.assigned_employee_id,
    e.employee_name,
    COUNT(*) AS total_visits
FROM employee AS e
JOIN visits AS v
    ON e.assigned_employee_id = v.assigned_employee_id
GROUP BY
    e.assigned_employee_id,
    e.employee_name
ORDER BY total_visits DESC
LIMIT 3;

-- SECTION 3: LOCATION COVERAGE
-- Count surveyed location records by town.
SELECT town_name, COUNT(*) AS NumberOfRecords
FROM location
GROUP BY town_name;

-- Count surveyed location records by province.
SELECT province_name, COUNT(*) AS NumberOfRecords
FROM location
GROUP BY province_name;

-- Break down surveyed locations by province and town together.
SELECT province_name, town_name, COUNT(*) AS records_per_town
FROM location
GROUP BY province_name, town_name;

-- Compare the number of rural and urban location records.
SELECT location_type, COUNT(*) AS NumberOfRecords
FROM location
GROUP BY location_type;

-- Calculate the share of surveyed location records classified as rural.
-- This is a percentage of location records, not necessarily of residents.
SELECT
    ROUND(
        SUM(CASE WHEN location_type = 'Rural' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS rural_percentage
FROM location;

-- SECTION 4: WATER SOURCE ACCESS
-- Inspect the number of people served by each individual water source.
SELECT number_of_people_served
FROM water_source;

-- Count how many water source records exist for each source type.
SELECT type_of_water_source, count(type_of_water_source) AS NumberOfSources
FROM water_source
GROUP BY type_of_water_source;

-- Calculate the average number of people served per water source, by type.
SELECT type_of_water_source, round(avg(number_of_people_served)) AS Average_number_of_people_served
FROM water_source
GROUP BY type_of_water_source;

-- Calculate total recorded people served by each source type, highest first.
SELECT type_of_water_source, sum(number_of_people_served) AS TotalNumberOfPeopleServed
FROM water_source
GROUP BY type_of_water_source
ORDER BY  TotalNumberOfPeopleServed DESC;

-- Calculate each source type's share of all recorded people served.
-- The denominator is calculated dynamically rather than hardcoded.
SELECT
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served,
    ROUND(
        SUM(number_of_people_served) * 100.0 /
        (SELECT SUM(number_of_people_served) FROM water_source),
        2
    ) AS percentage_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY percentage_served DESC;

-- Rank water source TYPES by their total recorded people served.
SELECT
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served,
    RANK() OVER (
        ORDER BY SUM(number_of_people_served) DESC
    ) AS source_rank
FROM water_source
GROUP BY type_of_water_source;

-- Rank source types excluding tap_in_home, to focus on alternative sources.
SELECT type_of_water_source, sum(number_of_people_served) AS TotalNumberOfPeopleServed, RANK() OVER(ORDER BY sum(number_of_people_served) DESC) AS SourceRank
FROM water_source
WHERE type_of_water_source != 'tap_in_home'
GROUP BY type_of_water_source;

-- Rank INDIVIDUAL water sources excluding tap_in_home.
SELECT source_id, type_of_water_source, number_of_people_served, 
RANK() OVER(ORDER BY(number_of_people_served) DESC) AS PrioritySourceRank
FROM water_source
WHERE type_of_water_source != 'tap_in_home';

-- SECTION 5: SURVEY TIMELINE
-- Find the number of days between the earliest and latest recorded visits.
-- This is the elapsed survey span, not a count of active workdays.
SELECT
    DATEDIFF(
        MAX(time_of_record),
        MIN(time_of_record)
    ) AS survey_duration_days
FROM visits;

-- SECTION 6: QUEUE WAITING TIMES
-- Compare average recorded queue time by water source type, excluding home taps.
-- Exclude zero-minute waits to match the daily and hourly queue analyses.
SELECT type_of_water_source, avg(time_in_queue) AS AverageTimeInQueue
FROM visits
JOIN water_source
ON visits.source_id = water_source.source_id
WHERE type_of_water_source != 'tap_in_home'
  AND time_in_queue > 0
GROUP BY type_of_water_source;

-- Calculate average waiting time for each day of the week.
-- Exclude zero-minute waiting records for consistency
-- with the hourly queue analysis.

SELECT
    DAYNAME(time_of_record) AS day_of_week,
    ROUND(AVG(time_in_queue), 0) AS average_wait_minutes
FROM visits
WHERE time_in_queue > 0
GROUP BY DAYNAME(time_of_record)
ORDER BY average_wait_minutes DESC;

-- EXPLORATORY STEP: Display Sunday waiting times by visit hour.
-- CASE returns NULL for other weekdays; positive waiting times only.
SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
DAYNAME(time_of_record),
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END AS Sunday
FROM visits
WHERE time_in_queue > 0;

-- FINAL REPORT: Pivot average positive queue time by hour and weekday.
-- AVG ignores NULL values generated for nonmatching weekdays.
-- Each column represents one weekday; each row represents an hour.
-- These averages exclude zero-minute waits.

SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day, -- Sunday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END
),0) AS Sunday, -- Monday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
ELSE NULL
END
),0) AS Monday, -- Tuesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
ELSE NULL
END
),0) AS Tuesday, -- Wednesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
ELSE NULL
END
),0) AS Wednesday, -- Thursday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
ELSE NULL
END
),0) AS Thursday, -- Friday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
ELSE NULL
END
),0) AS Friday, -- Saturday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
ELSE NULL
END
),0) AS Saturday
FROM visits
WHERE time_in_queue > 0
GROUP BY hour_of_day
ORDER BY hour_of_day;

