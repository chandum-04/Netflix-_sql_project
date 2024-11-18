-- Netflix project

-- creating table 
drop table if exists netflix;
create table netflix
(
	show_id	varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(250),
	casts varchar(1000),	
	country	varchar(150),
	date_added	varchar(50),
	release_year int,
	rating	varchar(10),
	duration varchar(15),
	listed_in	varchar(100),
	description varchar(270)
);

select * from netflix;
select count(*) as total_content from netflix;

-- 15 Business problems

-- 1. Count the number of Movies vs TV Shows

select 
	type,
	count(*) as total_content
from netflix
group by type;


-- 2. Find the most common rating for movies and TV shows
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

-- 3. List all movies released in a specific year (e.g., 2020)
select * from netflix
where 
	type = 'Movie'
	and release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix
select 
	unnest(string_to_array(country,',')) as new_country,
	count(*) as total
from netflix
group by 1
order by total desc
limit 5;


-- 5. Identify the longest movie
select *from netflix
where 
	type = 'Movie'
	and 
	duration = (select max(duration) from netflix);

-- 6. Find content added in the last 5 years

select 
	*
from netflix
where
	TO_DATE(date_added,'MONTH DD,YYYY') >= CURRENT_DATE - interval '5 years';

-- select current_date - interval '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director ilike '%Rajiv Chilaka%';

select * from netflix
where director = 'Rajiv Chilaka';

-- 8. List all TV shows with more than 5 seasons

select *,
	split_part(duration,' ',1)from netflix
select 
	*
from netflix
where 
	type = 'TV Show'
	and 
	split_part(duration,' ',1) >'5 seasons';

select 
	*
from netflix
where 
	type = 'TV Show'
	and 
	split_part(duration,' ',1)::numeric > 5;
	
select 
	*
from netflix
where 
	type = 'TV Show'
	and 
	duration > '5 seasons'

-- ex
select
	split_part('apple banana grape',' ',1)

-- 9. Count the number of content items in each genre
select 
	unnest(string_to_array(listed_in,',')),
	count(show_id) as total
from netflix
group by 1;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

select 
	extract(year from to_date(date_added,'month dd,yyyy')) as year,
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country like '%India%' )::numeric * 100,2) as average_content
from netflix
where country like '%India%'
group by 1
order by 3 desc
limit 5;

-- 11. List all movies that are documentaries

select * from netflix
where listed_in = 'Documentaries';

select * from netflix
where listed_in ilike '%Documentaries%';


-- 12. Find all content without a director

select * from netflix
where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where 
	casts ilike '%Salman Khan%'
	and
	release_year >= extract(year from current_date)-10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
	unnest(string_to_array(casts,',')) as actors,
	count(show_id) as total_count
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10;

/* 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
	the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/
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


/*where 
	description ilike '%kill%' 
	or
	description ilike '%violence%' ;*/

