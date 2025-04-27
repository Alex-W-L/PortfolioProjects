-- Clean data from "Nashville Housing Data.csv"
-- -------------------------------------------------------------------------
-- Standardize Date Format
-- Nothing necessary here, I handled this in my import

-- -------------------------------------------------------------------------
-- Populate Property Address data
-- When ParcelID is the same, PropertyAddress is the same, see id=86,87
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolioproject.nashvillehousing a
JOIN portfolioproject.nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress is null;

-- Updating all PropertyAddress null fields with paired ParcelID PropertyAddress corrections
SET SQL_SAFE_UPDATES = 0;
UPDATE portfolioproject.nashvillehousing a
JOIN portfolioproject.nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress is null;
SET SQL_SAFE_UPDATES = 1;

-- -------------------------------------------------------------------------
-- Breaking out PropertyAddress into Individual Columns (Address, City, State)
-- PropertyAddress of the form STREET, CITY without exceptions
-- Using a Substring and Character (CHAR) Index [MSSQL Only]
-- To translate to MySQL, use SUBSTRING_INDEX

-- MSSQL Script
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM portfolioproject.nashvillehousing;

-- MySQL Script
SELECT
	TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1)) AS StreetAddress,
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM portfolioproject.nashvillehousing;

-- Updating Table with new fields and populating them
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE portfolioproject.nashvillehousing
ADD PropertySplitStreet VARCHAR(42); -- Based on original PropertyAddress, could be smaller
UPDATE portfolioproject.nashvillehousing
SET PropertySplitStreet = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1));

ALTER TABLE portfolioproject.nashvillehousing
ADD PropertySplitCity VARCHAR(42); -- Based on original PropertyAddress, could be smaller
UPDATE portfolioproject.nashvillehousing
SET PropertySplitCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));
SET SQL_SAFE_UPDATES = 1;

-- -------------------------------------------------------------------------
-- Breaking out OwnerAddress into Individual Columns (Address, City, State)
-- Determining isolations for Street, City, and State
SELECT
	TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS StreetAddress,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', '2'), ',', '-1')) AS CityAddress,
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS StateAddress
FROM portfolioproject.nashvillehousing;

-- Updating Table with new fields and populating them
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE portfolioproject.nashvillehousing
ADD OwnerSplitStreet VARCHAR(46); -- Based on original OwnerAddress, could be smaller
UPDATE portfolioproject.nashvillehousing
SET OwnerSplitStreet = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1));

ALTER TABLE portfolioproject.nashvillehousing
ADD OwnerSplitCity VARCHAR(46); -- Based on original OwnerAddress, could be smaller
UPDATE portfolioproject.nashvillehousing
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', '2'), ',', '-1'));

ALTER TABLE portfolioproject.nashvillehousing
ADD OwnerSplitState VARCHAR(46); -- Based on original OwnerAddress, could be smaller
UPDATE portfolioproject.nashvillehousing
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));
SET SQL_SAFE_UPDATES = 1;

-- -------------------------------------------------------------------------
-- Change entries under SoldAsVacant to align (N -> No, Y -> Yes)

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) as SoldAsTotals
FROM portfolioproject.nashvillehousing
GROUP BY SoldAsVacant
ORDER BY SoldAsTotals; -- 52 listed as "Y", 399 listed as "N", 4623 listed as "Yes", 51403 listed as "No"

-- Isolating the deviant values and providing replacements
SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = "Y" THEN "Yes"
    WHEN SoldAsVacant = "N" THEN "No"
    ELSE SoldAsVacant
END
FROM portfolioproject.nashvillehousing;

-- Updating the deviant values
UPDATE portfolioproject.nashvillehousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = "Y" THEN "Yes"
    WHEN SoldAsVacant = "N" THEN "No"
    ELSE SoldAsVacant
END;

-- -------------------------------------------------------------------------
-- Removing duplicates and removing unused columns

-- Creating CTE to check what rows have multiple similar entiries to justify duplicate status
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY 
						UniqueID
	) row_num
	FROM portfolioproject.nashvillehousing
)
-- SELECT * -- Found 104 rows that were duplicates
-- Delete rows from original table where the UniqueID in the original table matches the UniqueID from the CTE for duplicates
DELETE
FROM portfolioproject.nashvillehousing
WHERE UniqueID IN (
	SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);

-- -------------------------------------------------------------------------
-- Delete unused columns
-- NOTE: Do not use in raw data, always keep raw original data
-- Deleting the columns here where we split the address data into new columns

ALTER TABLE portfolioproject.nashvillehousing
	DROP OwnerAddress, 
    DROP PropertyAddress;


-- -------------------------------------------------------------------------


