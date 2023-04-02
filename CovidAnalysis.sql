/*
Covid 19 Data Exploration 
Skills used: 

1. Joins 
2. CTE
3. Windows Functions
4. Aggregate Functions
5. Creating Views
6. Type Casting Data Types
*/


SELECT * 
FROM CovidAnalysis..CovidDeaths
WHERE continent is not null
ORDER BY 3,4


SELECT * 
FROM CovidAnalysis.dbo.CovidVaccinations
ORDER BY 3,4

-- Selecting the specific columns

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
ORDER BY location,date



---Total cases vs total deaths, calculating the death percentage with compared to total cases

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
ORDER BY location,date



---Checking death percentage for india 

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidAnalysis.dbo.CovidDeaths
WHERE location like '%India%'
and continent is not null
ORDER BY location,date

---According to the data, the death percentage of India never exceeded more than 4%

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidAnalysis.dbo.CovidDeaths
WHERE location like '%states%'
and continent is not null
ORDER BY location,date
-- The highest peek of death rate compared to total cases was 10% in united states



-- Total cases vs the population,shows what percentage of people got covid

SELECT location,date,total_cases, population, (total_cases/population)*100 as TotalCasesPercentage
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
ORDER BY location,date

-- Total cases vs the population in India

SELECT location,date,total_cases, population, (total_cases/population)*100 as TotalCasesPercentage
FROM CovidAnalysis.dbo.CovidDeaths
where location like '%India%'
and continent is not null
ORDER BY location,date

-- Total cases vs the population in United states

SELECT location,date,total_cases, population, (total_cases/population)*100 as TotalCasesPercentage
FROM CovidAnalysis.dbo.CovidDeaths
where location like '%states%'
and continent is not null
ORDER BY location,date


-- Total deaths by population

SELECT location,date,population, total_deaths, (total_deaths/population)*100 as TotalDeathsBYPopulation
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
ORDER BY location,date


-- Countries with highest infection rate

SELECT location,population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PopulationInfected
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY PopulationInfected DESC

-- The highest infection rate is in Andorra country where population is 77265 and 12232 people were infected with covid



--- Looking at highest death count

SELECT location, MAX(cast(total_deaths as INT)) AS HighestDeathCount
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY HighestDeathCount DESC
--According to the analysis, the united states has the highest death count


-- countries with highest death rate 

SELECT location,population, MAX(total_deaths) AS HighestDeathCount, MAX((total_deaths/population))*100 as DeathRate
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY DeathRate DESC





--Highest death rate in continent

SELECT continent, MAX(cast(total_deaths as INT)) AS HighestDeathCount
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY HighestDeathCount DESC



--Highest infection rate in continent

SELECT continent, Max(total_cases) as HighestInfectionInContinent
FROM CovidAnalysis.dbo.CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY HighestInfectionInContinent DESC




--Highest infectionRate and deathrate accordint to continent

SELECT continent, MAX(CAST(total_cases AS INT)) AS HighestInfection, MAX(CAST(total_deaths AS INT)) as Deathcount
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
Order BY HighestInfection,Deathcount DESC


--Global COVID numbers
SELECT date, SUM(new_cases) as CasesPerDay, SUM(cast(new_deaths as INT)) as DeathsPerDay, SUM(cast(new_deaths as INT))/SUM(new_cases)*100 as NewDeathPercentage
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--Total cases

SELECT SUM(new_cases) as Total_cases, SUM(cast(new_deaths as INT)) as TotalDeaths, SUM(cast(new_deaths as INT))/SUM(new_cases)*100 as NewDeathPercentage
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2


-- Exploring covid vaccination dataset

SELECT *
FROM CovidAnalysis.dbo.CovidVaccinations


--Total people vaccinated by location

SELECT Location, date,MAX(people_vaccinated) AS TotalPeopleVaccinated
FROM CovidAnalysis.dbo.CovidVaccinations
where continent is not null
group by location, date
order by 1

-- Total people vaccinated by continent

SELECT continent, date, MAX(people_vaccinated) AS TotalPeopleVaccinated
FROM CovidAnalysis.dbo.CovidVaccinations
where continent is not null
group by continent, date
order by 1,2

-- People fully vaccinated
SELECT location, date, MAX(people_fully_vaccinated) AS TotalPeopleVaccinated
FROM CovidAnalysis.dbo.CovidVaccinations
where continent is not null
group by location, date
order by 1,2


-- joining both tables together by location and date
SELECT * 
FROM CovidAnalysis.dbo.CovidDeaths death
JOIN CovidAnalysis.dbo.CovidVaccinations vacci
	on death.location = vacci.location
	and death.date = vacci.date

-- Selecting the specific columns from the join

SELECT death.continent, death.location, death.date,death.population, vacci.new_vaccinations
FROM CovidAnalysis.dbo.CovidDeaths death
join CovidAnalysis.dbo.CovidVaccinations vacci
	on death.location = vacci.location
	and death.date = vacci.date
where death.continent is not null
order by 1,2,3

-- people vaccinated over population

SELECT death.continent,death.location, death.population, death.date,vacci.people_vaccinated, (vacci.people_vaccinated/death.population)*100 as PercentVaccinated
FROM CovidAnalysis.dbo.CovidDeaths death
JOIN CovidAnalysis.dbo.CovidVaccinations vacci
	on death.location = vacci.location
	and death.date = vacci.date
WHERE death.continent is not null
ORDER BY 1,2,3


-- total people vaccinated by location

SELECT death.continent, death.location, death.date,death.population, vacci.new_vaccinations, 
	SUM(CAST(vacci.new_vaccinations AS INT)) OVER (partition by death.location ORDER BY death.location, death.date) as vaccinatedByLocation
FROM CovidAnalysis.dbo.CovidDeaths death
join CovidAnalysis.dbo.CovidVaccinations vacci
	on death.location = vacci.location
	and death.date = vacci.date
where death.continent is not null
order by 2,3



-- USE CTE
WITH PopulationVSVaccination (continent, location, date, population, new_vaccinations,vaccinatedByLocation)
as
(
SELECT death.continent, death.location, death.date,death.population, vacci.new_vaccinations, 
	SUM(CAST(vacci.new_vaccinations AS INT)) OVER (partition by death.location ORDER BY death.location, death.date) as vaccinatedByLocation
FROM CovidAnalysis.dbo.CovidDeaths death
join CovidAnalysis.dbo.CovidVaccinations vacci
	on death.location = vacci.location
	and death.date = vacci.date
where death.continent is not null
--order by 2,3
)
SELECT *,(vaccinatedByLocation/population)*100 as PercentVaccinatedByLocation
FROM PopulationVSVaccination



-- Views

CREATE VIEW HighestDeathCountBYContinete as
SELECT continent, MAX(cast(total_deaths as INT)) AS HighestDeathCount
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent



CREATE VIEW global as 
SELECT SUM(new_cases) as Total_cases, SUM(cast(new_deaths as INT)) as TotalDeaths, SUM(cast(new_deaths as INT))/SUM(new_cases)*100 as NewDeathPercentage
FROM CovidAnalysis.dbo.CovidDeaths
WHERE continent is not null
