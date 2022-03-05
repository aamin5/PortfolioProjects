--selecting data in sql queries
SELECT * FROM	portfolioproject1 . . Nashville_housing
--standardize sale date format

select saledateconverted, CONVERT(date,	saledate)
from portfolioproject1..Nashville_housing

update Nashville_housing
set saledateconverted = CONVERT(date,SaleDate)



alter table Nashville_housing
add saledateconverted date;


--POPULATE PROPERTY ADDRESS
SELECT * from 
portfolioproject1 . . Nashville_housing --WHERE PropertyAddress is null 
order by ParcelID

SELECT a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress)
from
portfolioproject1 . . Nashville_housing AS a
JOIN portfolioproject1 . . Nashville_housing AS b
on a.ParcelID=b.ParcelID
and
a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from
portfolioproject1 . . Nashville_housing AS a
JOIN portfolioproject1 . . Nashville_housing AS b
on a.ParcelID=b.ParcelID
and
a.[UniqueID ] <> b.[UniqueID ]

--BREAKING ADDRESS INTO INDIVIDUAL COLUMNS
SELECT propertyaddress
from portfolioproject1..Nashville_housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS ADDRESS
, SUBSTRING(PropertyAddress , CHARINDEX(',' ,PropertyAddress)+1, LEN(PropertyAddress))
AS ADDRESS
from portfolioproject1..Nashville_housing

use portfolioproject1
alter table Nashville_housing
add PropertySplitAddress nvarchar(255);

update Nashville_housing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


alter table Nashville_housing
add PropertySplitCity nvarchar(255);

update Nashville_housing
set PropertySplitCity = SUBSTRING(PropertyAddress , CHARINDEX(',' ,PropertyAddress)+1, LEN(PropertyAddress))


-- splitting column in different way

select * from portfolioproject1..Nashville_housing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From portfolioproject1 .. Nashville_housing
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville_housing
Add OwnerSplitCity Nvarchar(255);

Update Nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLENashville_housing
Add OwnerSplitState Nvarchar(255);
-- brooken out addres of the owner
select  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from portfolioproject1..Nashville_housing

--adding splitted columns to the folder

use portfolioproject1
alter table Nashville_housing
add owner_split_address nvarchar(255);

update Nashville_housing
set owner_split_address =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


alter table Nashville_housing
add owner_split_city nvarchar(255);

update Nashville_housing
set owner_split_city = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

alter table Nashville_housing
add owner_split_state nvarchar(255);

update Nashville_housing
set owner_split_state = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

--changing Y and N to Yes and No in "Sold as Vacant" field

select distinct (SoldAsVacant),COUNT(SoldAsVacant)
FROM portfolioproject1..Nashville_housing
group by SoldAsVacant
order by 2

update Nashville_housing
set SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
end


SELECT SoldAsVacant
,Case when SoldAsVacant = 'Y' THEN 'Yes'
when SoldAsVacant = 'No' Then 'No'
else SoldAsVacant
end
from  Nashville_housing

---removing duplicaselect 
WITH RowNumCTE as(
SELECT * ,
ROW_NUMBER()  OVER(
PARTITION BY parcelId,
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							Order By
							UniqueID
							)row_num


from portfolioproject1..Nashville_housing)

select * 
from RowNumCTe
where row_num > 1
order by  propertyaddress

delete
from RowNumCTe
where row_num > 1


--delete unused column

select * from
portfolioproject1..Nashville_housing

alter table portfolioproject1..Nashville_housing
drop column OwnerAddress,TaxDistrict,propertyAddress

alter table portfolioproject1..Nashville_housing
drop column SaleDate
