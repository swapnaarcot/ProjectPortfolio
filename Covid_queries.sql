select * from CovidDeaths 
where continent is not NULL
order by 3,4

select * from CovidVaccinations order by 3,4

--Select Data that we are using


select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths 
where continent is not NULL
order by 1,2


--Total cases vs Total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercent
from CovidDeaths 
where location = 'India'
order by 1,2


--Total cases vs Population

select location,date,population,total_cases,(total_cases/population)*100 as PopulationPercentAffected
from CovidDeaths 
where location = 'India'
order by 1,2

--Highest infection rate country-wise

select location,population,max(total_cases) as HighestCases,max(total_cases/population)*100 as PopulationPercentAffected
from CovidDeaths 
group by location,population
order by PopulationPercentAffected desc

--Highest death rate country-wise

select location,max(total_deaths) as HighestDeaths
from CovidDeaths 
where continent is not NULL
group by location,population
order by HighestDeaths desc

--Continent-wise Data

select continent,max(total_deaths) as HighestDeaths
from CovidDeaths 
where continent is not NULL
group by continent
order by HighestDeaths desc

--Global numbers

select date,sum(new_cases) as NewCases
from CovidDeaths 
where continent is not NULL
group by date 
order by 1 desc

select date,sum(new_cases) as NewCases,sum(total_deaths) as TotalDeaths, (sum(total_deaths)/sum(new_cases))*100 as DeathPercentage
from CovidDeaths 
where continent is not NULL
group by date 
order by 1 desc

select sum(new_cases) as NewCases,sum(total_deaths) as TotalDeaths, (sum(total_deaths)/sum(new_cases))*100 as DeathPercentage
from CovidDeaths 
where continent is not NULL

---Total Population vs Vaccinates--

select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
from CovidDeaths cd
join CovidVaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not NULL
order by 2,3

select cd.continent,cd.location,cd.date,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.date) as Rolling_Sum_Newvaccinations
from CovidDeaths cd
join CovidVaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not NULL
order by 2,3

---Percentage of people vaccinated in each country

with cte as 
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.date) as Rolling_Sum_Newvaccinations
from CovidDeaths cd
join CovidVaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not NULL
)
select *,(Rolling_Sum_Newvaccinations/population)*100 as Percentage_Vaccinated from cte


with cte as 
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.date) as Rolling_Sum_Newvaccinations
from CovidDeaths cd
join CovidVaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not NULL
)
select continent,location,max(Rolling_Sum_Newvaccinations/population)*100 as Percentage_Vaccinated from cte 
group by continent,location
order by continent,location



---create view

create view PercentVarccinated as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.date) as Rolling_Sum_Newvaccinations
from CovidDeaths cd
join CovidVaccinations cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not NULL





