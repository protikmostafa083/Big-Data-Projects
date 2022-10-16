SELECT
COUNT(*)
FROM table_youtube_final;


DELETE
FROM table_youtube_final as t1
WHERE t1.id IN (SELECT t2.id 
                FROM table_youtube_duplicates as t2);