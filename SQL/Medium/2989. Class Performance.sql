with cte as
(select
student_id,
assignment1 + assignment2 + assignment3 as total_score
from Scores)

select max(total_score) - min(total_score) as difference_in_score from cte