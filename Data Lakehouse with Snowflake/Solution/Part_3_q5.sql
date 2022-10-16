SELECT
channeltitle, count(distinct(video_id)) as video_count
from table_youtube_final    
GROUP by channeltitle
ORDER BY video_count DESC
LIMIT 1;
