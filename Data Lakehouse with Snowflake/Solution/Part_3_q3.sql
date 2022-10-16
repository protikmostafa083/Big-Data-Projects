WITH CTE_MOST_VIEWED AS(
    SELECT
    country,
    CAST(publishedat as string) as pubdate,
    CONCAT(SUBSTRING(pubdate,1, length(pubdate)-13),'-01') as year_month,
    title,
    channeltitle,
    category_title,
    likes,
    view_count,
    dense_rank() OVER(PARTITION BY country, year_month ORDER BY view_count DESC) as RNK
    FROM table_youtube_final
    --GROUP BY country,year_month,title,channeltitle,category_title,likes,view_count
)
SELECT 
country,
year_month,
title,
channeltitle,
category_title,
view_count,
to_decimal(AVG(likes/view_count)*100, 5, 2) as likes_ratio
FROM CTE_MOST_VIEWED
WHERE RNK =1
GROUP BY country, year_month,title, channeltitle,category_title,view_count
ORDER BY year_month, country;