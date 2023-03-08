-- We will be exploring the data on confirmed COVID-19 deaths and the vaccination process in Europe by using SQL to query the data and look for patterns and trends. We will be looking at things like the countries with the most deaths, and the relationship between the vaccination process and the number of deaths.

-- We have two tables, covid_deaths_europe, and covid_vaccination_europe.

-- Show table covid_deaths_europe
SELECT *
FROM Covid_Europe.covid_deaths_europe
ORDER BY 3, 4;

-- Show table covid_vaccination_europe
SELECT *
FROM Covid_Europe.covid_vaccination_europe
ORDER BY 3, 4;

-- The first step is to identify the columns that will be used in the analysis. For this project, we will use the columns location, date, total_cases, new_cases, total_deaths, and population.

-- Show Selected Data from Table covid_deaths_europe
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid_Europe.covid_deaths_europe
ORDER BY 1, 2;

-- The next step is to show the percentage of total cases over total deaths. This will show how many people have died from COVID-19 in Europe as a percentage of the total number of cases.

-- Show Percentage of Total Cases over Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Covid_Europe.covid_deaths_europe
ORDER BY 1, 2;

-- I live in Germany so let's have a quick look at the situation in the country. As of 26th of Feb 2023, there were 38111063 total cases in Germany and there were 167812 total deaths which are 0.4%. So basically there is a 0.4% likelihood of dying for someone who lives in Germany and got covid.

-- Show Percentage of Total Cases over Total Deaths in Germany
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Covid_Europe.covid_deaths_europe
WHERE location = 'Germany'
ORDER BY 1, 2 desc;

-- The next step is to show the percentage of total cases over the population. Let's have a look again at Germany. This will give us an idea of how widespread the virus is and how many people have been infected in the country.

-- Show Percentage of Total Cases over Population in Germany
SELECT location, date, population, total_cases, (total_cases/population)*100 AS CasesPercentage
FROM Covid_Europe.covid_deaths_europe
WHERE location = 'Germany'
ORDER BY 1, 2;

-- The population in Germany is around 83369800, so on 27/01/2020 we had 1 case which is nothing, but later on 19/11/2020, we see 1% of the total population (855916 people) in Germany got infected. On 21/01/2022 we see that 10% of the total population (8460546.0) has been confirmed as infected.

-- In this step let's have a look at countries with the highest infection rate. This will help to identify which locations are most at risk for further outbreaks. Additionally, this information can help to inform future prevention and response strategies.

-- Show European Countries with Highest Infection Rate over Population
SELECT location, population, max(total_cases) AS HighestInfectionRate, max((total_cases/population))*100 AS InfectedOverPopulationPercentage
FROM Covid_Europe.covid_deaths_europe
GROUP BY location, population
ORDER BY InfectedOverPopulationPercentage DESC;

-- So the very first one has a small population, which is not surprising, but if we look down we see that for example, Germany is in 22 positions with 45% population infected. France has 58% population infected and Poland has 16% population infected.

-- Let's look at how many people actually died. 

-- Show European Countries with Highest Death Rate
SELECT location, max(total_deaths) AS TotalDeaths
FROM Covid_Europe.covid_deaths_europe
GROUP BY location
ORDER BY TotalDeaths DESC;

-- While Germany's death rate is relatively high (167812 deaths), it is still lower than the death rate of United Kingdom (218948 deaths) and Italy (188094 deaths). These three countries have been hit the hardest by the pandemic and have the highest death rates.

-- The results of the query show the percentage of deaths over infections for each country in Europe.

-- Show Percentage of Deaths over Infections
SELECT date, sum(new_cases), sum(new_deaths), (sum(new_deaths)/sum(new_cases))*100 AS DeathsOverInfectionPercentage
FROM Covid_Europe.covid_deaths_europe
GROUP BY date
ORDER BY 1, 2;

-- Comparing the percentage of deaths to the percentage of infections, we can see that there is a direct correlation between the two. The countries with the highest percentage of deaths also have the highest percentage of infections. This suggests that the majority of people who become infected with COVID-19 will eventually die from the disease.

-- Next, we will show the total percentage of total deaths over total infections. This will help us to understand the mortality rate of the virus in Europe.

-- Show Total Percentage of Total Deaths over Total Infections
SELECT sum(new_cases), sum(new_deaths), (sum(new_deaths)/sum(new_cases))*100 AS DeathsOverInfectionPercentage
FROM Covid_Europe.covid_deaths_europe
ORDER BY 1, 2;

-- So we see that 2032760 died in Europe and 247591655 got infected. So the death percentage is 0.8210.

-- Now, let's join our tables covid_deaths_europe & covid_vaccination_europe on location and date. This will help us to see the percentage of people vaccinated over population.

-- Show Percentage of People Vaccinated
SELECT d.location, d.date, d.population, v.people_vaccinated, (v.people_vaccinated/population)*100 AS PeopleVaccinatedPercentage
FROM Covid_Europe.covid_deaths_europe d
JOIN Covid_Europe.covid_vaccination_europe v
	ON d.location = v.location
	AND d.date = v.date
ORDER BY 1,2;


-- Drop Table
DROP TABLE IF EXISTS covid_vaccination_percentage_europe;


-- Now, we will create a new table called covid_vaccination_percentage_europe with 5 columns: location, date, population, people_vaccinated, and PercentageOfPeopleVaccinated.

-- Create Table
CREATE TABLE covid_vaccination_percentage_europe
(
location text,
date datetime,
population numeric,
people_vaccinated text,
PeopleVaccinatedPercentage numeric
);

-- With SQL query we will insert values into the covid_vaccination_percentage_europe table by taking the location and date from the covid_deaths_europe table and the population and people_vaccinated from the covid_vaccination_europe table. It is then calculating the percentage of people vaccinated and inserts that value into the PercentageOfPeopleVaccinated column.

-- Insert Into New Table Percentage of People Vaccinated
INSERT INTO covid_vaccination_percentage_europe
SELECT d.location, d.date, d.population, v.people_vaccinated, (v.people_vaccinated/population)*100 AS PeopleVaccinatedPercentage
FROM Covid_Europe.covid_deaths_europe d
JOIN Covid_Europe.covid_vaccination_europe v
	ON d.location = v.location
	AND d.date = v.date
ORDER BY 1,2;

-- Show table covid_vaccination_percentage_europe
SELECT *
FROM covid_vaccination_percentage_europe;

-- Drop View
DROP VIEW IF EXISTS covid_vaccination_percentage_europe_view;


-- Finally, we will create a view for our visualization. The view includes the location, date, population, people_vaccinated, and PeopleVaccinatedPercentage columns.

-- Create View Show Percentage of People Vaccinated
CREATE VIEW covid_vaccination_percentage_europe_view AS
SELECT d.location, d.date, d.population, v.people_vaccinated, (v.people_vaccinated/population)*100 AS PeopleVaccinatedPercentage
FROM Covid_Europe.covid_deaths_europe d
JOIN Covid_Europe.covid_vaccination_europe v
	ON d.location = v.location
	AND d.date = v.date;