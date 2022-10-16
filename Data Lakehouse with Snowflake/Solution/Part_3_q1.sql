WITH CTE_RNK AS (
SELECT
country,
title,
channeltitle,
view_count,
RANK() OVER(PARTITION BY country ORDER BY view_count DESC) as rk
FROM table_youtube_final
WHERE country IS NOT NULL AND category_title = 'Sports' AND trending_date = '2021-10-17')

SELECT *
FROM CTE_RNK
WHERE rk<4;