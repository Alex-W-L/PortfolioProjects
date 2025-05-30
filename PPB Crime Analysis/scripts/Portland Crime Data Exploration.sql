-- This document contains generalized exploration of data in various forms
-- Some of it is for the purposes of practicing SQL Queries
-- Some of it is for the purposes of organizing data to display in Tableau

SELECT *
FROM portfolioproject.portlandcrimedata
WHERE Address IS NOT NULL;

-- Categories of Offenses and the Offense Types
SELECT DISTINCT(OffenseCategory), OffenseType
FROM portfolioproject.portlandcrimedata
ORDER BY OffenseCategory;

-- Total Counts of Offense Categories for a given neighborhood
SELECT Neighborhood, COUNT(OffenseCategory)
FROM portfolioproject.portlandcrimedata
WHERE Neighborhood IS NOT NULL
GROUP BY Neighborhood
ORDER BY 2 DESC;

-- Counts of each OffenseCategory based on Neighborhood where at least 10 of those crimes have occurred
SELECT Neighborhood, OffenseCategory, COUNT(*) as CrimesOccurred
FROM portfolioproject.portlandcrimedata
WHERE Neighborhood IS NOT NULL 
GROUP BY Neighborhood, OffenseCategory
HAVING CrimesOccurred > 10
ORDER BY Neighborhood, CrimesOccurred DESC;

-- Counts of each OffenseCategory based on Neighborhood focused by Year 
SELECT Neighborhood, OffenseCategory, COUNT(*) as CrimesOccurred
FROM portfolioproject.portlandcrimedata
WHERE Neighborhood IS NOT NULL
	AND YEAR(OccurDate) = 2023
GROUP BY Neighborhood, OffenseCategory
HAVING CrimesOccurred > 10
ORDER BY Neighborhood, CrimesOccurred DESC;

-- Counts of each OffenseCategory based on Neighborhood focused by Year broken down by Month
SELECT Neighborhood, OffenseCategory, COUNT(*) as CrimesOccurred, MONTHNAME(OccurDate) as Month
FROM portfolioproject.portlandcrimedata
WHERE Neighborhood IS NOT NULL
	AND YEAR(OccurDate) = 2024
GROUP BY Neighborhood, OffenseCategory, MONTHNAME(OccurDate), MONTH(OccurDate) -- Need to include "MONTH(OccurDate)" here to order months correctly
ORDER BY Neighborhood, MONTH(OccurDate), CrimesOccurred DESC; -- Need to include "MONTH(OccurDate)" here to order months correctly

-- Counts of Crimes Occured in a given month by Offense Category, aggregated
SELECT OffenseCategory, COUNT(*) as CrimesOccurred, MONTHNAME(OccurDate) as Month
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
GROUP BY MONTHNAME(OccurDate), OffenseCategory, MONTH(OccurDate)
ORDER BY MONTH(OccurDate), CrimesOccurred DESC;

-- Counts of Crimes Occured in a given DayoftheYear by Offense Category, aggregated
SELECT OffenseCategory, COUNT(*) as CrimesOccurred, DATE_FORMAT(OccurDate, '%m-%d') as DayOfTheYear
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
GROUP BY OffenseCategory, DATE_FORMAT(OccurDate, '%m-%d')
ORDER BY DATE_FORMAT(OccurDate, '%m-%d'), CrimesOccurred DESC;

-- --------------------------------------------------------------------------------
-- Examining a few specific Zip codes/Neighborhoods
-- Examining Larceny in 97266
Select OffenseCategory, COUNT(*) as CrimeOccurred, Zipcode, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND Zipcode = 97266
GROUP BY OffenseCategory, Zipcode, YEAR(OccurDate)
ORDER BY YEAR(OccurDate);

-- Examining Larceny in Lents
Select OffenseCategory, COUNT(*) as CrimeOccurred, Neighborhood, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND Neighborhood = "Lents"
GROUP BY OffenseCategory, Neighborhood, YEAR(OccurDate)
ORDER BY YEAR(OccurDate);

-- Examining Larceny in 97217
Select OffenseCategory, COUNT(*) as CrimeOccurred, Zipcode, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND Zipcode = 97217
GROUP BY OffenseCategory, Zipcode, YEAR(OccurDate)
ORDER BY YEAR(OccurDate);

-- Examining Larceny in East Columbia
Select OffenseCategory, COUNT(*) as CrimeOccurred, Neighborhood, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND Neighborhood = "East Columbia"
GROUP BY OffenseCategory, Neighborhood, YEAR(OccurDate)
ORDER BY YEAR(OccurDate);

-- Examining Larceny in 97232
Select OffenseCategory, COUNT(*) as CrimeOccurred, Zipcode, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND Zipcode = 97232
GROUP BY OffenseCategory, Zipcode, YEAR(OccurDate)
ORDER BY YEAR(OccurDate);

