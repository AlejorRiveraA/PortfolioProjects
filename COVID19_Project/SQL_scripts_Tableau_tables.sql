-- Adapted from AlexTheAnalyst 
-- Original code: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Tableau%20Portfolio%20Project%20SQL%20Queries.sql

-- Queries used for Tableau Project

-- 1. 
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths, 
		ROUND(SUM(cast(new_deaths AS INT))/SUM(New_Cases)*100, 2) as DeathPercentage
FROM PortfolioProject.dbo.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- 2. 
-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.covid_deaths
WHERE continent IS NULL 
	AND LOWER(location) NOT IN ('world', 'european union', 'international')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- 3.
SELECT Location, Population, ISNULL(MAX(total_cases),0) AS HighestInfectionCount, 
		ROUND(ISNULL(MAX((total_cases/population))*100, 0) ,4) AS PercentPopulationInfected
FROM PortfolioProject.dbo.covid_deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


-- 4.
-- Extract the date in format dd/mm/yyyy
-- Replace missing values with 0 in aggregate function columns 

SELECT Location, Population, CONVERT(VARCHAR(10), date, 103) AS date, ISNULL(MAX(total_cases),0)  AS HighestInfectionCount, 
	ROUND(ISNULL(MAX((total_cases/population))*100, 0) ,4) AS PercentPopulationInfected
FROM PortfolioProject.dbo.covid_deaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC