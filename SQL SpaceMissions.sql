
--------Data Cleaning & Exploration of the Space Missions Dataset on Sql server- Azure Data Studio------

---Initial steps: Create table, set data types and import the csv dataset using the SQL Server Import extension---


--===Data Cleaning===--

/* View data */

SELECT TOP (1000) *
  FROM [master].[dbo].[spacemissions]

/* Separating location into individual columns for address, citystate and country; using parse */

SELECT [Location]
FROM dbo.spacemissions

/* Replace periods with commas */

SELECT
PARSENAME(REPLACE(Location, ',', '.'), 3) 
, PARSENAME(REPLACE(Location, ',', '.'), 2) 
, PARSENAME(REPLACE(Location, ',', '.'), 1) 
FROM dbo.spacemissions

/* create 3 new columns for the newly split owneraddress) */

ALTER TABLE dbo.spacemissions
ADD LaunchAddress NVARCHAR(200);

UPDATE dbo.spacemissions
SET LaunchAddress = PARSENAME(REPLACE(location, ',', '.'), 3)

ALTER TABLE dbo.spacemissions
ADD LaunchCitystate  NVARCHAR(200);

UPDATE dbo.spacemissions
SET LaunchCitystate = PARSENAME(REPLACE(location, ',', '.'), 2)

ALTER TABLE dbo.spacemissions
ADD LaunchCountry  NVARCHAR(200);

UPDATE dbo.spacemissions
SET LaunchCountry = PARSENAME(REPLACE(location, ',', '.'), 1)

/* preview update */

SELECT * 
from spacemissions

/* setting null price to zero */

update dbo.spacemissions
set price = 0 
where price is NULL

select *
from spacemissions


--===Data exploration===--

/*  Total Country */

SELECT COUNT(DISTINCT LaunchCountry) FROM [dbo].[spacemissions] As Total_Country

/* Total rocket count */

SELECT COUNT (DISTINCT rocket) FROM [dbo].[spacemissions] AS TotalRockets 

/* Total mission count */

SELECT COUNT (DISTINCT mission) FROM [dbo].[spacemissions] AS TotalMissions

/* Company count */

SELECT DISTINCT (company), COUNT(company) as NumberOfCompany
FROM dbo.spacemissions
GROUP BY company
ORDER BY 2 DESC

/* Most Active country on space */

SELECT Distinct launchcountry , COUNT(launchcountry)as rocket_launched
from spacemissions
group by launchcountry
order by rocket_launched desc

/* Rocket status count */

SELECT DISTINCT (rocketstatus), COUNT(rocketstatus) as NumberOfRockets
FROM dbo.spacemissions
GROUP BY rocketstatus
ORDER BY 2 DESC

/* Number of mission by year */

WITH temptable as (
	select *,
	YEAR(date) as year from spacemissions
)
SELECT year, count(year)
from temptable
group by YEAR
order by 2 DESC

/* Missions by missionstatus */

SELECT DISTINCT (missionstatus), COUNT(missionstatus) as NumberOfMissions
FROM dbo.spacemissions
GROUP BY missionstatus
ORDER BY 2 DESC

/* What is the number of years under study */

select DATEDIFF(year, '1957-10-04',
'2022-07-29') as YearsOfStudy;

/* Trend in Daily count of Missions over the years of investigation */

SELECT Date,count(mission) As Total_mission 
FROM [dbo].[spacemissions] 
GROUP BY Date Order BY Total_mission

/* Total count of Missions by country */

SELECT DISTINCT (Launchcountry), COUNT(Launchcountry) AS TotalMission 
FROM [dbo].[spacemissions] 
GROUP BY Launchcountry 
order by 2 DESC

/* TOP 10 Countries having active rockets */

select top (10) launchcountry, count(Rocket)
from spacemissions
where RocketStatus = 'Active'
group by launchcountry
order by 2 desc

/* Top 10 most successful Rocket */

SELECT Top (10) Rocket, count(MissionStatus) as missions
from spacemissions
where MissionStatus = 'Success'
group by Rocket
order by 2 desc

/* Top 10 most successful mission */

SELECT Mission, count(MissionStatus)
from spacemissions
where MissionStatus = 'Success'
group by mission
order by 2 desc

/* Average spendings by countrys on space mission (Million dollars) */

WITH temptable as (
	select *,
			cast(REPLACE(Price,',','') as decimal) as amount
FROM spacemissions
)
SELECT launchcountry, round(avg(amount),2)
from temptable
where amount is not NULL
group by launchcountry
order by 2 desc
