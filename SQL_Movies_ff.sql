USE BoxOffice

------ Creation of flat file using one-hot-encoding

SELECT * FROM dsuser10.movie_deprt_v
ORDER BY department

SELECT *
INTO dsuser10.ff_movies
FROM dbo.movies

--------------------------------------
-- Movies genre categorization
--------------------------------------
CREATE VIEW dsuser10.movie_genres_v AS
SELECT 
	movie_id
	, MAX(CASE WHEN (mg.genre_id = 12) THEN (1) ELSE (0) END) AS genre_Adventure
	, MAX(CASE WHEN (mg.genre_id = 14) THEN (1) ELSE (0) END) AS genre_Fantasy
	, MAX(CASE WHEN (mg.genre_id = 16) THEN (1) ELSE (0) END) AS genre_Animation
	, MAX(CASE WHEN (mg.genre_id = 18) THEN (1) ELSE (0) END) AS genre_Drama
	, MAX(CASE WHEN (mg.genre_id = 27) THEN (1) ELSE (0) END) AS genre_Horror
	, MAX(CASE WHEN (mg.genre_id = 28) THEN (1) ELSE (0) END) AS genre_Action
	, MAX(CASE WHEN (mg.genre_id = 35) THEN (1) ELSE (0) END) AS genre_Comedy
	, MAX(CASE WHEN (mg.genre_id = 36) THEN (1) ELSE (0) END) AS genre_History
	, MAX(CASE WHEN (mg.genre_id = 37) THEN (1) ELSE (0) END) AS genre_Western
	, MAX(CASE WHEN (mg.genre_id = 53) THEN (1) ELSE (0) END) AS genre_Thriller
	, MAX(CASE WHEN (mg.genre_id = 80) THEN (1) ELSE (0) END) AS genre_Crime
	, MAX(CASE WHEN (mg.genre_id = 99) THEN (1) ELSE (0) END) AS genre_Documentary
	, MAX(CASE WHEN (mg.genre_id = 878) THEN (1) ELSE (0) END) AS genre_ScienceFiction
	, MAX(CASE WHEN (mg.genre_id = 9648) THEN (1) ELSE (0) END) AS genre_Mystery
	, MAX(CASE WHEN (mg.genre_id = 10402) THEN (1) ELSE (0) END) AS genre_Music
	, MAX(CASE WHEN (mg.genre_id = 10749) THEN (1) ELSE (0) END) AS genre_Romance
	, MAX(CASE WHEN (mg.genre_id = 10751) THEN (1) ELSE (0) END) AS genre_Family
	, MAX(CASE WHEN (mg.genre_id = 10752) THEN (1) ELSE (0) END) AS genre_War
	, MAX(CASE WHEN (mg.genre_id = 10769) THEN (1) ELSE (0) END) AS genre_Foreign
	, MAX(CASE WHEN (mg.genre_id = 10770) THEN (1) ELSE (0) END) AS genre_TVmovie
FROM dbo.movies_genres AS mg
GROUP BY mg.movie_id
ORDER BY mg.movie_id

