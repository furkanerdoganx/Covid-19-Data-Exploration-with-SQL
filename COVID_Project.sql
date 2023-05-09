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



