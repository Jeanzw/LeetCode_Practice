select
a.post_id,
ifnull(group_concat(distinct topic_id order by topic_id), 'Ambiguous!') as topic
from posts a
left join keywords b on concat(' ', lower(a.content), ' ') like concat('% ', lower(b.word), ' %')
-- 表b之所以需要前后都有空格出现是为了防止这样的情况：
-- 关键词是WAR
-- 而但此时warning

-- 而表a之所以也需要空格，是因为我们表b加了空格
-- 比如说表a的content最后一个单词是handball
-- 但是表b的word其实已经变成了’ handball ‘
-- 这种情况下，如果我们不加空格，那么这个handball我们是识别不出来是关键词的
group by 1
