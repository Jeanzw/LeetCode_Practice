select
a.post_id,
ifnull(group_concat(distinct topic_id order by topic_id), 'Ambiguous!') as topic
from posts a
left join keywords b on concat(' ', lower(a.content), ' ') like concat('% ', lower(b.word), ' %')
-- 这里我们之所以需要前后都有空格出现是为了防止这样的情况：
-- 关键词是WAR
-- 而但此时warning
group by 1