-- Examining Larceny in Hollywood
Select OffenseCategory, COUNT(*) as CrimeOccurred, Neighborhood, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND Neighborhood = "Hollywood"
GROUP BY OffenseCategory, Neighborhood, YEAR(OccurDate)
ORDER BY YEAR(OccurDate);

-- Grouping the Neighborhoods Together
Select OffenseCategory, COUNT(*) as CrimeOccurred, Neighborhood, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND (Neighborhood = "Hollywood" OR Neighborhood = "East Columbia" OR Neighborhood = "Lents")
GROUP BY OffenseCategory, Neighborhood, YEAR(OccurDate)
ORDER BY Neighborhood, YEAR(OccurDate);

-- Grouping the Zips Together
Select OffenseCategory, COUNT(*) as CrimeOccurred, Zipcode, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND (Zipcode = 97232 OR Zipcode = 97217 OR Zipcode = 97266)
GROUP BY OffenseCategory, Zipcode, YEAR(OccurDate)
ORDER BY Zipcode, YEAR(OccurDate);

-- Organizing Neighborhood Larceny Data By Month
Select OffenseCategory, COUNT(*) as CrimeOccurred, Neighborhood, 
	DATE_FORMAT(OccurDate, '%Y-%M') as Date, MONTH(OccurDate) as Month, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND (Neighborhood = "Hollywood" OR Neighborhood = "East Columbia" OR Neighborhood = "Lents")
GROUP BY OffenseCategory, Neighborhood, DATE_FORMAT(OccurDate, '%Y-%M'), Month, Year
ORDER BY Neighborhood, Year, Month;

-- Organizing Zip Larceny Data By Month
Select OffenseCategory, COUNT(*) as CrimeOccurred, Zipcode, 
	DATE_FORMAT(OccurDate, '%Y-%M') as Date, MONTH(OccurDate) as Month, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE OffenseCategory = "Larceny Offenses"
	AND (Zipcode = 97232 OR Zipcode = 97217 OR Zipcode = 97266)
GROUP BY OffenseCategory, Zipcode, DATE_FORMAT(OccurDate, '%Y-%M'), Month, Year
ORDER BY Zipcode, Year, Month;

-- ------------------------------------------------------------------------------
-- Getting some practice in with subqueries and CTEs
-- Getting the Top 3 numberhoods with the highest number of offenses (subquery)
SELECT *
FROM (
	SELECT
		Neighborhood,
        YEAR(OccurDate) as Year,
        COUNT(*) as CrimesOccurred,
        RANK() OVER ( -- Applying a rank to each of the results
			PARTITION BY YEAR(OccurDate)
            ORDER BY COUNT(*) DESC -- Rank is ordered by the count of occurrances
        ) as NeighborhoodRank
	FROM portfolioproject.portlandcrimedata
    WHERE OffenseCategory = "Larceny Offenses"
		AND YEAR(OccurDate) >= 2015
        AND Neighborhood IS NOT NULL
	GROUP BY Neighborhood, YEAR(OccurDate)
) as RankedLarceny
WHERE NeighborhoodRank <= 3
ORDER BY Year, NeighborhoodRank;

-- Finding the most common OffenseCatergory by Zipcode (subquery)
SELECT * 
FROM (
	SELECT
		Zipcode,
        OffenseCategory,
        COUNT(*) as CrimesOccurred,
        RANK() OVER (
			PARTITION BY Zipcode
            ORDER BY COUNT(*) DESC
        ) as ZipcodeRanked
	FROM portfolioproject.portlandcrimedata
    WHERE Zipcode IS NOT NULL
    GROUP BY Zipcode, OffenseCategory
    HAVING CrimesOccurred > 5
) as RankedCrimes
WHERE ZipcodeRanked <= 1
ORDER BY CrimesOccurred DESC;

-- Most Common Crime Categories per year by Zipcode (CTE)
WITH RankedCrimesByYear as (
	SELECT 
		YEAR(OccurDate) as Year, 
        OffenseCategory, 
        Zipcode,
        COUNT(*) as CrimesOccurred,
		RANK() OVER (
			PARTITION BY YEAR(OccurDate), Zipcode
			ORDER BY COUNT(*) DESC
		) as CategoryRank
		FROM portfolioproject.portlandcrimedata
		WHERE OffenseCategory IS NOT NULL
			AND Zipcode IS NOT NULL
		GROUP BY YEAR(OccurDate), OffenseCategory, Zipcode
)

SELECT *
FROM RankedCrimesByYear
WHERE CategoryRank <= 5
	AND Year >= 2015
    AND CrimesOccurred > 10
ORDER BY Zipcode, Year, CategoryRank;

