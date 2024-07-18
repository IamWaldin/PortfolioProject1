--BELOW ARE 15 QUERIES THAT I RAN TO EXPLORE MY DATA.
--THE PURPOSE OF THIS PROJECT IS TO CREATE QUERIES THAT I WILL USE IN ANOTHER 
--TABLEAU PROJECT TO BUILD POWERFUL VISUALIZATIONS.
--PLEASE TAKE NOTE OF THE COMMENTS AS THEY ALL GIVE A DESCRIPTION OF THE QUERY THAT FOLLOWS BELOW

Select*
From PortfolioProject..covid-deaths
Where continent is not null
order by 3,4

--Select*
--From PortfolioProject..covid-vaccinations
--order by 3,4

--Select Data that we are going to be using


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..covid-deaths
Where continent is not null
order by 1,2


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
 
Select Location, date, total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..['covid-deaths']
where location like '%South_Africa%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid


Select Location, date, Population, total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as PercentpopulationInfected
From PortfolioProject..['covid-deaths']
where location like '%South_Africa%'
order by 1,2

--looking at the highest infection rate in South Africa

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..['covid-deaths']
Where Location like 'South_Africa'
group by location, Population
order by PercentPopulationInfected

--looking at countries with highest infection rate compared to Popultion

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..['covid-deaths']
--Where Location like 'South_Africa'
group by location, Population
order by PercentPopulationInfected desc

--showing continents with the highest death count per population

select continent, MAX(cast(Total_deaths as int)) as totalDeathCount
from PortfolioProject..['covid-deaths']
--where location like '%South_Africa%'
where continent is not null
group by continent
order by totalDeathCount desc

--Global Numbers

Select Location, date, total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..['covid-deaths']
--where location like '%South_Africa%'
where continent is not null
order by 1,2

--looking at total poulation vs vaccination

select *
from PortfolioProject..['covid-deaths'] dea
join PortfolioProject..['covid-vaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date

	--debug this code

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
from PortfolioProject..['covid-deaths'] dea
Join PortfolioProject..['covid-vaccinations'] vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--Create Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeoplevaccinated numeric
)

--creating a View to store data for later Visualizations

Create View HighestDeatCountperContinent as
Select continent, MAX(cast(Total_deaths as int)) as totalDeathCount
from PortfolioProject..['covid-deaths']
--where location like '%South_Africa%'
where continent is not null
group by continent
--order by totalDeathCount desc


select *
from HighestDeatCountperContinent
