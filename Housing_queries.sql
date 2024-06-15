select * from Nashville_housing

--Change the datetime datatype to date

update Nashville_housing
set SaleDate = convert(date,SaleDate)

alter table Nashville_housing
alter column SaleDate date

---Add new column SaleDateConverted

alter table Nashville_housing
add SaleDateConverted date

update Nashville_housing
set SaleDateConverted = convert(date,SaleDate)


--Populate Property Address for null values

   --Identify the null values
select a.UniqueID,a.ParcelID,a.PropertyAddress,b.UniqueID,b.ParcelID,b.PropertyAddress
from nashville_housing a
join nashville_housing b
on a.ParcelID=b.ParcelID
where a.UniqueID<>b.UniqueID
and a.PropertyAddress is null

	--Using ISNULL() to populate non-null value
select a.UniqueID,a.ParcelID,a.PropertyAddress,b.UniqueID,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashville_housing a
join nashville_housing b
on a.ParcelID=b.ParcelID
where a.UniqueID<>b.UniqueID
and a.PropertyAddress is null


update a
set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashville_housing a
join nashville_housing b
on a.ParcelID=b.ParcelID
where a.UniqueID<>b.UniqueID
and a.PropertyAddress is null

---Split PropertyAddress Column into Address and City

select Propertyaddress ,substring(PropertyAddress,1,charindex(',',Propertyaddress)-1) as Address,
substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as City,len(PropertyAddress)
from Nashville_housing

alter table Nashville_housing
add PropertySplitAddress varchar(100),PropertySplitCity varchar(90)

update Nashville_housing
set PropertySplitAddress=substring(PropertyAddress,1,charindex(',',Propertyaddress)-1)

update Nashville_housing
set PropertySplitCity=substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))

---Split OwnerAddress Column into Address and City



alter table Nashville_housing
add OwnerAddr_Address varchar(50)

update Nashville_housing
set OwnerAddr_Address = PARSENAME(Replace(OwnerAddress,',','.'),3)

alter table Nashville_housing
add OwnerAddr_City varchar(50)

update Nashville_housing
set OwnerAddr_City = PARSENAME(Replace(OwnerAddress,',','.'),2)


alter table Nashville_housing
add OwnerAddr_State varchar(50)

update Nashville_housing
set OwnerAddr_State = PARSENAME(Replace(OwnerAddress,',','.'),1)


---Change Y and N to Yes and No in SoldAsvacant column

select DISTINCT SoldAsVacant,count(SoldAsVacant)
from Nashville_housing
group by SoldAsVacant
order by 2 desc

select SoldAsVacant,
Case when SoldAsVacant='N' then 'No'
	 when SoldAsVacant='Y' then 'Yes'
	 else
	 SoldAsVacant
end
from Nashville_housing


update Nashville_housing
set SoldAsVacant =
Case when SoldAsVacant='N' then 'No'
	 when SoldAsVacant='Y' then 'Yes'
	 else
	 SoldAsVacant
end



--------------Remove Dupliates


with cte as
(
select *,ROW_NUMBER() over(partition by Parcelid,PropertyAddress,SaleDate,SalePrice,LegalReference order by UniqueID)as Rownum
from Nashville_housing
)
select * from cte where Rownum>1

with cte as
(
select *,ROW_NUMBER() over(partition by Parcelid,PropertyAddress,SaleDate,SalePrice,LegalReference order by UniqueID)as Rownum
from Nashville_housing
)
delete from cte where Rownum>1


---Delete unused /irrelevant columns

select * from Nashville_housing

alter table Nashville_housing
drop column PropertyAddress,OwnerAddress