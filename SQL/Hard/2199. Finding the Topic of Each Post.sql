select
a.post_id,
ifnull(group_concat(distinct topic_id order by topic_id), 'Ambiguous!') as topic
from posts a
left join keywords b on concat(' ', lower(a.content), ' ') like concat('% ', lower(b.word), ' %')
group by 1
