
-- 最新的做法，把买了AB给抽出来，再把买了C的给抽出来，然后用join链接，确保C的那一端连不到即可
with bought_a_b as
(select
a.customer_id,
a.customer_name
from Customers a
inner join Orders b on a.customer_id = b.customer_id
where product_name in ('A','B')
group by 1,2
having count(distinct product_name) = 2
)
, bought_c as
(select
a.customer_id,
a.customer_name
from Customers a
inner join Orders b on a.customer_id = b.customer_id
where product_name in ('C')
group by 1,2
)

select
a.*
from bought_a_b a
left join bought_c b on a.customer_id = b.customer_id
where b.customer_id is null
order by 1

-----------------------------------

select distinct customer_id, customer_name from Customers
where customer_id in (select customer_id from Orders where product_name = 'A')
and customer_id in (select customer_id from Orders where product_name = 'B')
and customer_id not in (select customer_id from Orders where product_name = 'C')
ORDER BY customer_id

-----------------------------------

-- 另一种做法
select c.customer_id, c.customer_name 
from Customers as c
    inner join
    (select customer_id, 
        sum(CASE
        WHEN product_name = 'A' THEN 1
        WHEN product_name = 'B' THEN 1
        WHEN product_name = 'C' THEN -1
        ELSE 0 END) as tot   
    from Orders
    group by customer_id
    having tot > 1) as o
where c.customer_id = o.customer_id
ORDER BY customer_id

-----------------------------------

-- 另一种做法
select o.customer_id,customer_name 
from Orders o 
left join Customers c on o.customer_id = c.customer_id
where product_name in ('A','B')  --这里是保证customer买了A和B
and o.customer_id not in (select customer_id from Orders where product_name = 'C')  --这里保证了customer买了C
group by 1
having count(distinct product_name) = 2

-----------------------------------

-- 另一种做法
select 
distinct a.customer_id, a.customer_name
from Customers a
join Orders b on a.customer_id = b.customer_id and b.product_name = 'A'
join Orders c on a.customer_id = c.customer_id and c.product_name = 'B'
left join Orders d on a.customer_id = d.customer_id and d.product_name = 'C'
where d.customer_id is null

-----------------------------------

-- Python
import pandas as pd

def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    a_b = orders[orders['product_name'].isin(['A','B'])].groupby(['customer_id'],as_index = False).product_name.nunique()
    a_b = a_b[a_b['product_name'] == 2]

    c = orders[orders['product_name'] == 'C'][['customer_id','product_name']].drop_duplicates()

    merge = pd.merge(customers,a_b, on = 'customer_id').merge(c, on = 'customer_id', how = 'left')
    return merge[merge['product_name_y'].isna()][['customer_id','customer_name']].sort_values('customer_id')

-----------------------------------

-- 也可以这么做
import pandas as pd

def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    A_B = orders[orders['product_name'].isin(['A','B'])]
    A_B = A_B.groupby(['customer_id'], as_index = False).product_name.nunique()
    A_B = A_B[A_B['product_name'] == 2][['customer_id']]

    C = orders[orders['product_name'] == 'C'][['customer_id']]
    A_B_not_C = A_B[~A_B['customer_id'].isin(C['customer_id'])]

    res = pd.merge(customers,A_B_not_C,on = 'customer_id')
    return res.sort_values('customer_id')