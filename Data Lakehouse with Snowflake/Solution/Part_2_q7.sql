CREATE OR REPLACE TABLE table_youtube_duplicates AS
WITH CTE_ROW AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY video_id, country, trending_date ORDER BY view_count DESC) rowNumber
FROM table_youtube_final)

SELECT *
FROM CTE_ROW
WHERE rowNumber>1;

-- Looking at the table
SELECT *
FROM table_youtube_duplicates
LIMIT 10;

-- Looking at the count of the duplicate values
SELECT
COUNT(*)
FROM table_youtube_duplicates;