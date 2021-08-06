SELECT *
FROM PortfolioProjecy.dbo.covid_deaths
ORDER BY 3,4;

--SELECT *
--FROM PortfolioProjecy.dbo.covid_vaccinations
--ORDER BY 3,4;

-- Looking at Total Deaths vs Total Cases
-- Shows the likelihood in time of dying if you contract COVID-19 in your country
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS DeathPercentage
FROM PortfolioProjecy.dbo.covid_deaths
WHERE LOWER(location) = 'colombia'
ORDER BY 1,2 DESC;

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS DeathPercentage
FROM PortfolioProjecy.dbo.covid_deaths
WHERE LOWER(location) LIKE '%states%'
ORDER BY 1,2 DESC;

-- Total cases vs Population
SELECT location, date, population, total_cases, total_cases_per_million, ROUND((total_cases/population)*1000000, 2) AS PopulationPercentage
FROM PortfolioProjecy.dbo.covid_deaths
WHERE LOWER(location) LIKE '%states%'
ORDER BY 1,2 DESC;

-- Total cases vs Population
SELECT location, population, COUNT(*) AS numberObs
FROM PortfolioProjecy.dbo.covid_deaths
WHERE LOWER(location) LIKE '%states%'
GROUP BY location, population;

-- Looking at countries with highest Infection Rate compared to population
SELECT location, population, MAX(total_cases) AS highestInfectionCount, ROUND(MAX((total_cases/population))*100, 2) AS PercentPopulationInfected
FROM PortfolioProjecy.dbo.covid_deaths
--WHERE LOWER(location) LIKE '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Showing countries with the highest death count per Population
-- The column total_deaths is nvarchar type. Casting to integer is needed here
-- the location contains continents
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeath
FROM PortfolioProjecy.dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeath DESC;

-- Let's break down by continent
SELECT t1.continent, SUM (t1.HighestDeath) AS Total_deaths
FROM (
	SELECT continent, location, MAX(CAST(total_deaths AS INT)) AS HighestDeath
	FROM PortfolioProjecy.dbo.covid_deaths
	WHERE continent IS NOT NULL
	GROUP BY continent, location
	) t1
GROUP BY t1.continent
ORDER BY Total_deaths DESC
;

SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeath
FROM PortfolioProjecy.dbo.covid_deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeath DESC;

-- For each continent what country has the highest total of deaths?
SELECT Td.continent, Td.location, CAST(Td.total_deaths AS INT) AS total_deaths_int, Td.total_cases
FROM PortfolioProjecy.dbo.covid_deaths Td, (SELECT continent, MAX(CAST(total_deaths AS INT)) AS HighestDeath
	FROM PortfolioProjecy.dbo.covid_deaths
	WHERE continent IS NOT NULL --AND continent= 'North America'
	GROUP BY continent) T2
WHERE Td.continent = T2.continent AND td.total_deaths = T2.HighestDeath
ORDER BY total_deaths_int DESC
;


-- Looking at total populaiton vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
FROM PortfolioProjecy.dbo.covid_deaths dea
JOIN PortfolioProjecy.dbo.covid_vaccinations vac
ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
	--AND vac.new_vaccinations IS NOT NULL
ORDER BY 2,3;


