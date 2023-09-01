--Overview of the MonkeyPox Data
-- Working with MonkeyPox Full Dataset
SELECT*
FROM ['Monkey Pox Full dataset$']

--Adjust the date column Format
SELECT CleanDate
FROM ['Monkey Pox Full dataset$']

ALTER TABLE ['Monkey Pox Full dataset$']
ADD CleanDate Date

UPDATE ['Monkey Pox Full dataset$']
SET CleanDate = CONVERT(Date, date)

--Highest Deaths per Country
SELECT location, MAX(total_deaths) AS TotalDeaths
FROM ['Monkey Pox Full dataset$']
WHERE location <> 'World'
GROUP BY location
ORDER BY TotalDeaths DESC

UPDATE ['Monkey Pox Full dataset$']
SET total_deaths = 0
WHERE total_deaths IS NULL

--Percantage of total deaths to total cases
SELECT location, MAX(total_deaths/total_cases)*100 As PercentTotalDeath
FROM ['Monkey Pox Full dataset$']
WHERE total_cases > 0 
AND total_deaths> 0
GROUP BY location
ORDER BY PercentTotalDeath DESC

--Location vs New Cases
SELECT a.location,a.date , b.new_cases
, SUM(a.new_cases) OVER (PARTITION BY a.location ORDER BY a.location, a.date) AS RollingNewCases
FROM ['Monkey Pox Full dataset$'] a
JOIN ['Monkey Pox Full dataset$'] b
	ON a.date = b.date
	AND a.location = b.location
ORDER BY 1,2

--Total Cases and total deaths per country
SELECT location, MAX(total_cases) AS TotalCases, MAX(total_deaths) AS TotalDeaths
FROM ['Monkey Pox Full dataset$']
GROUP BY location
ORDER BY TotalCases DESC, TotalDeaths

--Total MonkeyPox cases in the World
SELECT location = 'World', MAX(total_cases) AS WorldCases
FROM ['Monkey Pox Full dataset$']

--Total Cases Per Country
SELECT location, MAX(total_cases) AS TotalCases
FROM ['Monkey Pox Full dataset$']
GROUP BY location
ORDER BY TotalCases DESC

--Highest Cases Per Million
SELECT DISTINCT(location) ,MAX(total_cases_per_million) AS HighestCasesPerMil
FROM ['Monkey Pox Full dataset$']
GROUP BY location
ORDER BY HighestCasesPerMil DESC

---Working with the Monkey_Pox_Cases_Worldwide Dataset
--Data Overview
SELECT*
FROM Monkey_Pox_Cases_Worldwide$

--Confirmed Cases by Country
SELECT Country, Confirmed_Cases
FROM Monkey_Pox_Cases_Worldwide$
GROUP BY Country, Confirmed_Cases
ORDER BY 2 DESC

--Hospitalized vs Confirmed Cases Per Country
SELECT Country, Confirmed_Cases, Hospitalized
FROM Monkey_Pox_Cases_Worldwide$
GROUP BY Country, Hospitalized, Confirmed_Cases
ORDER BY Hospitalized DESC

--Travel History for each country
SELECT Country,Travel_History_Yes, Travel_History_No
FROM Monkey_Pox_Cases_Worldwide$
GROUP BY Country, Travel_History_Yes, Travel_History_No, Confirmed_Cases
ORDER BY Confirmed_Cases DESC
