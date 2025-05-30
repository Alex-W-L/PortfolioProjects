-- MySQL Query Scripts for collecting information relevant to displaying trends in various crimes. Sourced from Portland City Open Data initiative. 
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

-- 2) Data for specified zipcodes involving target query
SELECT OccurDate, OffenseCategory, OffenseType, OpenDataLat, OpenDataLon, Zipcode
FROM portfolioproject.portlandcrimedata
WHERE Zipcode = 97217
	OR Zipcode = 97266
    OR Zipcode = 97232
    OR Zipcode = 97205
    OR Zipcode = 97202
    AND YEAR(OccurDate) >= 2015
ORDER BY Zipcode, OffenseCategory, OffenseType, OccurDate;