-- Most Common Crime Categories per year by Neighborhood (CTE)
WITH RankedCrimesByYear as (
	SELECT 
		YEAR(OccurDate) as Year, 
        OffenseCategory, 
        Neighborhood,
        COUNT(*) as CrimesOccurred,
		RANK() OVER (
			PARTITION BY YEAR(OccurDate), Neighborhood
			ORDER BY COUNT(*) DESC
		) as CategoryRank
		FROM portfolioproject.portlandcrimedata
		WHERE OffenseCategory IS NOT NULL
			AND Neighborhood IS NOT NULL
		GROUP BY YEAR(OccurDate), OffenseCategory, Neighborhood
)

SELECT *
FROM RankedCrimesByYear
WHERE CategoryRank <= 5
	AND Year >= 2015
    AND CrimesOccurred > 10
ORDER BY Neighborhood, Year, CategoryRank;

-- Zips with the most crime, the most common crimes per Zip and the percentage of that crime category based on
-- 	the total crime in that Zip
WITH TopZipcodes as (
	SELECT 
		Zipcode,
        COUNT(*) as CrimesOccurred,
        RANK() OVER (ORDER BY  COUNT(*) DESC) as ZipRank
	FROM portfolioproject.portlandcrimedata
    WHERE Zipcode IS NOT NULL
    GROUP BY Zipcode
), 
RankedCrimesByYear as (
	SELECT 
        OffenseCategory, 
        Zipcode,
        YEAR(OccurDate) as Year,
        COUNT(*) as CrimesOccurred,
		RANK() OVER (
			PARTITION BY  YEAR(OccurDate), Zipcode
			ORDER BY COUNT(*) DESC
		) as CrimeRank
		FROM portfolioproject.portlandcrimedata
		WHERE OffenseCategory IS NOT NULL
			AND Zipcode IS NOT NULL
		GROUP BY Year, Zipcode, OffenseCategory
)
-- 10 Zipcodes with the most crime and the 5 most common categoeries of crime in each zip
SELECT *, 
	(RankedCrimesByYear.CrimesOccurred / TopZipcodes.CrimesOccurred * 100) as PercentCrimeInZip
FROM TopZipcodes
LEFT JOIN RankedCrimesByYear
	ON TopZipcodes.zipcode = RankedCrimesByYear.zipcode
WHERE TopZipcodes.CrimesOccurred >= 10000
	AND CrimeRank <= 5
    AND Year >= 2015
ORDER BY Year, ZipRank, CrimeRank;

-- Neighborhood with the most crime, the most common crimes per Neighborhood
--  and the percentage of that crime category based on the total crime in that Neighborhood
WITH TopNeighborhoods as (
	SELECT 
		Neighborhood,
        COUNT(*) as CrimesOccurred,
        RANK() OVER (ORDER BY  COUNT(*) DESC) as NeighborhoodRank
	FROM portfolioproject.portlandcrimedata
    WHERE Neighborhood IS NOT NULL
    GROUP BY Neighborhood
), 
RankedCrimesByYear as (
	SELECT 
        OffenseCategory, 
        Neighborhood,
        YEAR(OccurDate) as Year,
        COUNT(*) as CrimesOccurred,
		RANK() OVER (
			PARTITION BY  YEAR(OccurDate), Neighborhood
			ORDER BY COUNT(*) DESC
		) as CrimeRank
		FROM portfolioproject.portlandcrimedata
		WHERE OffenseCategory IS NOT NULL
			AND Neighborhood IS NOT NULL
		GROUP BY Year, Neighborhood, OffenseCategory
)
-- 10 Zipcodes with the most crime and the 5 most common categoeries of crime in each zip
SELECT *, 
	(RankedCrimesByYear.CrimesOccurred / TopNeighborhoods.CrimesOccurred * 100) as PercentCrimeInZip
FROM TopNeighborhoods
LEFT JOIN RankedCrimesByYear
	ON TopNeighborhoods.Neighborhood = RankedCrimesByYear.Neighborhood
WHERE TopNeighborhoods.CrimesOccurred >= 10000
	AND CrimeRank <= 5
    AND Year >= 2015
ORDER BY Year, NeighborhoodRank, CrimeRank;

-- OffenseCategories Per Year by Zipcode
SELECT 
	Zipcode, 
    OffenseCategory,
    COUNT(*) as CrimesOccurred,
    YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE Zipcode IS NOT NULL
	AND YEAR(OccurDate) >= 2015
GROUP BY Year, Zipcode, OffenseCategory;

-- OffenseCategories Per Year by Neighborhood
SELECT 
	Neighborhood, 
    OffenseCategory,
    COUNT(*) as CrimesOccurred,
    YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE Neighborhood IS NOT NULL
	AND YEAR(OccurDate) >= 2015
GROUP BY Year, Neighborhood, OffenseCategory;

