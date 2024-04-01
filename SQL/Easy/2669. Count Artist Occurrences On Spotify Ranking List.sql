select
artist,
count(distinct id) as occurrences
from Spotify
group by 1
order by 2 desc, 1