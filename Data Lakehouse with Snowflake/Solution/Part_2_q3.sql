SELECT
categoryid, category_title
FROM table_youtube_final
WHERE category_title is NULL
GROUP BY categoryid, category_title;