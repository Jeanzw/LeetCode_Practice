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


-- 其实直接用case when就可以了呀……
select 
    id,
    sum(case when month = 'Jan' then revenue else null end) as Jan_Revenue,
    sum(case when month = 'Feb' then revenue else null end) as Feb_Revenue,
    sum(case when month = 'Mar' then revenue else null end) as Mar_Revenue,
    sum(case when month = 'Apr' then revenue else null end) as Apr_Revenue,
    sum(case when month = 'May' then revenue else null end) as May_Revenue,
    sum(case when month = 'Jun' then revenue else null end) as Jun_Revenue,
    sum(case when month = 'Jul' then revenue else null end) as Jul_Revenue,
    sum(case when month = 'Aug' then revenue else null end) as Aug_Revenue,
    sum(case when month = 'Sep' then revenue else null end) as Sep_Revenue,
    sum(case when month = 'Oct' then revenue else null end) as Oct_Revenue,
    sum(case when month = 'Nov' then revenue else null end) as Nov_Revenue,
    sum(case when month = 'Dec' then revenue else null end) as Dec_Revenue
    from Department 
    group by 1




-- Python
import pandas as pd

def reformat_table(department: pd.DataFrame) -> pd.DataFrame:
    prefixes = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    # 下面在做pivot的时候已经确定了index，但是只index被隐藏起来了，所以在最后的最后需要reset_index
    by_month = department.pivot(index = 'id', columns = 'month',values = 'revenue')
    # 将上面创的一月到十二月的列表插入
    by_month = by_month.reindex(columns = prefixes)
    # 给列重新取名字，我们这里用lambda的形式
    by_month.rename(columns=lambda title: title + "_Revenue", inplace=True)
    # 用reset_index将id给显现化
    by_month.reset_index(inplace = True)
    return by_month