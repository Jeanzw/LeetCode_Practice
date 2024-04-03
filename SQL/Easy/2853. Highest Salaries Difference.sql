select
abs(max(case when department= 'Marketing' then salary end) - max(case when department= 'Engineering' then salary end)) as salary_difference
from Salaries