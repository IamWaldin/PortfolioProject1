--IN THIS DATA CLEANING PROJECT WE WILL BE CLEANING THE DATA FROM THE GIVEN DATASET TO 
--MAKE IT MORE READABLE AS WELL AS USABLE,PLEASE FOLLOW BELOW AND PAY ATTENTION TO 
--COMMENTS WHICH HAS THE DESCRIPTION OF THE QUERY THAT FOLLOWS BELOW

Select *
from PortfolioProject.dbo.NashvilleHousing

--STANDARDIZE DATE FORMAT

Select SaleDateConverted, CONVERT(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Select NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


UPDATE NashvilleHousing
SEt SaleDate = CONVERT(Date,SaleDate)


Alter Table NashvilleHousing
add SaleDateConverted Date;



--POPULATE PROPERTY ADDRESS DATA


Select *
from PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null


Update 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS,CITY, STATE)


Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
add PropertySplitAddress1 Nvarchar(255)

Alter Table NashvilleHousing
add PropertySplitCity Nvarchar(255)

update NashvilleHousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , len(PropertyAddress))

Select *
from PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


Alter Table NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table NashvilleHousing
ADD OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Select*
from PortfolioProject.dbo.NashvilleHousing


--CHANGE 'Y' AND 'N' TO 'YES' AND 'NO' IN 'SOLD AS VAVANT' FIELD

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'YES'
	   when SoldAsVacant = 'N' then 'NO'
	   ELSE SoldAsVacant
	   END
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = case when SoldAsVacant = 'Y' then 'YES'
	   when SoldAsVacant = 'N' then 'NO'
	   ELSE SoldAsVacant
	   END
from PortfolioProject.dbo.NashvilleHousing


--REMOVE DUPLICATES
WITH RowNumcte AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 legalReference
				 order by
					UniqueID
					)row_num

FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
Select *
from RowNumCTE
Where row_num > 1
order by PropertyAddress

--DELETE UNUSED COLUMNS

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

Select *
from PortfolioProject.dbo.NashvilleHousing
