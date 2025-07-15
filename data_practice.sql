create table movies 
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

SELECT * FROM MOVIES;

SELECT COUNT(*) AS TOTAL_CONTENT 
FROM MOVIES;

SELECT DISTINCT TYPE 
FROM MOVIES;

--BUISNESS PROBLEMS

--Q1. COUNT THE NO OF MOVIES VS TV SHOWS 

SELECT TYPE , COUNT(*)
FROM MOVIES
GROUP BY TYPE;

--Q2. FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS

WITH RatingCounts AS (
    SELECT
        type,
        rating,
        COUNT(*) AS rating_count
    FROM MOVIES
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
		-- WE CAN USE ROW NUMBER INSTEAD OF RANK BUT STILL IT WILL BE LONG
    FROM RatingCounts
)
SELECT
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

-- SOLVING BY USING DISTINCT SAME Q2 QUERY

SELECT DISTINCT ON (type)
    type,
    rating AS most_frequent_rating
FROM (
    SELECT
        type,
        rating,
        COUNT(*) AS rating_count
    FROM MOVIES
    GROUP BY type, rating
    ORDER BY type, COUNT(*) DESC
) AS subquery
ORDER BY type, rating_count DESC;


-- Q3. LIST ALL THE MOVIES RELEASED IN A SPECIFIC YEAR (E.G. 2020)

SELECT *
FROM MOVIES
WHERE release_year = 2020;


--Q4. FIND THE 5 TOP COUNTRIES WITH THE MOST CONTENT ON NETFLIX 

SELECT *
FROM
(
    SELECT
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM MOVIES
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;


--OTHER WAY TO SOLVE THIS PROBLEM 

SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(COUNTRY, ','))) AS country_name,
    COUNT(SHOW_ID) AS total_content
FROM MOVIES
GROUP BY country_name
ORDER BY total_content DESC
LIMIT 5;


--Q5. IDENTIFY THE LONGEST MOVIE

 SELECT * FROM MOVIES
WHERE
    type = 'Movie' AND
    duration = (SELECT MAX(duration) FROM MOVIES);

 SELECT * FROM MOVIES
WHERE
    type = 'Movie' 
	-- AND
 --    duration = (SELECT MAX(duration) FROM MOVIES);	
 order by duration desc limit 1;


--OTHER WAY TO SOLVE THIS QUERY 

SELECT *
FROM MOVIES
WHERE TYPE = 'Movie' AND DURATION LIKE '% min'
ORDER BY CAST(REPLACE(DURATION, ' min', '') AS INTEGER) DESC
LIMIT 1;
	

	
--Q6. FIND THE CONTENT ADDED IN THE LAST 5 YEARS 

SELECT*,DATE_ADDED   --CONVERTIG DATE TO ACTUAL DATE FORMAT IT WAS IN STRING FORMAT 
FROM MOVIES 
WHERE 
     TO_DATE(DATE_ADDED , 'MONTH DD , YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'



--Q7. FIND ALL MOVIES/TV SHOWS DIRECTED BY 'RAJIV CHILAKA'

SELECT
    *
FROM
    MOVIES
WHERE
    director ILIKE '%Rajiv Chilaka%'


--OTHER WAY TO SOLVE THIS PROBLEM BUT THIS IS LENGHTY

SELECT *
FROM (
    SELECT
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM MOVIES
) AS t
WHERE director_name = 'Rajiv Chilaka';



--Q8. LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS

SELECT title, duration
FROM MOVIES
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5; 
  
  --SPLIT_PART(duration, ' ', 1)	Splits '7 Seasons' at the space and picks '7'
  --CAST(... AS INTEGER)	Converts that text '7' to a number
  --> 5	Filters to only shows with more than 5 seasons
  
--EXAMPLE FOR SPLIT FOR MY UNDERSTANDING
SELECT 
      SPLIT_PART('APPLE BANANA CHERRY' , ' ' , 1)


--Q9. COUNT THE NO OF CONTENT ITEMS IN 	EACH GENRE

SELECT 
      UNNEST(STRING_TO_ARRAY(LISTED_IN , ',')) AS GENRE, 
	  COUNT(SHOW_ID) AS TOTAL_CONTENT 
FROM MOVIES
GROUP BY 1


--OTHER WAY TO SOLVE THIS PROBLEM 

SELECT 
    TRIM(genre_name) AS genre,
    COUNT(*) AS total_content
FROM movies,
     LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_name
GROUP BY genre
ORDER BY total_content DESC;



--Q10. **Find each year and the average numbers of content release in India on netflix.**
        --return top 5 year with highest avg content release!


WITH total_india AS (
    SELECT COUNT(*) AS total
    FROM movies
    WHERE country = 'India'
)
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS year_count,
    ROUND((COUNT(*) * 100.0) / total_india.total, 2) AS percentage_of_total
FROM movies, total_india
WHERE country = 'India'
GROUP BY year, total_india.total
ORDER BY year;



--OTHER WAY TO SOLVE THIS QUERY 

SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS content_count,
    ROUND(
        (COUNT(*) * 100.0) / 
        (SELECT COUNT(*) FROM movies WHERE country = 'India'), 
        2
    ) AS percentage
FROM movies
WHERE country = 'India'
GROUP BY year
ORDER BY year;



--Q11. List All Movies that are Documentaries

SELECT *
FROM MOVIES
WHERE LISTED_IN LIKE '%Documentaries%';


--Q12. FIND ALL CONTENT WITHOUT DIRECTOR

SELECT * 
FROM MOVIES 
WHERE DIRECTOR IS NULL;


--Q13. FIND ,IN HOW MANY MOVIES 'SALMAN KHAN' APPEARED IN THE LAST 10 YEARS

SELECT *
FROM MOVIES
WHERE casts LIKE '%Salman Khan%'AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


--Q14. Find the Top 10 Actors Who Have Appeared in the Highest Number 
       --of Movies Produced in India
	   

SELECT 
    TRIM(actor_name) AS actor,
    COUNT(*) AS total_movies
FROM movies,
     LATERAL UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor_name
WHERE country = 'India'
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;



--Q15.Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
   --in the description field. Labelcontent containing these keyword as 'bad'
   --and all other content as 'good'. Count how many items falls into each category. 

WITH new_table AS ( -- CREATING CTE [Common Table Expression]
    SELECT
        CASE
            WHEN description ILIKE '%kills%'
              OR description ILIKE '%violence%'
            THEN 'Bad_Content'
            ELSE 'Good_Content'
        END AS category
    FROM MOVIES
)

SELECT
    category,
    COUNT(*) AS total_content
FROM new_table
GROUP BY category;

--When Should You Use WITH?

--Whenever your query has multiple steps or becomes too long.
--When you're writing layered transformations.
--When the same subquery would otherwise repeat.







