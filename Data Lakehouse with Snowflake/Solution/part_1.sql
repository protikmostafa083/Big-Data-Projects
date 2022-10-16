-- Creating a database
CREATE DATABASE youtube;


-- Getting into the database
USE DATABASE youtube;


-- Creating storage integration with azure
CREATE OR REPLACE STORAGE INTEGRATION azure_youtube
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = AZURE
    ENABLED = TRUE
    AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
    STORAGE_ALLOWED_LOCATIONS = ('azure://utsbdemostafa.blob.core.windows.net/bde-at1');
    
    
-- Providing permission for storage integration
DESC STORAGE INTEGRATION azure_youtube;


-- Creating an stage
CREATE OR REPLACE STAGE stage_azure_youtube
STORAGE_INTEGRATION = azure_youtube
URL = 'azure://utsbdemostafa.blob.core.windows.net/bde-at1';


-- Looking at all the data and their details in the stage
LIST @stage_azure_youtube;

-- Creating a file format for CSV
CREATE OR REPLACE FILE FORMAT file_format_csv
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('\\N', 'NULL', 'NUL', '')
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';
    
    

-- Creating an external table for youtube trending data
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
WITH LOCATION = @stage_azure_youtube
FILE_FORMAT = file_format_csv
PATTERN = '.*[.]csv';

-- Looking at the first 2 rows of the external table ex_table_youtube_trending
SELECT *
FROM youtube.public.ex_table_youtube_trending
LIMIT 2;



-- Parsing youtube trending data in tabular version and storing in a table called "table_youtube_trending"
CREATE OR REPLACE TABLE table_youtube_trending
AS
SELECT
value:c1::varchar as video_id,
value:c2::varchar as title,
value:c3::string as publishedAt,
value:c4::varchar as channelId,
value:c5::varchar as channelTitle,
value:c6::int as categoryId,
value:c7::date as trending_date,
value:c8::int as view_count,
value:c9::int as likes,
value:c10::int as dislikes,
value:c11::int as comment_count,
value:c12::boolean as comments_disabled,
split_part(metadata$filename, '_', 1) as country
from youtube.public.ex_table_youtube_trending;
--split_part(<string>, <delimiter>, <partNumber>);


SELECT *
FROM table_youtube_trending
WHERE country = 'FR'
LIMIT 1000;



-- Creating an external table for youtube category data
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_category
WITH LOCATION = @stage_azure_youtube
FILE_FORMAT = (TYPE = JSON)
PATTERN = '.*[.]json';

-- Looking at the first 2 rows of the external table ex_table_youtube_trending
SELECT *
FROM youtube.public.ex_table_youtube_category
LIMIT 2;

-- Creating table_youtube_category table
CREATE OR REPLACE TABLE table_youtube_category as
SELECT 
split_part(metadata$filename, '_',1) as country,
l1.value:id::int as categoryid,
l2.value:title::varchar as category_title
FROM youtube.public.ex_table_youtube_category,
LATERAL FLATTEN(value) as l0,
LATERAL FLATTEN(l0.value) as l1,
LATERAL FLATTEN(l1.value) as l2
WHERE category_title IS NOT NULL;

-- looking into the similar result as in assessment brief
SELECT *
FROM table_youtube_category
WHERE country = 'DE';


-- combining tables 
-- 1. table_youtube_trending.
-- 2. table_youtube_category
CREATE OR REPLACE TABLE table_youtube_final as
SELECT 
uuid_string() as id,
video_id, title,publishedat,channelid,channeltitle, t1.categoryid, category_title, trending_date,view_count,likes,dislikes,comment_count,comments_disabled,t1.country
FROM table_youtube_trending as t1 left join table_youtube_category as t2
on t1.country = t2.country and t1.categoryid = t2.categoryid;



-- taking a look at the final table
SELECT *
FROM table_youtube_final
WHERE country = 'DE'
LIMIT 100;