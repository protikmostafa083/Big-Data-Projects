--Creating table for countring categorty video count
CREATE OR REPLACE TABLE table_cat_vid AS(
SELECT
country,
category_title,
COUNT(distinct(video_id)) as total_category_videos
FROM table_youtube_final
GROUP BY category_title, country
ORDER BY country, total_category_videos DESC);


--Creating table for countring total video count for each country
CREATE OR REPLACE TABLE table_tot_vid AS(
SELECT
country,
COUNT(distinct(video_id)) as total_country_video 
FROM table_youtube_final
WHERE CATEGORY_TITLE IN (SELECT DISTINCT(CATEGORY_TITLE) FROM table_youtube_final)
GROUP BY country
ORDER BY COUNTRY);


-- Merging the both tables
SELECT
t1.country,
t1.CATEGORY_TITLE,
total_category_videos,
total_country_video,
to_decimal((total_category_videos/total_country_video)*100, 5, 2) as percentage
FROM table_cat_vid as t1
LEFT JOIN table_tot_vid as t2
ON t1.country = t2.country
GROUP BY t1.COUNTRY, category_title, total_category_videos, total_country_video
ORDER BY category_title, COUNTRY;