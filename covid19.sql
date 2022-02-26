select *
from portfolioproject1 . . deaths
WHERE continent is not null
ORDER BY 3, 4

--select *
--from portfolioproject1 . . covidvacc
--ORDER BY 3, 4

SELECT Location,date, total_cases,new_cases,total_deaths, population 
from portfolioproject1 . .deaths
order by 1,2
--LOOKING AT TOTAL CASES VS TOTAL DEATHS  PER COUNTRY PERCENTAGE OF DEATH(united states)
--likelyhood of dying if you contract covid 19

SELECT Location,date, total_cases,total_deaths,(total_deaths/total_cases)* 100 as Death_Percentage
from portfolioproject1 . .deaths
where location like  '%states%' and  continent is not null
order by 1,2

--looking at tota; cases vs population
--shows what a percentage of population got covid
SELECT 
Location , max(total_cases) as HighestInfectionCount ,
population ,
max((total_cases/population))* 100 as PercentagePopulationInfected
from portfolioproject1 . .deaths
--where location like  '%states%'
GROUP BY location,population
order by 4 desc

--SHOWING the countries highest death_count per population
SELECT 
Location , max(cast(total_deaths as INT)) as TotalDeathCount 
from portfolioproject1 . .deaths
where continent is not null
--where location like  '%states%'
GROUP BY location
order by 2 desc

--lets break things based on continent--


SELECT 
location , max(cast(total_deaths as INT)) as TotalDeathCount 
from portfolioproject1 . .deaths
where continent is null and location not like'%Lower middle income%' and location not like'%Upper middle income%' 
AND location not like'%Low Income%' and location not like'%high income%'
--where location like  '%states%'
GROUP BY location
order by 2 desc
--showing the continets with the highest death count
SELECT 
continent , max(cast(total_deaths as INT)) as TotalDeathCount 
from portfolioproject1 . .deaths
where continent is not null
group by continent
order by 2 desc

-- caluculate Global numbers
SELECT date,  sum(new_cases) as totalCases,sum(cast(new_deaths as int)) as totalDeaths,sum(cast(new_deaths as int))/SUM(new_cases) as Death_Percentage
from portfolioproject1 . .deaths
where   continent is not null
group by date
order by 1,2

--total cases,total deaths,death_percentage of the world
SELECT  sum(new_cases) as totalCases,sum(cast(new_deaths as int)) as totalDeaths,sum(cast(new_deaths as int))/SUM(new_cases) as Death_Percentage
from portfolioproject1 . .deaths
where   continent is not null
--group by date
order by 1,2


--JOINING TABLES
--LOOKING AT TOTAL POPULATION VS VACCINATIONS

SELECT dea. continent, dea.location,dea.date,dea.population, vac.new_vaccinations ,
 sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS Rooling_people_vaccinated,

from portfolioproject1. . deaths  dea
JOIN  portfolioproject1. . covidvacc  vac
ON DEA.location = VAC.location 
AND DEA.date = VAC.date
WHERE dea.continent is not null
order by 2,3

--use of CTE\
with popvsvac (continent, location ,date, population, new_vaccinations,Rooling_people_vaccinated)
as
(SELECT dea. continent, dea.location, dea.date , dea.population , vac.new_vaccinations ,
 sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS Rooling_people_vaccinated
 --,( Rooling_people_vaccinated/population)*100
from portfolioproject1. . deaths  dea
JOIN  portfolioproject1. . covidvacc  vac
ON DEA.location = VAC.location 
AND DEA.date = VAC.date
WHERE dea.continent is not null
--order by 2,3
)
select *,( Rooling_people_vaccinated/population)  *100  as Rolling_percentage
from popvsvac


-- using temp table
DROP TABLE if exists  #PercentPoppulationVaccinate
CREATE TABLE #PercentPoppulationVaccinate
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
Rooling_people_vaccinated numeric)

insert into #PercentPoppulationVaccinate
SELECT dea. continent, dea.location, dea.date , dea.population , vac.new_vaccinations ,
 sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS Rooling_people_vaccinated
 --,( Rooling_people_vaccinated/population)*100
from portfolioproject1. . deaths  dea
JOIN  portfolioproject1. . covidvacc  vac
ON DEA.location = VAC.location 
AND DEA.date = VAC.date
--WHERE dea.continent is not null
--order by 2,3
select *,( Rooling_people_vaccinated/population)  *100  as Rolling_percentage
from #PercentPoppulationVaccinate

-- /*VIEW FOR VISUALISATION*/

--VIEW PercentPoppulationVaccinate 
DROP view  PercentPoppulationVaccinate 
CREATE VIEW PercentPoppulationVaccinate as
SELECT dea. continent, dea.location, dea.date , dea.population , vac.new_vaccinations ,
 sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS Rooling_people_vaccinated
 --,( Rooling_people_vaccinated/population)*100
from portfolioproject1. . deaths  dea
JOIN  portfolioproject1. . covidvacc  vac
ON DEA.location = VAC.location 
AND DEA.date = VAC.date
WHERE dea.continent is not null
--order by 2,3

-- VIEW FOR --shows what a percentage of population got covid
CREATE VIEW Death_Percentage
as
SELECT Location,date, total_cases,total_deaths,(total_deaths/total_cases)* 100 as Death_Percentage
from portfolioproject1 . .deaths
where location like  '%states%' and  continent is not null
order by 1,2

--view for PercentagePopulationInfected

create view PercentagePopulationInfected as

SELECT 
Location , max(total_cases) as HighestInfectionCount ,
population ,
max((total_cases/population))* 100 as PercentagePopulationInfected
from portfolioproject1 . .deaths
--where location like  '%states%'
GROUP BY location,population
order by 4 desc

-- view forTotal_death _count
create view TotalDeathCount as
SELECT 
Location , max(cast(total_deaths as INT)) as TotalDeathCount 
from portfolioproject1 . .deaths
where continent is not null
--where location like  '%states%'
GROUP BY location

-- view for total death count based on continent
create view death_count_continent as
SELECT 
continent , max(cast(total_deaths as INT)) as TotalDeathCount 
from portfolioproject1 . .deaths
where continent is not null
group by continent
order by 2 desc

--view deathpercentage globally
create view DeathPercentageGlobally as
SELECT date,  sum(new_cases) as totalCases,sum(cast(new_deaths as int)) as totalDeaths,sum(cast(new_deaths as int))/SUM(new_cases) as Death_Percentage
from portfolioproject1 . .deaths
where   continent is not null
group by date

-- view for toal_numbers of death vaccinations 
create view card_1 as
SELECT  sum(new_cases) as totalCases,sum(cast(new_deaths as int)) as totalDeaths,sum(cast(new_deaths as int))/SUM(new_cases) as Death_Percentage
from portfolioproject1 . .deaths
where   continent is not null
--group by date
order by 1,2