-- OffenseType Per Year by Zipcode
SELECT 
	Zipcode, 
    OffenseCategory,
    OffenseType,
    COUNT(*) as CrimesOccurred,
    YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE Zipcode IS NOT NULL
	AND YEAR(OccurDate) >= 2015
GROUP BY Year, Zipcode, OffenseCategory, OffenseType;

-- OffenseType Per Year by Neighborhood
SELECT 
	Neighborhood, 
    OffenseCategory,
    OffenseType,
    COUNT(*) as CrimesOccurred,
    YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE Neighborhood IS NOT NULL
	AND YEAR(OccurDate) >= 2015
GROUP BY Year, Neighborhood, OffenseCategory, OffenseType;

-- CrimesOccurring based on the hour (1 = 1:00am - 1:59am, etc)
SELECT 
    OccurHour,
    COUNT(*) as CrimesOccurred
FROM portfolioproject.portlandcrimedata
WHERE OccurHour IS NOT NULL
GROUP BY OccurHour
ORDER BY CrimesOccurred DESC;

-- CrimesOccurring based on the hour (1 = 1:00am - 1:59am, etc) in a given Zipcode
SELECT 
	Zipcode,
    OccurHour,
    COUNT(*) as CrimesOccurred
FROM portfolioproject.portlandcrimedata
WHERE OccurHour IS NOT NULL
	AND Zipcode IS NOT NULL
GROUP BY Zipcode, OccurHour
ORDER BY Zipcode, CrimesOccurred DESC;

-- CrimesOccurring based on the hour (1 = 1:00am - 1:59am, etc) in a given Neighborhood
SELECT 
	Neighborhood,
    OccurHour,
    COUNT(*) as CrimesOccurred
FROM portfolioproject.portlandcrimedata
WHERE OccurHour IS NOT NULL
	AND Neighborhood IS NOT NULL
GROUP BY Neighborhood, OccurHour
ORDER BY Neighborhood, CrimesOccurred DESC;

-- CrimesOccurring on a month to month basis for all available data
Select COUNT(*) as CrimeOccurred, 
	DATE_FORMAT(OccurDate, '%Y-%M') as Date, MONTH(OccurDate) as Month, YEAR(OccurDate) as Year
FROM portfolioproject.portlandcrimedata
WHERE YEAR(OccurDate) >= 2015
GROUP BY DATE_FORMAT(OccurDate, '%Y-%M'), Month, Year
ORDER BY Year, Month;

-- --------------------------------------------------------------------------------
-- Played around with groups of these data in Tableau to determine what I actually wanted to represent
-- and what data was necessary for that purpose. Ultimately decided to use exclusively zipcode data
-- for generalized display information as it is harder to make neighborhoods show up accurately in
-- Tableau, though could be done by passing shapefiles to Tableau
-- 1) Generalized Graph and Map showing changes in OffenseCategory or OffenseType by Zipcode Over Time
-- -) Entries where Zipcode within Top20 of TotalCrimesOccurred and OccurDate is 2015 or later
WITH ZipList as (
	SELECT
        Zipcode,
        Count(*) as TotalCrimesOccurredByZip,
        RANK() OVER (
            ORDER BY COUNT(*) DESC
        ) as ZipRank
        FROM portfolioproject.portlandcrimedata
        WHERE Zipcode IS NOT NULL
        GROUP BY Zipcode
), CategoryList as (
	SELECT 
		OffenseCategory,
		Count(*) as TotalCrimesByCategory,
		RANK() OVER (
            ORDER BY COUNT(*) DESC
        ) as CategoryRank
        FROM portfolioproject.portlandcrimedata
        GROUP BY OffenseCategory
) 

SELECT OccurDate, ppb.OffenseCategory, OffenseType, OpenDataLat, OpenDataLon, ppb.Zipcode, ZipList.TotalCrimesOccurredByZip
FROM portfolioproject.portlandcrimedata as ppb
LEFT JOIN ZipList
	ON ppb.Zipcode = ZipList.ZipCode
LEFT JOIN CategoryList
	ON ppb.OffenseCategory = CategoryList.OffenseCategory
WHERE ZipList.ZipCode IS NOT NULL
	AND CategoryList.OffenseCategory IS NOT NULL
	AND ZipRank <= 20
    AND CategoryRank <= 5
    AND YEAR(OccurDate) >= 2015
ORDER BY ZipRank, CategoryRank, OccurDate;

-- 2) Data for specified zipcodes and/or neighborhoods involving target query
SELECT OccurDate, OffenseCategory, OffenseType, OpenDataLat, OpenDataLon, Zipcode
FROM portfolioproject.portlandcrimedata
WHERE Zipcode = 97217
	OR Zipcode = 97266
    OR Zipcode = 97232
    OR Zipcode = 97205
    OR Zipcode = 97202
    AND YEAR(OccurDate) >= 2015
ORDER BY Zipcode, OffenseCategory, OffenseType, OccurDate;