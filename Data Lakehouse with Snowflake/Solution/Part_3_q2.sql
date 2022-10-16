SELECT
country,count(DISTINCT(video_id)) as ct
FROM table_youtube_final
where contains(UPPER(title),'BTS')
GROUP BY country
ORDER by ct DESC;