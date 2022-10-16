SELECT
distinct(category_title), categoryid
FROM table_youtube_final
WHERE categoryid = 29 and category_title IS NOT NULL;

-- now replacing the null values with found values above
UPDATE
table_youtube_final
set category_title = (SELECT
distinct(category_title)
FROM table_youtube_final
WHERE categoryid = 29 and category_title IS NOT NULL)
WHERE categoryid = 29 and category_title IS NULL;

-- looking at the outcome
SELECT
category_title, categoryid
FROM table_youtube_final
WHERE categoryid = 29;