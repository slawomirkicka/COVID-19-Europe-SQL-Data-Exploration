-- Show Table covid_deaths_europe
SELECT *
FROM Covid_Europe.covid_deaths_europe
ORDER BY 3, 4;

-- Show Table covid_vaccination_europe
SELECT *
FROM Covid_Europe.covid_vaccination_europe
ORDER BY 3, 4;

-- Show Selected Data from Table covid_deaths_europe
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid_Europe.covid_deaths_europe
ORDER BY 1, 2;

-- Show Percentage of Total Cases over Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Covid_Europe.covid_deaths_europe
ORDER BY 1, 2;

-- Show Percentage of Total Cases over Total Deaths in Germany
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Covid_Europe.covid_deaths_europe
WHERE location = 'Germany'
ORDER BY 1, 2;

-- Show Percentage of Total Cases over Population
SELECT location, date, population, total_cases, (total_cases/population)*100 AS CasesPercentage
FROM Covid_Europe.covid_deaths_europe
WHERE location = 'Germany'
ORDER BY 1, 2;

-- Show European Countries with Highest Infection Rate over Population
SELECT location, population, max(total_cases) AS HighestInfectionRate, max((total_cases/population))*100 AS InfectedOverPopulationPercentage
FROM Covid_Europe.covid_deaths_europe
GROUP BY location, population
ORDER BY InfectedOverPopulationPercentage DESC;

-- Show European Countries with Highest Death Rate
SELECT location, max(total_deaths) AS TotalDeaths
FROM Covid_Europe.covid_deaths_europe
GROUP BY location
ORDER BY TotalDeaths DESC;

-- Show Percentage of Deaths over Infections
SELECT date, sum(new_cases), sum(new_deaths), (sum(new_deaths)/sum(new_cases))*100 AS DeathsOverInfectionPercentage
FROM Covid_Europe.covid_deaths_europe
GROUP BY date
ORDER BY 1, 2;

-- Show Total Percentage of Total Deaths over Total Infections
SELECT sum(new_cases), sum(new_deaths), (sum(new_deaths)/sum(new_cases))*100 AS DeathsOverInfectionPercentage
FROM Covid_Europe.covid_deaths_europe
ORDER BY 1, 2;

-- Join Tables covid_deaths_europe & covid_vaccination_europe
-- Show Percentage of People Vaccinated
SELECT d.location, d.date, d.population, v.people_vaccinated, (v.people_vaccinated/population)*100 AS PercentageOfPeopleVaccinated
FROM Covid_Europe.covid_deaths_europe d
JOIN Covid_Europe.covid_vaccination_europe v
	ON d.location = v.location
	AND d.date = v.date
ORDER BY 1,2;


-- Drop Table
DROP TABLE IF EXISTS covid_vaccination_percentage_europe;

-- Create Table
CREATE TABLE covid_vaccination_percentage_europe
(
location text,
date datetime,
population numeric,
people_vaccinated text,
PercentageOfPeopleVaccinated numeric
);

-- Insert Into New Table Percentage of People Vaccinated
INSERT INTO covid_vaccination_percentage_europe
SELECT d.location, d.date, d.population, v.people_vaccinated, (v.people_vaccinated/population)*100 AS PercentageOfPeopleVaccinated
FROM Covid_Europe.covid_deaths_europe d
JOIN Covid_Europe.covid_vaccination_europe v
	ON d.location = v.location
	AND d.date = v.date
ORDER BY 1,2;

SELECT *
FROM covid_vaccination_percentage_europe;

-- Drop View
DROP VIEW IF EXISTS covid_vaccination_percentage_europe_view;

-- Create View Show Percentage of People Vaccinated
CREATE VIEW covid_vaccination_percentage_europe_view AS
SELECT d.location, d.date, d.population, v.people_vaccinated, (v.people_vaccinated/population)*100 AS PercentageOfPeopleVaccinated
FROM Covid_Europe.covid_deaths_europe d
JOIN Covid_Europe.covid_vaccination_europe v
	ON d.location = v.location
	AND d.date = v.date;