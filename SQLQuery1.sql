
--This query calculates the total number of new cases and deaths, as well as the percentage of deaths out of total cases for all countries that have a defined continent, sorted by total cases and deaths.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM katlegoPortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

---- Calculate the total number of deaths per location excluding the world, European Union and International locations
-- The query filters out null continents and orders the results by the total death count in descending order	
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
FROM katlegoPortfolioProject..CovidDeaths
--Where location like 'South Africa'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

---- Calculate the percentage of population infected and the highest infection count per location
-- The query groups the data by location and population, then orders the results by the percentage of population infected in descending order
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, 
    MAX(CAST(total_cases AS float))/CAST(Population AS float)*100 as PercentPopulationInfected
FROM katlegoPortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--Calculate the percentage of population infected and the highest infection count per location and date
-- The query groups the data by location, population and date, then orders the results by the percentage of population infected in descending order
SELECT Location, Population, date, MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount, MAX((CAST(total_cases AS FLOAT) / Population)) * 100 AS PercentPopulationInfected
FROM katlegoPortfolioProject..CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC

--The top 10 countries with the highest death rates per 100,000 population
SELECT TOP 10 location, CAST(total_deaths AS FLOAT)/CAST(population AS FLOAT)*100000 AS death_rate_per_100k
FROM katlegoPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL AND date = '2022-03-15'
ORDER BY death_rate_per_100k DESC;

--The percentage of total deaths that occurred in South Africa out of all deaths in Africa
WITH african_deaths AS (
  SELECT SUM(cast(total_deaths AS int)) AS total_deaths
 FROM katlegoPortfolioProject..CovidDeaths
  WHERE continent = 'Africa'
)
SELECT cast(total_deaths_in_sa AS decimal) / african_deaths.total_deaths * 100 AS percentage_of_deaths_in_sa
FROM (
  SELECT SUM(cast(total_deaths AS int)) AS total_deaths_in_sa
  FROM katlegoPortfolioProject..CovidDeaths
  WHERE location = 'South Africa'
) sa_deaths, african_deaths

-- Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases AS FLOAT))/CAST(population AS FLOAT)*100 AS PercentPopulationInfected
FROM katlegoPortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Death Count per Population
SELECT Location, MAX(Total_deaths) AS TotalDeathCount
FROM katlegoPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- countries with the highest and lowest total number of COVID-19 cases and deaths
SELECT location, MAX(total_cases) AS highest_total_cases, MAX(total_deaths) AS highest_total_deaths,
       MIN(total_cases) AS lowest_total_cases, MIN(total_deaths) AS lowest_total_deaths
FROM katlegoPortfolioProject..CovidDeaths
GROUP BY location
ORDER BY highest_total_cases DESC

--How has the number of COVID-19 cases and deaths changed over time globally?
SELECT date, SUM(total_cases) AS total_cases, SUM(total_deaths) AS total_deaths
FROM katlegoPortfolioProject..CovidDeaths
GROUP BY date
ORDER BY date ASC

-- Calculate the total number of cases and deaths per continent
-- The query groups the data by continent and filters out null continents, then orders the results by the total number of cases in descending order
SELECT continent, SUM(total_cases) AS total_cases, SUM(total_deaths) AS total_deaths
FROM katlegoPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_cases DESC

-- Calculate the overall mortality rate for each location
-- The query groups the data by location and calculates the mortality rate as the total deaths divided by the total cases, then orders the results by mortality rate in descending order
SELECT location, SUM(total_cases) AS total_cases, SUM(total_deaths) AS total_deaths,
CAST(SUM(total_deaths) AS FLOAT) / NULLIF(SUM(total_cases), 0) AS mortality_rate
FROM katlegoPortfolioProject..CovidDeaths
GROUP BY location
ORDER BY mortality_rate DESC

-- Calculate the number of new cases and deaths over time in South Africa
-- The query filters the data for South Africa and orders the results by date in ascending order
SELECT date, new_cases, new_deaths
FROM katlegoPortfolioProject..CovidDeaths
WHERE location = 'South Africa'
ORDER BY date ASC
