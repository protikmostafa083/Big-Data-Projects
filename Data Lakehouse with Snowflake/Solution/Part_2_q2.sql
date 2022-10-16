SELECT
category_title, count(category_title) as categoty_count_per_country
FROM table_youtube_category
GROUP BY category_title
HAVING categoty_count_per_country=1;


-- Using nested query
SELECT country, category_title
FROM table_youtube_category
where category_title = (SELECT
category_title
FROM table_youtube_category
GROUP BY category_title
HAVING count(category_title)=1)
;