select *
from CovidProject..CovidDeaths$
order by 3,4

--select *
--from CovidVaccinations$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from CovidProject..CovidDeaths$
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in Turkey
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths$
where location like '%Turkey%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
select location, date, population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
from CovidProject..CovidDeaths$
--where location like '%Turkey%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from CovidProject..CovidDeaths$
--where location like '%Turkey%'
group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Death Count per Population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

--Let's Break Things Down by Continent

--Showing Continents with the Highest Death Count per Population
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths$
where continent is not null
group by date
order by 1,2

-- Looking at Total Population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated / population)*100
from CovidProject..CovidDeaths$ dea
join CovidProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
With PopulationvsVaccination (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated / population)*100
from CovidProject..CovidDeaths$ dea
join CovidProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100 as PercentageRollingPeopleVaccinated
from PopulationvsVaccination

----TEMP TABLE
--DROP Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--continent nvarchar(225),
--location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)
--Insert into #PercentPopulationVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
----	, (RollingPeopleVaccinated / population)*100
--from CovidProject..CovidDeaths$ dea
--join CovidProject..CovidVaccinations$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date
----where dea.continent is not null

--select *, (RollingPeopleVaccinated/population)*100
--from #PercentPopulationVaccinated



