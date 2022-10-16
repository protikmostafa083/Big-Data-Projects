----------------------1--------------------------

-- Looking at all the category titles and their views
SELECT
category_title,
SUM(view_count) as category_view_count
FROM table_youtube_final
GROUP BY category_title
ORDER BY category_view_count DESC;


-- looking at the channels with highest view and their category
SELECT
channeltitle,
category_title,
SUM(view_count) as channel_view_count
FROM table_youtube_final
WHERE category_title NOT IN ('Music','Entertainment')
GROUP BY channeltitle, category_title
ORDER BY channel_view_count DESC;


-- looking at category titles and the count of the categories being trending.
SELECT 
category_title,
COUNT(trending_date) as TREND_COUNT
FROM table_youtube_final
WHERE category_title NOT IN ('Music','Entertainment')
GROUP BY CATEGORY_TITLE
ORDER BY TREND_COUNT DESC;


----------------------2--------------------------

--Creating popularity table with ranks
CREATE OR REPLACE table popularity AS(
SELECT
country,
category_title,
SUM(view_count) as countrywise_category_views,
RANK() OVER(PARTITION BY country ORDER BY countrywise_category_views DESC) as popularity
FROM table_youtube_final
WHERE category_title NOT IN ('Music','Entertainment')
GROUP BY country, CATEGORY_TITLE
ORDER BY country,popularity);


-- Looking at the data where the popularity of the category in between 1 to 5
SELECT *
FROM POPULARITY
WHERE popularity<=5;


-- Looking at the popularity ranking of People & Blogs
SELECT *
FROM POPULARITY
WHERE category_title = 'People & Blogs';


-- Looking at the popularity ranking ofGaming
SELECT *
FROM POPULARITY
WHERE category_title = 'Gaming';


-- Looking at the popularity ranking scores of all the categories.
SELECT
CATEGORY_TITLE, POPULARITY, COUNT(popularity) as CT_COUNT
FROM POPULARITY
GROUP BY category_title, POPULARITY
ORDER BY POPULARITY;