select *
from PortfolioProject..['CovidVaccinations$']
where continent is not null;
--select Data that we are going to be using

select Location, Date, total_cases, new_cases, total_deaths,Population 
from PortfolioProject..['CovidDeaths$']
order by 1,2;

--loking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select Location, Date, total_cases, total_deaths,(total_deaths/total_cases)*100 DeathPercentage
from PortfolioProject..['CovidDeaths$']
where location like '%Israel%'
order by 1,2;

--Looking at Total cases vs Population
--SHows what percentage of population got covid

select Location, Date, population, total_cases,(total_cases/population)*100 PercentPopulationInfected
from PortfolioProject..['CovidDeaths$']
where location like '%Israel%'
order by 1,2;


select Location, population, max(total_cases) as HighstInfactionCount,max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..['CovidDeaths$']
--where location like '%Israel%'
group by Location, population
order by PercentPopulationInfected desc;

--Showing Countries with highest Death Count per Population

select Location,max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..['CovidDeaths$']
where continent is not null
group by Location, population
order by TotalDeathCount desc;


--Showing the Continent with the highst 

select Location,max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..['CovidDeaths$']
where continent is null
group by Location, population
order by TotalDeathCount desc;

-- Global Numbers

select  date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPrecentage
from PortfolioProject..['CovidDeaths$']
--where location like '%Israel%'
where continent is not null
group by date 
order by 1,2;

select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPrecentage
from PortfolioProject..['CovidDeaths$']
--where location like '%Israel%'
where continent is not null
order by 1,2;



select dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolingPeopleVaccinations
from PortfolioProject..['CovidDeaths$'] dea
join PortfolioProject..['CovidVaccinations$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


with PopvsVac (continent, location, date, population ,new_vaccinations, RolingPeopleVaccinations)
as
(
select dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolingPeopleVaccinations
from PortfolioProject..['CovidDeaths$'] dea
join PortfolioProject..['CovidVaccinations$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RolingPeopleVaccinations/population)*100
from PopvsVac

create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolingPeopleVaccinations
from PortfolioProject..['CovidDeaths$'] dea
join PortfolioProject..['CovidVaccinations$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