-------------------------------------------------------------------------------
-- Movies language categorization by: en, fr, es, de, ru, it, ja, da, tr, ko
-------------------------------------------------------------------------------
CREATE VIEW dsuser10.movie_lang_v AS
SELECT 
	movie_id
	, MAX(CASE WHEN (ml.iso_639_1 = 'en' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_En
	, MAX(CASE WHEN (ml.iso_639_1 = 'fr' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_Fr
	, MAX(CASE WHEN (ml.iso_639_1 = 'es' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_Es
	, MAX(CASE WHEN (ml.iso_639_1 = 'de' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_De
	, MAX(CASE WHEN (ml.iso_639_1 = 'ru' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_Ru
	, MAX(CASE WHEN (ml.iso_639_1 = 'it' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_It
	, MAX(CASE WHEN (ml.iso_639_1 = 'ja' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_Ja
	, MAX(CASE WHEN (ml.iso_639_1 = 'da' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_Da
	, MAX(CASE WHEN (ml.iso_639_1 = 'tr' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_Tr
	, MAX(CASE WHEN (ml.iso_639_1 = 'ko' AND ml.sw_original_lang = 0) THEN (1) ELSE (0) END) AS trans_lang_Ko
FROM dbo.movie_languages AS ml
GROUP BY ml.movie_id
ORDER BY ml.movie_id

-----------------------------
-- Movies departments
-----------------------------
CREATE VIEW dsuser10.movie_deprt_v AS
SELECT 
	movie_id
	, SUM(CASE WHEN (mc.department = 'Art') THEN (1) ELSE (0) END) AS deprt_Art
	, SUM(CASE WHEN (mc.department = 'Camera') THEN (1) ELSE (0) END) AS deprt_Camera
	, SUM(CASE WHEN (mc.department = 'Costume & Make-Up') THEN (1) ELSE (0) END) AS deprt_Costume_MakeUp
	, SUM(CASE WHEN (mc.department = 'Crew') THEN (1) ELSE (0) END) AS deprt_Crew
	, SUM(CASE WHEN (mc.department = 'Directing') THEN (1) ELSE (0) END) AS deprt_Directing
	, SUM(CASE WHEN (mc.department = 'Editing') THEN (1) ELSE (0) END) AS deprt_Editing
	, SUM(CASE WHEN (mc.department = 'Lighting') THEN (1) ELSE (0) END) AS deprt_Lighting
	, SUM(CASE WHEN (mc.department = 'Production') THEN (1) ELSE (0) END) AS deprt_Production
	, SUM(CASE WHEN (mc.department = 'Sound') THEN (1) ELSE (0) END) AS deprt_Sound
	, SUM(CASE WHEN (mc.department = 'Visual Effects') THEN (1) ELSE (0) END) AS deprt_Vis_Effects
	, SUM(CASE WHEN (mc.department = 'Writing') THEN (1) ELSE (0) END) AS deprt_Writing
FROM dbo.movies_crew AS mc
GROUP BY mc.movie_id
ORDER BY mc.movie_id

-----------------------------
-- Movies departments female
-----------------------------
CREATE VIEW dsuser10.movies_departments_female_v AS
SELECT movie_id
    , SUM(CASE WHEN (department = 'Writing' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Writing_female
    , SUM(CASE WHEN (department = 'Directing' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Directing_female
    , SUM(CASE WHEN (department = 'Art' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Art_female
    , SUM(CASE WHEN (department = 'Sound' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Sound_female
    , SUM(CASE WHEN (department = 'Crew' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Crew_female
    , SUM(CASE WHEN (department = 'Costume & Make-Up' AND b.gender = 1) THEN (1) ELSE (0) END) AS depart_Custom_Mkup_female
    , SUM(CASE WHEN (department = 'Visual Effects' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Visual_Effects_female
    , SUM(CASE WHEN (department = 'Production' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Production_female
    , SUM(CASE WHEN (department = 'Camera' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Camera_female
    , SUM(CASE WHEN (department = 'Lighting' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Lighting_female
    , SUM(CASE WHEN (department = 'Editing' AND b.gender = 1) THEN (1) ELSE (0) END) AS deprt_Editing_female
FROM movies_crew a
LEFT OUTER JOIN crew_dim b
    ON a.crew_id = b.crew_id
GROUP BY movie_id;

-- Movies collection categorization
SELECT 
	mc.movie_id
	, COUNT(1) AS num_collections
FROM dbo.movie_collection AS mc
GROUP BY mc.movie_id
ORDER BY mc.movie_id

-- Movies Keywards categorization
SELECT 
	mk.movie_id
	, COUNT(1) AS num_keywards
FROM dbo.movie_keywords AS mk
GROUP BY mk.movie_id
ORDER BY mk.movie_id

-- Yearly revenue percent by movie
SELECT
	movie_id
	,revenue
	,YEAR(release_date) AS release_year
    ,CAST(CAST(revenue AS decimal(15,3)) * 100 / (SUM(CAST(revenue AS decimal(15,3))) OVER (PARTITION BY YEAR(release_date) ORDER BY YEAR(release_date))) AS decimal(6,3)) AS yearly_percent_revenue
INTO dsuser10.#mov_rev_perc
FROM dbo.movies

-- number of male actors in the movie
SELECT 
	mc.movie_id
	,COUNT(*) AS num_MaleAct
INTO dsuser10.#num_MaleAct
FROM BoxOffice.dbo.movies_cast AS mc
INNER JOIN dbo.actors_dim AS ad 
	ON ad.actor_id = mc.actor_id
WHERE ad.gender = 2
GROUP BY mc.movie_id
ORDER by mc.movie_id

-- number of female actors in the movie
SELECT 
	mc.movie_id
	,COUNT(*) AS num_FemaleAct
INTO dsuser10.#num_FemaleAct
FROM BoxOffice.dbo.movies_cast AS mc
INNER JOIN dbo.actors_dim AS ad 
	ON ad.actor_id = mc.actor_id
WHERE ad.gender = 1
GROUP BY mc.movie_id
ORDER by mc.movie_id

-- number of total crew per movie
SELECT DISTINCT
	movie_id
	, department
	, COUNT(*) OVER (PARTITION BY department ORDER BY movie_id) AS total_crew
FROM dbo.movies_crew
ORDER BY department

-- number of producers per movie
SELECT
	a.movie_id,
	COUNT (DISTINCT a.producer_id) AS num_producers
INTO dsuser10.#produc_count
FROM dbo.movie_producers AS a
	LEFT OUTER JOIN dbo.movies b
	ON a.movie_id = b.movie_id
GROUP BY a.movie_id

-----------------------------------------------------
----- Famous producers
-----------------------------------------------------
SELECT
	a.producer_id
	, a.movie_id
	, b.release_date
	, b.revenue
INTO dsuser10.#fruitful_produc
FROM dbo.movie_producers AS a
	LEFT OUTER JOIN dbo.movies b
	ON a.movie_id = b.movie_id

SELECT a.producer_id, a.movie_id, a.release_date,
	(SELECT COUNT(1) FROM dsuser10.#fruitful_produc WHERE (release_date BETWEEN DATEADD(YEAR,-5,a.release_date) AND  DATEADD(DAY,-1,a.release_date)) AND producer_id = a.producer_id) AS producers_5y_cnt,
	(SELECT SUM(revenue*1.0) FROM dsuser10.#fruitful_produc WHERE (release_date BETWEEN DATEADD(YEAR,-5,a.release_date) AND  DATEADD(DAY,-1,a.release_date)) AND producer_id = a.producer_id) AS producers_5y_revenue
INTO dsuser10.#movie_producer_famous
FROM dsuser10.#fruitful_produc a
ORDER BY movie_id

SELECT movie_id, 
	   SUM(CASE WHEN (producers_5y_cnt IS NULL) THEN (0) ELSE (producers_5y_cnt) END) AS producers_5y_cnt, 
	   SUM(CASE WHEN (producers_5y_revenue IS NULL) THEN (0) ELSE (producers_5y_revenue) END) AS producers_5y_revenue
INTO dsuser10.#movies_porducers_famous_aggr
FROM dsuser10.#movie_producer_famous
GROUP BY movie_id

SELECT
	a.producer_id
	, SUM(b.revenue*1.0) AS proucer_revenues
--INTO dsuser10.#produc_revenues
FROM dbo.movie_producers AS a
	LEFT OUTER JOIN dbo.movies b
	ON a.movie_id = b.movie_id
GROUP BY a.producer_id
ORDER BY proucer_revenues

-------------------------------------------
---- famous actors
-------------------------------------------

SELECT a.actor_id, a.movie_id, a.[order], b.release_date, b.revenue
INTO dsuser10.#movie_actor_date_revenue
FROM movies_cast a
	LEFT OUTER JOIN movies b
        ON a.movie_id = b.movie_id
;
GO

--SELECT * FROM #movie_actor_date_revenue

SELECT a.actor_id, a.movie_id, a.release_date,
	(SELECT COUNT(1) FROM #movie_actor_date_revenue WHERE (release_date BETWEEN DATEADD(YEAR,-5,a.release_date) AND  DATEADD(DAY,-1,a.release_date)) AND actor_id = a.actor_id) AS actors_5y_cnt,
	(SELECT SUM(revenue*1.0) FROM #movie_actor_date_revenue WHERE (release_date BETWEEN DATEADD(YEAR,-5,a.release_date) AND  DATEADD(DAY,-1,a.release_date)) AND actor_id = a.actor_id) AS actors_5y_revenue
INTO dsuser10.#movie_actors_famous
FROM dsuser10.#movie_actor_date_revenue a
WHERE [order] IN (0)
ORDER BY movie_id

--SELECT * FROM #movie_actors_famous_aggr

SELECT movie_id, 
	   SUM(CASE WHEN actors_5y_cnt IS NULL THEN (0) ELSE (actors_5y_cnt) END) AS actor_5y_cnt, 
	   SUM(CASE WHEN actors_5y_revenue IS NULL THEN (0) ELSE (actors_5y_revenue) END) AS actors_5y_revenue
INTO dsuser10.#movie_actors_famous_aggr
FROM dsuser10.#movie_actors_famous
GROUP BY movie_id

-------------------------------------------
---- famous directors
-------------------------------------------

SELECT a.movie_id, crew_id AS director_id, c.release_date, c.revenue
INTO dsuser10.#movie_director_date
FROM movies_crew a
LEFT OUTER JOIN movies c
    ON a.movie_id = c.movie_id
where job = 'Director'

--SELECT * FROM dsuser10.#movie_director_date

GO

SELECT a.director_id, a.movie_id, a.release_date,
	(SELECT COUNT(1) FROM #movie_director_date WHERE (release_date BETWEEN DATEADD(YEAR,-5,a.release_date) AND  DATEADD(DAY,-1,a.release_date)) AND director_id = a.director_id) AS directors_5y_cnt,
	(SELECT SUM(revenue) FROM #movie_director_date WHERE (release_date BETWEEN DATEADD(YEAR,-5,a.release_date) AND  DATEADD(DAY,-1,a.release_date)) AND director_id = a.director_id) AS directors_5y_revenue
INTO dsuser10.#movie_directors_famous
FROM dsuser10.#movie_director_date a
ORDER BY movie_id

--SELECT * FROM dsuser10.#movie_director_famous_aggr

SELECT movie_id, 
	   SUM(CASE WHEN directors_5y_cnt IS NULL THEN (0) ELSE (directors_5y_cnt) END) AS director_5y_cnt, 
	   SUM(CASE WHEN directors_5y_revenue IS NULL THEN (0) ELSE (directors_5y_revenue) END) AS directors_5y_revenue
INTO dsuser10.#movie_director_famous_aggr
FROM dsuser10.#movie_directors_famous
GROUP BY movie_id

---------------------------------------------------
--Flat file (ff) of "movies" table
---------------------------------------------------

SELECT
	m.movie_id
	, original_title
	, m.budget
	, (CASE WHEN (m.budget = 0 ) THEN (1) ELSE (0) END) AS budg_0
	, (CASE WHEN (m.budget <= 100000) THEN (1) ELSE (0) END) AS budg_negl
	, (CASE WHEN (m.budget > 100000 AND m.budget <= 1000000) THEN (1) ELSE (0) END) AS budg_low
	, (CASE WHEN (m.budget > 1000000 AND m.budget <= 10000000) THEN (1) ELSE (0) END) AS budg_medium
	, (CASE WHEN (m.budget > 10000000 AND m.budget <= 100000000) THEN (1) ELSE (0) END) AS budg_high
	, (CASE WHEN (m.budget > 100000000) THEN (1) ELSE (0) END) AS budg_huge
	, m.homepage
	, (CASE WHEN (m.homepage <> '' ) THEN (1) ELSE (0) END) AS sw_web
	, m.poster_path
	, (CASE WHEN (m.poster_path <> '' ) THEN (1) ELSE (0) END) AS sw_poster
	, m.tagline
	, (CASE WHEN (m.tagline <> '' ) THEN (1) ELSE (0) END) AS sw_tagline
	, m.popularity
	, (CASE WHEN (m.popularity < 3) THEN (1) ELSE (0) END) AS pop_low
	, (CASE WHEN (m.popularity >= 3 AND m.popularity <= 10) THEN (1) ELSE (0) END) AS pop_avg
	, (CASE WHEN (m.popularity > 10 AND m.popularity <= 20) THEN (1) ELSE (0) END) AS pop_high 
	, (CASE WHEN (m.popularity > 20 AND m.popularity < 100) THEN (1) ELSE (0) END) AS pop_extr 
	, (CASE WHEN (m.popularity >= 100) THEN (1) ELSE (0) END) AS pop_otsdg
	, (SELECT COUNT(1) FROM dbo.movie_keywords WHERE movie_id = m.movie_id) AS num_keywards
	, (SELECT COUNT(1) FROM dbo.movie_collection WHERE movie_id = m.movie_id) AS num_collections
	, m.runtime
	, CASE
		WHEN (m.runtime < 90) THEN ('Short')
		WHEN (m.runtime < 120) THEN ('Long')
		ELSE ('Average')
	  END AS runtime_cat
	, m.release_date
	, YEAR(m.release_date) AS release_year
	, MONTH(m.release_date) AS release_month
	, DAY(m.release_date) AS release_day
	, mgv.genre_Action
	, mgv.genre_Adventure
	, mgv.genre_Animation
	, mgv.genre_Comedy
	, mgv.genre_Crime
	, mgv.genre_Documentary
	, mgv.genre_Drama
	, mgv.genre_Family
	, mgv.genre_Fantasy
	, mgv.genre_Foreign
	, mgv.genre_History
	, mgv.genre_Horror
	, mgv.genre_Music
	, mgv.genre_Mystery
	, mgv.genre_Romance
	, mgv.genre_ScienceFiction
	, mgv.genre_Thriller
	, mgv.genre_TVmovie
	, mgv.genre_War
	, mgv.genre_Western
	, m.original_language
	, (CASE WHEN (m.original_language = 'en') THEN (1) ELSE (0) END) AS orig_lang_En
	, (CASE WHEN (m.original_language = 'fr') THEN (1) ELSE (0) END) AS orig_lang_Fr
	, (CASE WHEN (m.original_language = 'es') THEN (1) ELSE (0) END) AS orig_lang_Es
	, (CASE WHEN (m.original_language = 'de') THEN (1) ELSE (0) END) AS orig_lang_De
	, (CASE WHEN (m.original_language = 'ru') THEN (1) ELSE (0) END) AS orig_lang_Ru
	, (CASE WHEN (m.original_language = 'it') THEN (1) ELSE (0) END) AS orig_lang_It
	, (CASE WHEN (m.original_language = 'ja') THEN (1) ELSE (0) END) AS orig_lang_Ja
	, (CASE WHEN (m.original_language = 'da') THEN (1) ELSE (0) END) AS orig_lang_Da
	, (CASE WHEN (m.original_language = 'tr') THEN (1) ELSE (0) END) AS orig_lang_Tr
	, (CASE WHEN (m.original_language = 'ko') THEN (1) ELSE (0) END) AS orig_lang_Ko
	, mlv.trans_lang_Da
	, mlv.trans_lang_De
	, mlv.trans_lang_En
	, mlv.trans_lang_Es
	, mlv.trans_lang_Fr
	, mlv.trans_lang_It
	, mlv.trans_lang_Ja
	, mlv.trans_lang_Ko
	, mlv.trans_lang_Ru
	, mlv.trans_lang_Tr
	, (SELECT COUNT (1)FROM dbo.movie_countries WHERE movie_id = m.movie_id) AS num_countries
	, (SELECT num_FemaleAct FROM #num_FemaleAct WHERE movie_id = m.movie_id) AS num_FemaleAct
	  --- main actors female
    , (SELECT MAX(CASE WHEN (e.gender=1) THEN (1) ELSE (0) END) 
	   FROM movies_cast d
		LEFT OUTER JOIN actors_dim e
			ON d.actor_id = e.actor_id
       WHERE d.movie_id = m.movie_id AND d.[order] = 0 ) AS sw_FemaleAct0
    , (SELECT MAX(CASE WHEN (e.gender=1) THEN (1) ELSE (0) END) 
       FROM movies_cast d
		LEFT OUTER JOIN actors_dim e
			ON d.actor_id = e.actor_id
       WHERE d.movie_id = m.movie_id AND d.[order] = 1 ) AS sw_FemaleAct1
    , (SELECT MAX(CASE WHEN (e.gender=1) THEN (1) ELSE (0) END) 
       FROM movies_cast d
		LEFT OUTER JOIN actors_dim e
			ON d.actor_id = e.actor_id
       WHERE d.movie_id = m.movie_id AND d.[order] = 2 ) AS sw_FemaleAct2
	, (SELECT num_MaleAct FROM #num_MaleAct WHERE movie_id = m.movie_id) AS num_MaleAct
	 --- main actors male
    , (SELECT MAX(CASE WHEN (e.gender=2) THEN (1) ELSE (0) END) 
       FROM movies_cast d
		LEFT OUTER JOIN actors_dim e
			ON d.actor_id = e.actor_id
       WHERE d.movie_id = m.movie_id AND d.[order] = 0 ) AS sw_MaleAct0
    , (SELECT MAX(CASE WHEN (e.gender=2) THEN (1) ELSE (0) END) 
       FROM movies_cast d
		LEFT OUTER JOIN actors_dim e
			ON d.actor_id = e.actor_id
       WHERE d.movie_id = m.movie_id AND d.[order] = 1 ) AS sw_MaleAct1
    , (SELECT MAX(CASE WHEN (e.gender=2) THEN (1) ELSE (0) END) 
       FROM movies_cast d
		LEFT OUTER JOIN actors_dim e
			ON d.actor_id = e.actor_id
       WHERE d.movie_id = m.movie_id AND d.[order] = 2 ) AS sw_MaleAct2
	 --- main actors
    , (SELECT DISTINCT COUNT(1) -- as actor_movies_cnt
        FROM dsuser10.#movie_actor_date_revenue
        WHERE release_date < m.release_date AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM dsuser10.#movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 0
      )) AS actor0_movies_cnt 
    , (SELECT DISTINCT COUNT(1) -- as actor_movies_cnt
        FROM dsuser10.#movie_actor_date_revenue
        WHERE release_date BETWEEN DATEADD(YEAR, -3, m.release_date) AND DATEADD(DAY,-1,m.release_date) 
        AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM dsuser10.#movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 0
      )) AS actor0_movies_3y_cnt 
    , (SELECT DISTINCT COUNT(1) 
        FROM dsuser10.#movie_actor_date_revenue
        WHERE release_date < m.release_date AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM dsuser10.#movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 1
      )) AS actor1_movies_cnt
    , (SELECT DISTINCT COUNT(1) -- as actor_movies_cnt
        FROM dsuser10.#movie_actor_date_revenue
        WHERE release_date BETWEEN DATEADD(YEAR, -3, m.release_date) AND DATEADD(DAY,-1,m.release_date) 
        AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM dsuser10.#movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 1
      )) AS actor1_movies_3y_cnt 
    , (SELECT DISTINCT COUNT(1) -- as actor_movies_cnt
        FROM dsuser10.#movie_actor_date_revenue
        WHERE release_date < m.release_date AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM dsuser10.#movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 2
      )) AS actor2_movies_cnt
    , (SELECT DISTINCT COUNT(1) -- as actor_movies_cnt
        FROM dsuser10.#movie_actor_date_revenue
        WHERE release_date BETWEEN DATEADD(YEAR, -3, m.release_date) AND DATEADD(DAY,-1,m.release_date) 
        AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM dsuser10.#movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 2
      )) AS actor2_movies_3y_cnt 
	  --- main actors previous movie revenue
    ,  (SELECT MAX(revenue) -- as actor_movies_cnt
        FROM #movie_actor_date_revenue 
        WHERE release_date < m.release_date AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM #movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 0
        ) AND revenue IS NOT NULL) AS actor0_prev_revenue
    ,  (SELECT MAX(revenue) -- as actor_movies_cnt
        FROM #movie_actor_date_revenue 
        WHERE release_date < m.release_date AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM #movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 1
        ) AND revenue IS NOT NULL) AS actor1_prev_revenue
    ,  (SELECT MAX(revenue) -- as actor_movies_cnt
        FROM #movie_actor_date_revenue 
        WHERE release_date < m.release_date AND actor_id = (
            SELECT TOP 1 actor_id 
            FROM #movie_actor_date_revenue
            WHERE movie_id = m.movie_id AND [order] = 2
        ) AND revenue IS NOT NULL) AS actor2_prev_revenue
	--, total actors
	--, m/f ratio
	, (SELECT DISTINCT COUNT(1) OVER (PARTITION BY movie_id) FROM dbo.movies_crew WHERE movie_id = m.movie_id) AS total_crew
	, (SELECT COUNT(DISTINCT producer_id) FROM dsuser10.#fruitful_produc WHERE movie_id = m.movie_id) AS num_producers
	, (SELECT DISTINCT SUM(revenue*1.0) OVER (PARTITION BY producer_id) FROM dbo.movie_producers WHERE movie_id = m.movie_id) AS producer_revenue
	    --- directors previous movies
    , (SELECT DISTINCT COUNT(1) -- as actor_movies_cnt
       FROM #movie_director_date
       WHERE release_date < m.release_date
		AND director_id = (
            SELECT TOP 1 director_id 
            FROM #movie_director_date
            WHERE movie_id = m.movie_id 
        )) AS director_movies_cnt 

    , (SELECT DISTINCT COUNT(1) -- as actor_movies_cnt
       FROM #movie_director_date
       WHERE release_date BETWEEN DATEADD(YEAR, -3, m.release_date) AND DATEADD(DAY,-1,m.release_date) 
		AND director_id = (
            SELECT TOP 1 director_id 
            FROM #movie_director_date
            WHERE movie_id = m.movie_id 
        )) AS director_movies_3y_cnt 
	, mdv.deprt_Art
	, mdv.deprt_Camera
	, mdv.deprt_Costume_MakeUp
	, mdv.deprt_Crew
	, mdv.deprt_Directing
	, mdv.deprt_Editing
	, mdv.deprt_Lighting
	, mdv.deprt_Production
	, mdv.deprt_Sound
	, mdfv.deprt_Art_female
	, mdfv.deprt_Camera_female
	, mdfv.depart_Custom_Mkup_female
	, mdfv.deprt_Crew_female
	, mdfv.deprt_Directing_female
	, mdfv.deprt_Editing_female
	, mdfv.deprt_Lighting_female
	, mdfv.deprt_Production_female
	, mdfv.deprt_Sound_female
	, revenue
	, CAST(CAST(revenue AS decimal(15,3)) * 100 / (SUM(CAST(revenue AS decimal(15,3))) OVER (PARTITION BY YEAR(release_date))) AS decimal(6,3)) AS yearly_percent_revenue
	, (SUM(CAST(revenue AS decimal(15,0))) OVER (PARTITION BY YEAR(release_date))) AS yearly_revenue
INTO SELECT * FROM dsuser10.movies_ff
FROM dbo.movies AS m
	LEFT OUTER JOIN dsuser10.movie_deprt_v AS mdv ON m.movie_id = mdv.movie_id
	LEFT OUTER JOIN dsuser10.movie_genres_v AS mgv ON m.movie_id = mgv.movie_id
	LEFT OUTER JOIN dsuser10.movie_lang_v AS mlv ON m.movie_id = mlv.movie_id
	LEFT OUTER JOIN dsuser10.movies_departments_female_v AS mdfv ON m.movie_id = mdfv.movie_id
	
