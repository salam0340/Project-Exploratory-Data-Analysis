-- Project Exploratory Data Analysis

-- Query for showing the dataset table
select * from layoffs_working2;

-- Easy Queries
select max(total_laid_off)
from layoffs_working2;

-- Looking at Percentage to see how big these layoffs were
select max(percentage_laid_off),min(percentage_laid_off)
from layoffs_working2
where percentage_laid_off is not null;

-- Which companies had 1 which is basically 100 percent of they company laid off
select * from layoffs_working2
where percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
select * from layoffs_working2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Companies with the biggest single Layoff
select company,total_laid_off
from layoffs_working2
order by 2 desc
limit 5;
-- now that's just on a single day

-- Companies with the most Total Layoffs
select company,sum(total_laid_off)
from layoffs_working2
group by company
order by 2 desc
limit 10;

-- by location
select location,sum(total_laid_off)
from layoffs_working2
group by location
order by 2 desc
limit 10;

-- this it total in the past 3 years or in the dataset
select country,sum(total_laid_off)
from layoffs_working2
group by country
order by 2 desc;

select year(date),sum(total_laid_off)
from layoffs_working2
group by year(date)
order by 1 asc;

select industry,sum(total_laid_off)
from layoffs_working2
group by industry
order by 2 desc;

select stage,sum(total_laid_off)
from layoffs_working2
group by stage
order by 2 desc;

-- TOUGHER QUERIES------------------------------------------------------------------------------------------------------------------------------------

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.
-- I want to look at 
with Company_year as
(
	select company,year(date) years,sum(total_laid_off) total_laid_off
    from layoffs_working2
    group by company,year(date)
), Company_year_rank as
(
select company,years,total_laid_off,dense_rank() over(partition by years order by total_laid_off desc) Ranking
from Company_year
)
select company,years,total_laid_off,Ranking
from Company_year_rank
where Ranking <=5
and total_laid_off is not null
order by years asc,total_laid_off desc;

-- Rolling Total of Layoffs Per Month
select substring(date,1,7) dates,sum(total_laid_off) total_laid_off
from layoffs_working2
group by date
order by date asc;

-- now use it in a CTE so we can query off of it
with Date_cte as
(
select substring(date,1,7) dates,sum(total_laid_off) total_laid_off
from layoffs_working2
group by date
order by date asc
)
select dates,sum(total_laid_off) over(order by dates asc) Rolling_total_laid_off
from Date_cte
order by dates asc;

