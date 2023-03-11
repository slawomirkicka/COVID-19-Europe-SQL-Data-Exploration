-- 1. Total Deaths over Total Infections
SELECT
	sum(new_cases),
	sum(new_deaths),
	(sum(new_deaths) / sum(new_cases)) * 100 AS TotalDeathOverTotalInfectionsPercentage
FROM
	Covid_Europe.covid_deaths_europe
ORDER BY
	1,
	2;


-- 2. Total Death
SELECT
	location,
	sum(new_deaths) AS TotalDeathCount
FROM
	Covid_Europe.covid_deaths_europe
GROUP BY
	location
ORDER BY
	TotalDeathCount DESC;


-- 3. Infections
SELECT
	location,
	population,
	max(total_cases) AS HighestInfectionCount,
	max((total_cases / population)) * 100 AS HighestInfectionPercentage
FROM
	Covid_Europe.covid_deaths_europe
GROUP BY
	location,
	population
ORDER BY
	HighestInfectionPercentage DESC;


-- 4. Infections by Date
SELECT
	location,
	population,
	date,
	max(total_cases) AS HighestInfectionCount,
	max((total_cases / population)) * 100 AS HighestInfectionPercentage
FROM
	Covid_Europe.covid_deaths_europe
GROUP BY
	location,
	population,
	date
ORDER BY
	date DESC;
