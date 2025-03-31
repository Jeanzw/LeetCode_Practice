select name from salesperson where sales_id not in(
select sales_id from orders where com_id in
(select com_id from company where name = 'RED'))

------------------------

-- 也可以用left join来做
-- 但是我们需要注意一点：有些salesperson可能是做成了两单生意，一单是卖给了RED另一单是卖给了其他公司
-- 那么如果我们只是用subquery里面的query，然后确定c.name ！= 'RED'就会把上面的salesperson给算在内了
-- 所以为了避免这种情况的发生，我们选择用一个not in，也就是先把和RED公司做交易的salesperson给抽出来，而后排除掉它
select name from salesperson
where name not in
(select 
s.name
from salesperson s
left join orders o on s.sales_id = o.sales_id
left join company c on o.com_id = c.com_id
where c.name = 'RED')

------------------------

-- 用join做
With red as
(select 
distinct a.sales_id
from SalesPerson a
inner join Orders b on a.sales_id = b.sales_id
inner join Company c on b.com_id = c.com_id and c.name = 'Red'
)

select 
name
from SalesPerson a
left join red b on a.sales_id = b.sales_id
where b.sales_id is null

------------------------

-- Python
import pandas as pd

def sales_person(sales_person: pd.DataFrame, company: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(sales_person,orders,on = 'sales_id').merge(company, on ='com_id')
    merge = merge[merge['name_y'] == 'RED'][['sales_id','name_x']]

    not_red = pd.merge(sales_person,merge,on = 'sales_id', how = 'left')
    not_red = not_red[not_red['name_x'].isna()]
    return not_red[['name']]

------------------------

-- 也可以这么做
import pandas as pd

def sales_person(sales_person: pd.DataFrame, company: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    company_red = company[company['name'] == 'RED']
    red = pd.merge(sales_person,orders,on = 'sales_id').merge(company_red, on = 'com_id')[['sales_id']]
    res = sales_person[~sales_person['sales_id'].isin(red['sales_id'])]
    return res[['name']]