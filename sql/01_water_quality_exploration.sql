#listing out all the tables in the database.
SHOW TABLES;

#Retrieving first five records from the location table.
SELECT *
FROM location
LIMIT 5;

#Retrieving first five records from the visits table.
SELECT *
FROM visits
LIMIT 5;

#Retrieving first five records from the employee table.
SELECT *
FROM employee
LIMIT 5;

#Retrieving first five records from the water_quality table.
SELECT *
FROM water_quality
LIMIT 5;

-- Retrieve the first five records from the location table.
SELECT *
FROM location
LIMIT 5;

-- Retrieve the first five records from the visits table.
SELECT *
FROM visits
LIMIT 5;

-- Retrieve the first five records from the water_source table.
SELECT *
FROM water_source
LIMIT 5;

-- Retrieve the first five records from the well_pollution table.
SELECT *
FROM well_pollution
LIMIT 5;

-- Retrieve the first five records from the global_water_access table.
SELECT *
FROM global_water_access
LIMIT 5;

-- Retrieve the first five records from the data_dictionary table
-- to understand the columns and structure of the database.
SELECT *
FROM data_dictionary
LIMIT 5;

#Finding all the unique types of water sources.
SELECT DISTINCT type_of_water_source
FROM water_source;

#Retrieving record from table where time in queue greater than 500 min.
SELECT *
FROM visits 
WHERE time_in_queue > 500;


#retrieving records from table where subject quality score is 10 and visit count is greater than 1. 
SELECT *
FROM water_quality
WHERE subjective_quality_score = 10
AND visit_count > 1;

#To check if biological column is greater than 0.01 but result is Clean.
SELECT *
FROM well_pollution
WHERE biological > 0.01 AND results = 'Clean';

UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';
