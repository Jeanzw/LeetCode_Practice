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

-- 我其实无论做多少次，我都不能理解这个max的逻辑
-- 但是如果直接用if那么其实就容易理解多了
select id,
sum(if(month = 'Jan',revenue,null)) as Jan_Revenue,
sum(if(month = 'Feb',revenue,null)) as Feb_Revenue,
sum(if(month = 'Mar',revenue,null)) as Mar_Revenue,
sum(if(month = 'Apr',revenue,null)) as Apr_Revenue,
sum(if(month = 'May',revenue,null)) as May_Revenue,
sum(if(month = 'Jun',revenue,null)) as Jun_Revenue,
sum(if(month = 'Jul',revenue,null)) as Jul_Revenue,
sum(if(month = 'Aug',revenue,null)) as Aug_Revenue,
sum(if(month = 'Sep',revenue,null)) as Sep_Revenue,
sum(if(month = 'Oct',revenue,null)) as Oct_Revenue,
sum(if(month = 'Nov',revenue,null)) as Nov_Revenue,
sum(if(month = 'Dec',revenue,null)) as Dec_Revenue
from Department
group by 1 