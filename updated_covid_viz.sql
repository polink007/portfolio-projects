SELECT *
FROM
  `myportfolio-396320.new_covid_data.covid_data_updated`
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
  `myportfolio-396320.new_covid_data.covid_data_updated`
ORDER BY 1, 2

-- Looking at Total Cases VS Population

SELECT
  location,
  date,
  population,
  total_cases,
  (total_cases/population)*100 AS percent_of_population_infected
FROM
  `myportfolio-396320.new_covid_data.covid_data_updated`
WHERE location = "United States"
ORDER BY 1, 2

-- Looking at Countries with Highest Infection rate compared to Population

SELECT
  location,
  population,
  MAX(total_cases) AS highest_infection_count,
  MAX((total_cases/population))*100 AS percent_of_population_infected
FROM
  `myportfolio-396320.new_covid_data.covid_data_updated`
WHERE continent IS NOT NULL
GROUP BY
  location,
  population
ORDER BY percent_of_population_infected DESC

-- Showing Countries with Highest Death Count per Population

SELECT
  location,
  MAX(total_deaths) AS highest_death_count
FROM
  `myportfolio-396320.new_covid_data.covid_data_updated`
WHERE continent IS NOT NULL
GROUP BY
  location
ORDER BY highest_death_count DESC

-- Global numbers

SELECT
  SUM(new_cases) AS total_cases,
  SUM(new_deaths) AS total_deaths,
  SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
  `myportfolio-396320.new_covid_data.covid_data_updated`
WHERE
  continent IS NOT NULL
ORDER BY
  1, 2

-- Looking at Total Population vs Vaccinations

SELECT
    continent,
    location,
    date,
    population,
    new_vaccinations,
    SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY date) AS rolling_people_vaccinated
FROM
    `myportfolio-396320.new_covid_data.covid_data_updated`
WHERE continent IS NOT NULL
  ORDER BY 2, 3

-- Creating view to store data for later visualizations

CREATE VIEW covid.new_pop_vs_vac AS
SELECT
    continent,
    location,
    date,
    population,
    new_vaccinations,
    SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY date) AS rolling_people_vaccinated
FROM
    `myportfolio-396320.new_covid_data.covid_data_updated`
WHERE continent IS NOT NULL;


SELECT *
FROM covid.new_pop_vs_vac