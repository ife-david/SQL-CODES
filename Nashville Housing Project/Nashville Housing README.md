# Data Cleaning on Nashville Housing
This project is basically a Data Cleaning Project on the Nashville Housing Dataset.

Firstly, I had a general overview of the data set. After which I found some irregularities with the SaleDate Column. The Sales Date Column was not in the Date format and therefore I had to make adjustments to the column.

I altered the table using the ALTER Table function while making use of the CONVERT and DATE function to adjust the date to the right format.

I decided to populate the property address. I noticed some ParcelID appeared twice along with the same Property Address. I used the JOINS functions to join the table on ParcelID AND UniqueID that were not equal, where the Property Address was NULL.  I used the ISNULL function to replace the NULL address with the existing addresses.

I decided to break the address into the various streets and states, by putting them in separate columns using the SUBSTRING and CHARINDEX function.

In the "SoldAsVacant" field, there were 4 options namely : Y, N,YES and NO. I made use of the CASE function to change the "Y" to "YES" and "N" to "NO".

I also removed the duplicates in the data by creating a Common Table Expression(CTE), which I used to manipulate some queries. I also made use of the PARTITION BY, OVER and ROW_NUMBER functions to carry out this process.

Lastly, I deleted the unused columns using the DROP COLUMNS function.
