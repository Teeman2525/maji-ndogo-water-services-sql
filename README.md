# Maji Ndogo Water Services | SQL Data Analysis

## Project Overview

This project explores the Maji Ndogo water services dataset to investigate water accessibility, water quality, employee survey activities, and queue waiting times.

Using MySQL, I performed data exploration, data cleaning, aggregation, and analytical queries to better understand the challenges surrounding access to water in the fictional community of Maji Ndogo.

The project is divided into two stages:

- **Project 1:** Data exploration and water quality investigation.
- **Project 2:** Employee performance, geographic distribution, water source accessibility, and queue analysis.

## Project Objectives

The objectives of this analysis were to:

1. Explore the database structure and understand the available data.
2. Identify inconsistencies in water quality records.
3. Investigate employee survey activities.
4. Analyze the distribution of water sources across communities.
5. Examine the population served by different water source types.
6. Investigate water collection waiting times.
7. Demonstrate practical SQL skills through a real-world-style analytical case study.

## Tools and Technologies

- **MySQL:** Data querying, cleaning, and analysis.
- **MySQL Workbench:** Database management and SQL execution.
- **GitHub:** Project documentation and version control.

## Dataset Description

The Maji Ndogo educational dataset contains information relating to water sources, survey visits, employees, locations, and water quality.

Key tables used include:

| Table | Description |
|---|---|
| `employee` | Employee details and assigned locations |
| `visits` | Survey visit records and waiting times |
| `location` | Geographic information about surveyed locations |
| `water_source` | Water source types and estimated populations served |
| `water_quality` | Recorded water quality assessments |
| `well_pollution` | Pollution test results for wells |

**Dataset note:** Maji Ndogo is a fictional educational case study. The records should not be interpreted as official government statistics.

## Project 1: Data Exploration and Water Quality Investigation

The first stage focused on understanding the database and investigating water quality information.

### Activities Performed

- Explored the available database tables.
- Retrieved sample records to understand table structures.
- Identified distinct water source types.
- Investigated survey visits with unusually long waiting times.
- Examined water quality assessments.
- Identified potentially inconsistent well pollution records.
- Applied targeted corrections to pollution descriptions.

### SQL Concepts Used

`SELECT`, `DISTINCT`, `WHERE`, `AND`, `LIMIT`, `UPDATE`

## Project 2: Water Access and Survey Analysis

The second stage extended the investigation into employee activities, location coverage, water accessibility, and waiting-time patterns.

### 1. Employee Data Cleaning and Analysis

- Generated standardized employee email addresses.
- Removed unnecessary spaces from phone numbers.
- Counted employees by town.
- Identified the three employees with the highest number of recorded survey visits.

### 2. Geographic Analysis

- Counted surveyed locations by town and province.
- Compared rural and urban location records.
- Calculated the percentage of surveyed locations classified as rural.

### 3. Water Source Analysis

- Counted water sources by type.
- Calculated the average and total number of people served by each source type.
- Calculated each source type's share of recorded people served.
- Ranked water source types and individual sources using SQL window functions.

### 4. Survey Duration Analysis

- Identified the earliest and latest recorded survey visits.
- Calculated the elapsed time between these records.

### 5. Queue Waiting-Time Analysis

- Analyzed average queue waiting times by water source type.
- Compared waiting times across weekdays.
- Investigated hourly waiting-time patterns.
- Used conditional aggregation to display hourly waiting times by day of the week.

## SQL Skills Demonstrated

- Data exploration and filtering
- Data cleaning using string functions
- Updating database records
- Table joins
- Aggregate functions: `COUNT()`, `SUM()`, `AVG()`
- Grouping and sorting
- Conditional logic using `CASE WHEN`
- Subqueries
- Window functions using `RANK()`
- Date and time functions
- Percentage calculations
- Conditional aggregation

## Repository Structure

```text
maji-ndogo-water-services-sql/
├── README.md
└── sql/
    ├── 01_water_quality_exploration.sql
    └── 02_water_access_analysis.sql
```

## How to Explore the Project

1. Set up a MySQL environment.
2. Obtain and import the Maji Ndogo educational dataset from an authorized source.
3. Open the SQL files in MySQL Workbench.
4. Review the comments explaining each analysis.
5. Execute the relevant queries and inspect the results.

**Important:** Some queries use `UPDATE` and permanently modify records. Review these statements and use a working copy of the database before executing them.

## Analytical Considerations

- Survey results describe the recorded dataset and should not automatically be generalized to an entire population.
- Population-served calculations reflect the values recorded against water sources and do not necessarily represent unique individuals.
- Queue analyses that exclude zero-minute waits describe waiting experiences among records with positive waiting times.
- Rankings based on people served do not automatically indicate which water sources are in the worst condition.
## Key Findings

### Water Source Distribution

The SQL analysis identified the following distribution of recorded people served across water source types:

| Water Source Type | People Served | Percentage |
|---|---:|---:|
| Shared tap | 11,945,272 | 43.24% |
| Well | 4,841,724 | 17.52% |
| Tap in home | 4,678,880 | 16.94% |
| Broken tap in home | 3,799,720 | 13.75% |
| River | 2,362,544 | 8.55% |

**Key observations:**

- Shared taps account for the largest share of recorded people served (43.24%), suggesting substantial reliance on communal water infrastructure.
- Wells account for 17.52% of recorded people served, representing the second-largest category.
- Broken home taps account for 13.75%, highlighting a potential infrastructure maintenance concern that warrants further investigation.
- Rivers account for 8.55%, suggesting that some communities depend on natural water sources.

**Business implication:** These findings can help guide further investigation into communal water access, infrastructure maintenance, and water source reliability.

*Note: Percentages represent shares of recorded people served across water source records, not necessarily unique individuals.*

## Future Improvements

- Develop a Power BI dashboard to visualize water accessibility and waiting-time patterns.
- Extend the analysis with additional business questions and geographic comparisons.
- Add verified findings and visual evidence from executed SQL queries.

## Acknowledgements

This project is based on the fictional Maji Ndogo educational case study associated with ExploreAI Academy. The SQL analysis and portfolio documentation were prepared as part of my data analytics learning journey.
