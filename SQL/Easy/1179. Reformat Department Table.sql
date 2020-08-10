select id, 
max(case month when 'Jan' then revenue else null end) as 'Jan_Revenue', 
max(case month when 'Feb' then revenue else null end) as 'Feb_Revenue',
max(case month when 'Mar' then revenue else null end) as 'Mar_Revenue',
max(case month when 'Apr' then revenue else null end) as 'Apr_Revenue',
max(case month when 'May' then revenue else null end) as 'May_Revenue',
max(case month when 'Jun' then revenue else null end) as 'Jun_Revenue',
max(case month when 'Jul' then revenue else null end) as 'Jul_Revenue',
max(case month when 'Aug' then revenue else null end) as 'Aug_Revenue',
max(case month when 'Sep' then revenue else null end) as 'Sep_Revenue',
max(case month when 'Oct' then revenue else null end) as 'Oct_Revenue',
max(case month when 'Nov' then revenue else null end) as 'Nov_Revenue',
max(case month when 'Dec' then revenue else null end) as 'Dec_Revenue'
from Department
group by id order by id