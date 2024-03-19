select
concat(group_concat(term order by power desc separator ''), '=0') as equation
from (
select
CONCAT(case when factor > 0 then '+' else '' end, 
       factor, 
       case when power = 0 then '' else 'X' end, 
       case when power = 0 or power = 1 then '' else '^' end, 
       case when power = 0 or power = 1 then '' else power end
) term,
power
from
terms
order by power desc) t;