SELECT * 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4;


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

--Looking at total cases vs total deaths
--Shows death rate if you have covid in United States
SELECT location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS death_rate
FROM PortfolioProject..CovidDeaths
WHERE Location like '%states%'
ORDER BY 1,2;


--Looking at total cases vs population

SELECT location, date, population, total_cases,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population ), 0)) * 100 AS CovidPopPercentage
from PortfolioProject..covidDeaths
WHERE Location like '%states%'
ORDER BY 1,2


--Looking for Countries with highest infected rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population ), 0)) * 100) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
GROUP BY population, location
ORDER BY PercentPopulationInfected DESC;


--Deaths from covid

SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC;

--By Continent

Select continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC;

--By all locations

Select location, MAX(CAST(total_deaths as int))as total_death_count
FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC;

--Global Numbers/New cases

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(New_Cases)*100 AS Death_Percent
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--GROUP By date
ORDER BY 1,2


--joining both tables
SELECT *
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date

--Total population vaccinated for North America

SELECT dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null and vac.continent ='North America'
ORDER BY 2,3

SELECT dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION by dea.location ORDER BY dea.location , dea.date) AS TotalVaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--CTE

WITH PopvsVac (Continent, location, date, population, New_Vaccinations, Popvacc)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea.date) AS Popvacc
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (Popvacc/Population)*100 AS TotalPercentVacc
From PopvsVac



--Query used for Visual

CREATE VIEW PopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea.date) AS Popvacc
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(New_Cases)*100 AS Death_Percent
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
--GROUP By date
ORDER BY 1,2

SELECT location, SUM(CAST(new_deaths AS int)) as DeathCount
FROM CovidDeaths
WHERE continent is null and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
GROUP BY location
ORDER BY DeathCount DESC

SELECT location, population, MAX(total_cases) as MostInfected, MAX((total_cases/population))*100 AS POPPercentInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY POPPercentInfected DESC


SELECT location, population, date, MAX(total_cases) as MostInfected, MAX((total_cases/population))*100 AS POPPercentInfected
FROM CovidDeaths
GROUP BY location, population, date
ORDER BY POPPercentInfected DESC