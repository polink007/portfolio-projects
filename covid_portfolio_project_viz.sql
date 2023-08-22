SELECT *
FROM `myportfolio-396320.covid.covid_deaths`
WHERE continent is not NULL
ORDER BY 3, 4

-- Select data that I am going to be using

SELECT
  location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
FROM
  `myportfolio-396320.covid.covid_deaths`
ORDER BY 1, 2


-- Loking at Total Cases VS Total Deaths

SELECT
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS death_percentage
FROM
  `myportfolio-396320.covid.covid_deaths`
ORDER BY 1, 2


-- Looking at Total Cases VS Population

SELECT
  location,
  date,
  population,
  total_cases,
  (total_cases/population)*100 AS percent_of_population_infected
FROM
  `myportfolio-396320.covid.covid_deaths`
WHERE location = "United States"
ORDER BY 1, 2


-- Looking at Countries with Highest Infection rate compared to Population

SELECT
  location,
  population,
  MAX(total_cases) AS highest_infection_count,
  MAX((total_cases/population))*100 AS percent_of_population_infected
FROM
  `myportfolio-396320.covid.covid_deaths`
GROUP BY
  location,
  population
ORDER BY percent_of_population_infected DESC


-- Showing Countries with Highest Death Count per Population

SELECT
  location,
  MAX(total_deaths) AS highest_death_count
FROM
  `myportfolio-396320.covid.covid_deaths`
WHERE continent IS NOT NULL
GROUP BY
  location
ORDER BY highest_death_count DESC

-- Showing Continents with Highest Death Count per Population

SELECT
  location,
  MAX(total_deaths) AS highest_death_count
FROM
  `myportfolio-396320.covid.covid_deaths`
WHERE continent IS NULL
GROUP BY
  location
ORDER BY highest_death_count DESC

--
SELECT
  continent,
  MAX(total_deaths) AS highest_death_count
FROM
  `myportfolio-396320.covid.covid_deaths`
WHERE continent IS NOT NULL
GROUP BY
  continent
ORDER BY highest_death_count DESC

-- Global numbers

SELECT
  SUM(new_cases) AS total_cases,
  SUM(new_deaths) AS total_deaths,
  SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
  `myportfolio-396320.covid.covid_deaths`
WHERE
  continent IS NOT NULL
ORDER BY
  1, 2
  
-- Looking at Total Population vs Vaccinations

SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_people_vaccinated
  FROM
    `myportfolio-396320.covid.covid_vaccines` AS vac
  JOIN
    `myportfolio-396320.covid.covid_deaths` AS dea
    ON dea.location = vac.location
    AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
  ORDER BY 2, 3
  
-- Use CTE

WITH pop_vs_vac AS (
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_people_vaccinated
  FROM
    `myportfolio-396320.covid.covid_vaccines` AS vac
  JOIN
    `myportfolio-396320.covid.covid_deaths` AS dea
    ON dea.location = vac.location
    AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
)
SELECT *,
  (rolling_people_vaccinated / population) * 100 AS vaccination_percentage
FROM pop_vs_vac;

-- Creating view to store data for later visualizations

CREATE VIEW covid.pop_vs_vac AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_people_vaccinated
  FROM
    `myportfolio-396320.covid.covid_vaccines` AS vac
  JOIN
    `myportfolio-396320.covid.covid_deaths` AS dea
    ON dea.location = vac.location AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL;


SELECT *
FROM covid.pop_vs_vac