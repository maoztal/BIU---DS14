USE BoxOffice

--1. Get the top ten popular movies where the original language was English
SELECT TOP 10 
	movie_id 
	,popularity
	,original_language
FROM dbo.movies
WHERE original_language = 'en'
ORDER BY popularity DESC

--2. Calculate the number of movies that were released by year.
SELECT
	YEAR(release_date) AS Year_of_Release
	,COUNT(*) AS Num_of_Movies
FROM dbo.movies
GROUP BY YEAR(release_date)
ORDER BY Num_of_Movies DESC

--3. Calculate the number of movies that were released by month.
SELECT
	MONTH(release_date) AS Month_of_Release
	,COUNT(*) AS Num_of_Movies
FROM dbo.movies
GROUP BY MONTH(release_date)
ORDER BY Num_of_Movies DESC


--4. Create a new variable based on runtime, where the movies are categorized into the following categories: 0 = Unknown, 1-50 = Short, 51-120 Average, >120 Long.
SELECT
	Movie_id
	,Runtime
	,CASE
		WHEN runtime = 0 THEN 'Unknown'
		WHEN runtime BETWEEN 1 AND 50 THEN 'Short'
		WHEN runtime BETWEEN 51 AND 120 THEN 'Average'
		ELSE 'Long'
	END AS Runtime_categories
FROM dbo.movies

--5. For each year, calculate :
	/*a. The dense rank, based on the revenue (descending order)*/
SELECT 
	YEAR(release_date) AS Year_of_Release
    ,Revenue
	,DENSE_RANK() OVER (ORDER BY revenue DESC) AS dRank
FROM dbo.movies

SELECT
	YEAR(release_date) AS Year_of_Release
    ,Revenue
	,DENSE_RANK() OVER (PARTITION BY YEAR(release_date) ORDER BY revenue DESC) AS dRank
FROM dbo.movies

	/*b. The yearly revenue's sum of the movies*/
SELECT 
    YEAR(release_date) AS Year_of_Release
    ,SUM(CAST(revenue AS bigint)) AS Yearly_annual_rev
FROM dbo.movies
GROUP BY YEAR(release_date)
ORDER BY Yearly_annual_rev

	/*c. The percent of the revenue with respect to the yearly annual revenue (b).*/
SELECT
	movie_id
	,revenue
	,YEAR(release_date) AS Year_of_Release
    ,CAST(CAST(revenue AS decimal(15,3)) * 100 / (SUM(CAST(revenue AS decimal(15,3))) OVER (PARTITION BY YEAR(release_date) ORDER BY YEAR(release_date))) AS decimal(6,3)) AS Percent_revenue
FROM dbo.movies

--6. For each movie: 
	/*a. Count the number of female actors in the movie. */
SELECT 
	m.movie_id
	,COUNT(*) AS Num_FemaleAct 
FROM BoxOffice.dbo.movies_cast AS c
INNER JOIN dbo.actors_dim AS a ON a.actor_id = c.actor_id
INNER JOIN dbo.movies AS m ON c.movie_id = m.movie_id
WHERE a.gender = 1
GROUP BY m.movie_id
ORDER by m.movie_id

	/*b. Count the number of male actors in the movie. */
SELECT 
	m.movie_id
	,COUNT(*) AS Num_MaleAct 
FROM BoxOffice.dbo.movies_cast AS c
INNER JOIN dbo.actors_dim AS a ON a.actor_id = c.actor_id
INNER JOIN dbo.movies AS m ON c.movie_id = m.movie_id
WHERE a.gender = 2
GROUP BY m.movie_id
ORDER by m.movie_id

	/*c. Calculate the ratio of male vs women (female count / male count) */
SELECT 
	Num_FemaleAct.movie_id
	,Num_FemaleAct.Female_count
	,Num_MaleAct.Male_count
	,Female_count / Male_count AS 'F/M_Ratio'
FROM (
	SELECT 
		m.movie_id
		,CAST (COUNT(*) AS decimal(3)) AS Female_count 
	FROM BoxOffice.dbo.movies_cast AS c
	INNER JOIN dbo.actors_dim AS a ON a.actor_id = c.actor_id
	INNER JOIN dbo.movies AS m ON c.movie_id = m.movie_id
	WHERE a.gender = 1
	GROUP BY m.movie_id) AS Num_FemaleAct
LEFT JOIN (
	SELECT 
		m.movie_id
		,CAST (COUNT(*) AS decimal(3)) AS Male_count 
	FROM BoxOffice.dbo.movies_cast AS c
	INNER JOIN dbo.actors_dim AS a ON a.actor_id = c.actor_id
	INNER JOIN dbo.movies AS m ON c.movie_id = m.movie_id
	WHERE a.gender = 2
	GROUP BY m.movie_id) AS Num_MaleAct 
ON Num_FemaleAct.movie_id = Num_MaleAct.movie_id
ORDER by Num_FemaleAct.movie_id

--7. For each of the following languages: [en, fr, es, de, ru, it, ja]: 
	/*Create a column and set it to 1 if the movie has a translation** to the language and zero if not.*/
SELECT
	movie_id
	,CASE
		WHEN iso_639_1 = 'en' AND sw_original_lang = 0 THEN '1'
		ELSE '0'
	END AS en
	,CASE
		WHEN iso_639_1 = 'fr' AND sw_original_lang = 0 THEN '1'
		ELSE '0'
	END AS fr
	,CASE
		WHEN iso_639_1 = 'es' AND sw_original_lang = 0 THEN '1'
		ELSE '0'
	END AS es
	,CASE
		WHEN iso_639_1 = 'de' AND sw_original_lang = 0 THEN '1'
		ELSE '0'
	END AS de
	,CASE
		WHEN iso_639_1 = 'ru' AND sw_original_lang = 0 THEN '1'
		ELSE '0'
	END AS ru
	,CASE
		WHEN iso_639_1 = 'it' AND sw_original_lang = 0 THEN '1'
		ELSE '0'
	END AS it
	,CASE
		WHEN iso_639_1 = 'ja' AND sw_original_lang = 0 THEN '1'
		ELSE '0'
	END AS ja
FROM dbo.movie_languages AS l
ORDER BY movie_id

--8. For each of the crew departments, get a column and count the total number of individuals for each movie. Create a view with this query
CREATE VIEW dsuser10.movies_crew_V
	AS
	SELECT DISTINCT
		movie_id
		,department
		,COUNT(*) OVER (PARTITION BY department ORDER BY movie_id) AS Individuals_count
	FROM dbo.movies_crew

SELECT * FROM dsuser10.movies_crew_V
ORDER BY movie_id