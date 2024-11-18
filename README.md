# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix Logo](https://github.com/chandum-04/Netflix-_sql_project/blob/main/Netflixlogo.png?raw=true)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README file provides a detailed account of the project's objectives, business problems, solutions.

## Objectives
1. Analyze the distribution of content types (movies vs TV shows).
2. Identify the most common ratings for movies and TV shows.
3. List and analyze content based on release years, countries, and durations.
4. Explore and categorize content based on specific criteria and keywords.

## Dataset 
**The data for this project is sourced from the Kaggle dataset**


## Schema
```
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
# Business Problems and Solutions
## 1. Count the Number of Movies vs TV Shows
```
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
**Objective: Determine the distribution of content types on Netflix.**

## 2. Find the Most Common Rating for Movies and TV Shows
```
select 
     type,
     rating
from
     (select
	type,
	rating,
	count(show_id) as total_rate,
	rank() over(partition by type order by count(show_id) desc) as ranking
      from netflix
      group by type,rating
      ) as t1
where ranking = 1;
```

**Objective: Identify the most frequently occurring rating for each type of content.**

## 3. List All Movies Released in a Specific Year (e.g., 2020)
```
select * from netflix
where 
  type = 'Movie'
  and release_year = 2020;
```
**Objective: Retrieve all movies released in a specific year.**

## 4. Find the Top 5 Countries with the Most Content on Netflix
```
select 
    unnest(string_to_array(country,',')) as new_country,
    count(*) as total
from netflix
group by 1
order by total desc
limit 5;
```
**Objective: Identify the top 5 countries with the highest number of content items.**

## 5. Identify the Longest Movie
select * from netflix
where 
     type = 'Movie'
     and 
     duration = (select max(duration) from netflix);

**Objective: Find the movie with the longest duration.**

## 6. Find Content Added in the Last 5 Years
```
SELECT *
FROM netflix
WHERE 
     TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective: Retrieve content added to Netflix in the last 5 years**


## 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

** Using ilike 
```
select * from netflix
where director ilike '%Rajiv Chilaka%';
```
** Using Operator 
```
select * from netflix
where director = 'Rajiv Chilaka';
```
**Objective: List all content directed by 'Rajiv Chilaka'.**

## 8. List All TV Shows with More Than 5 Seasons

```
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```
```
select *
from netflix
where 
    type = 'TV Show'
    and 
    split_part(duration,' ',1) >'5 seasons';
```
```	
select  *
from netflix
where 
     type = 'TV Show'
     and 
     duration > '5 seasons'
```
**Objective: Identify TV shows with more than 5 seasons.**

## 9. Count the Number of Content Items in Each Genre
```
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```
**Objective: Count the number of content items in each genre.**

## 10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!
```
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```
**Objective: Calculate and rank years by the average number of content releases by India.**

## 11. List All Movies that are Documentaries
```
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries%';
```
**Objective: Retrieve all movies classified as documentaries.**

## 12. Find All Content Without a Director
```
SELECT * 
FROM netflix
WHERE director IS NULL;
```
**Objective: List content that does not have a director.**

## 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
    AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
**Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.**

## 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```
select
     unnest(string_to_array(casts,',')) as actors,
     count(show_id) as total_count
from netflix
where country ilike '%india%'
group by actors
order by count(show_id) desc
limit 10;
```
**Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.**

## 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```
with new_table
as
(select 
      *,
      case
      when 
	description ilike '%kill%' or description ilike '%violence%' then 'Bad_content'
	else 'Good_content'
      end category
from netflix
)
select 
     category,
     count(*) as total_count
from new_table
group by 1;
```
**Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.**

**Done by Chandu**
