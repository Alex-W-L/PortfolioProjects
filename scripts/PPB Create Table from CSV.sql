-- NOTE: If reusing this file, ensure that the LOAD DATA INFILE line has the correct path to the cleaned data file. 

-- Create staging table
-- Did some value checking to determine appropriate types and sizes
CREATE TABLE crime_data_import_staging (
	ID INT NOT NULL PRIMARY KEY,
    Address VARCHAR(75),
    CaseNumber VARCHAR(15),
    CrimeAgainst VARCHAR(10),
    Neighborhood VARCHAR(25),
    OccurDate DATE,
    OccurTime TIME,
    OffenseCategory VARCHAR(30),
    OffenseType VARCHAR(50),
    OpenDataLat DECIMAL(10,8),
    OpenDataLon DECIMAL(11,8),
    OpenDataX INT,
    OpenDataY INT,
    ReportDate DATE,
    OffenseCount SMALLINT,
    Zipcode MEDIUMINT,
    OccurDateTime DATETIME,
    OccurHour SMALLINT
);

-- Load the .csv into the covid_import_staging table
LOAD DATA INFILE "C:/ETC/data/processed/Portland Crime Data with Zipcode Cleaned.csv" -- Path to csv
INTO TABLE crime_data_import_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"' -- Handeling for commas in the strings
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@ID, @Address, @CaseNumber, @CrimeAgainst, @Neighborhood, @OccurDate, @OccurTime, @OffenseCategory, @OffenseType, @OpenDataLat, @OpenDataLon, 
	@OpenDataX, @OpenDataY, @ReportDate, @OffenseCount, @ZIPCODE, @OccurDateTime, @OccurHour)
-- Handle NULL fields, convert string date from .csv into a DATE type, 
SET
ID = @ID,
Address = NULLIF(@Address, ''),
CaseNumber = NULLIF(@CaseNumber, ''),
CrimeAgainst = NULLIF(@CrimeAgainst, ''),
Neighborhood = NULLIF(@Neighborhood, ''),
OccurDate = STR_TO_DATE(@OccurDate, '%m/%d/%Y'),
OccurTime = NULLIF(@OccurTime, ''),
OffenseCategory = NULLIF(@OffenseCategory, ''),
OffenseType = NULLIF(@OffenseType, ''),
OpenDataLat = NULLIF(@OpenDataLat, ''),
OpenDataLon = NULLIF(@OpenDataLon, ''),
OpenDataX = NULLIF(@OpenDataX, ''),
OpenDataY = NULLIF(@OpenDataY, ''),
ReportDate = STR_TO_DATE(@ReportDate, '%m/%d/%Y'),
OffenseCount = NULLIF(@OffenseCount, ''),
ZIPCODE = NULLIF(@ZIPCODE, ''),
OccurDateTime = STR_TO_DATE(@OccurDateTime, '%m/%d/%Y %H:%i'),
-- Handle invisble characters at the end of the .csv line
OccurHour = CASE
	WHEN TRIM(@OccurHour) = '' THEN NULL
	WHEN @OccurHour REGEXP '^[0-9.]+$' THEN @OccurHour
	ELSE NULL
END;

-- Create the NashvilleHousing table to import clean data into. 
CREATE TABLE portfolioproject.PortlandCrimeData (
	ID INT NOT NULL PRIMARY KEY,
    Address VARCHAR(75),
    CaseNumber VARCHAR(15),
    CrimeAgainst VARCHAR(10),
    Neighborhood VARCHAR(25),
    OccurDate DATE,
    OccurTime TIME,
    OffenseCategory VARCHAR(30),
    OffenseType VARCHAR(50),
    OpenDataLat DECIMAL(10,8),
    OpenDataLon DECIMAL(11,8),
    OpenDataX INT,
    OpenDataY INT,
    ReportDate DATE,
    OffenseCount SMALLINT,
    Zipcode MEDIUMINT,
    OccurDateTime DATETIME,
    OccurHour SMALLINT
);

INSERT INTO portfolioproject.PortlandCrimeData (ID, Address, CaseNumber, CrimeAgainst, Neighborhood, OccurDate, OccurTime, OffenseCategory, OffenseType, OpenDataLat, OpenDataLon, OpenDataX, OpenDataY, ReportDate, OffenseCount, ZIPCODE, OccurDateTime, OccurHour)
SELECT
	ID,
	Address,
	CaseNumber,
	CrimeAgainst,
	Neighborhood,
	OccurDate,
	OccurTime,
	OffenseCategory,
	OffenseType,
	OpenDataLat,
	OpenDataLon,
	OpenDataX,
	OpenDataY,
	ReportDate,
	OffenseCount,
	ZIPCODE,
	OccurDateTime,
	OccurHour
FROM crime_data_import_staging;