SELECT *
FROM table_youtube_category
LIMIT 5;

-- Duplicate rows with not taking categoryid into account
SELECT
distinct(category_title)--, count(category_title) as categoty_count_per_country
FROM table_youtube_category
GROUP BY category_title, country
HAVING count(category_title)>1;