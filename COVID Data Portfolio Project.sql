/* SELECT * 
FROM portfolioproject.covidvaccinations
order by 3,4; */

-- Basic intro information
SELECT *
FROM portfolioproject.covid_deaths;

-- Basic intro information
SELECT *
FROM portfolioproject.covid_vaccinations;

-- Looking at Total Cases vs Total Deaths
-- Shows the liklihood of dying while infect by covid on country-wide basis
SELECT location, raw_date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM portfolioproject.covid_deaths
WHERE location like '%states';

-- Looking at the total cases versus the population
-- Shows what percentage of the population has been infected by covid
SELECT location, raw_date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM portfolioproject.covid_deaths
WHERE location like '%states';

-- Looking at countries with the highest infection rate compared to population
SELECT location, max(total_cases) as HighestInfectionCount, population, max(total_cases/population)*100 as PercentPopulationInfected
FROM portfolioproject.covid_deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc;

-- Looking at countries with the highest death rate compared to population
SELECT location, max(cast(total_deaths as signed)) as TotalDeathCount
FROM portfolioproject.covid_deaths
WHERE continent != '' -- Handeling blank entries for continent so the list is solely countries
GROUP BY Location
ORDER BY TotalDeathCount desc;

-- BREAKING DOWN DATA BY CONTINENT
-- Showing the continents with the highest death count
SELECT location, max(cast(total_deaths as signed)) as TotalDeathCount
FROM portfolioproject.covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;

-- GLOBAL NUMBERS
-- Total Cases, Deaths, and Case-to-Death ratio per day
SELECT raw_date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, sum(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM portfolioproject.covid_deaths
WHERE continent is not null
GROUP BY raw_date
ORDER BY raw_date;

-- Total Cases, Deaths, and Case-to-Death ratio overall
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, sum(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM portfolioproject.covid_deaths
WHERE continent is not null
ORDER BY raw_date;

-- Joining Tables together
-- Looking at the Total Population vs Vaccination
-- Use CTE
WITH PopvsVac (contienent, location, raw_date, population, new_vaccinations, RollingPeopleVaccinated)
AS (
	SELECT deaths.continent, deaths.location, deaths.raw_date, deaths.population, vaccinations.new_vaccinations, SUM(vaccinations.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.raw_date) as RollingPeopleVaccinated
	FROM portfolioproject.covid_deaths as deaths
	JOIN portfolioproject.covid_vaccinations as vaccinations
		ON deaths.location = vaccinations.location
		AND deaths.raw_date = vaccinations.raw_date
	WHERE deaths.continent is not null
	-- ORDER BY deaths.location, raw_date
)
Select *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

-- TEMP TABLE
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated 
(
	Continent varchar(255), 
	Location varchar(255),
	Rawdate datetime,
	Population numeric, 
	New_vaccinations numeric, 
	RollingPeopleVaccinated numeric
);

INSERT INTO PercentPopulationVaccinated
SELECT deaths.continent, deaths.location, deaths.raw_date, deaths.population, vaccinations.new_vaccinations, SUM(vaccinations.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.raw_date) as RollingPeopleVaccinated
	FROM portfolioproject.covid_deaths as deaths
	JOIN portfolioproject.covid_vaccinations as vaccinations
		ON deaths.location = vaccinations.location
		AND deaths.raw_date = vaccinations.raw_date
	WHERE deaths.continent is not null;

Select *, (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated;
DROP TABLE IF EXISTS PercentPopulationVaccinated;

-- Setting Up a View to store data for later visualizations
CREATE VIEW portfolioproject.PercentPopulationVaccinated AS
SELECT deaths.continent, deaths.location, deaths.raw_date, deaths.population, vaccinations.new_vaccinations, SUM(vaccinations.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.raw_date) as RollingPeopleVaccinated
	FROM portfolioproject.covid_deaths as deaths
	JOIN portfolioproject.covid_vaccinations as vaccinations
		ON deaths.location = vaccinations.location
		AND deaths.raw_date = vaccinations.raw_date
	WHERE deaths.continent is not null;