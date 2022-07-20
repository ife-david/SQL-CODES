SELECT *
FROM PortfolioProjects.dbo.CovidDeaths$
WHERE continent is not Null
ORDER BY 3,4


--SELECT *
--FROM PortfolioProjects..CovidVaccinations$
--ORDER BY 3,4

--Total Cases vs Total Deaths

--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM PortfolioProjects..CovidDeaths$
--WHERE location = 'Nigeria'
--ORDER BY 1,2

--Covid cases in Nigeria
SELECT location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
FROM PortfolioProjects..CovidDeaths$
WHERE location = 'Nigeria'
ORDER BY 1,2

--Looking at countriess with Highest Infection rate compared to Population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount ,MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM PortfolioProjects..CovidDeaths$
GROUP BY population, location
ORDER BY PercentagePopulationInfected DESC

--Countries with Highest deaths per population
SELECT location, MAX(cast(total_deaths as int)) AS totaldeathCount
FROM PortfolioProjects..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY totaldeathCount DESC

--Working with continent
SELECT location, MAX(cast(total_deaths as int)) AS totaldeathCount
FROM PortfolioProjects..CovidDeaths$
WHERE continent IS NULL
GROUP BY location
ORDER BY totaldeathCount DESC

--Global Numbers
SELECT SUM(new_cases) AS SumOfNewCases, SUM(CAST(new_deaths AS int)) AS SumofNewDeaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProjects..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1,2

--SELECT location, MAX(CAST(total_deaths AS int))
--FROM PortfolioProjects..CovidDeaths$
--WHERE location = 'Nigeria'
--GROUP BY location


SELECT*
FROM PortfolioProjects.dbo.CovidDeaths$ dea
JOIN PortfolioProjects.dbo.CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date

--Total Population Vs Vaccination
SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
,SUM(CONVERT(int,new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects.dbo.CovidDeaths$ dea
JOIN PortfolioProjects.dbo.CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


--USE CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,new_vaccinations)) OVER (Partition by dea.location order by dea.location,
	dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects.dbo.CovidDeaths$ dea
JOIN PortfolioProjects.dbo.CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent IS NOT NULL
--order by 2,3
)
SELECT*, (RollingPeopleVaccinated/population) *100
FROM PopvsVac


--TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,new_vaccinations)) OVER (Partition by dea.location order by dea.location,
	dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects.dbo.CovidDeaths$ dea
JOIN PortfolioProjects.dbo.CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent IS NOT NULL
--order by 2,3

SELECT*, (RollingPeopleVaccinated/population) *100
FROM #PercentPopulationVaccinated

--CREATING VIEW FOR LATER VISUALIZATION
Create View PercentPopulationVaccinate as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,new_vaccinations)) OVER (Partition by dea.location order by dea.location,
	dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects.dbo.CovidDeaths$ dea
JOIN PortfolioProjects.dbo.CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent IS NOT NULL
--order by 2,3