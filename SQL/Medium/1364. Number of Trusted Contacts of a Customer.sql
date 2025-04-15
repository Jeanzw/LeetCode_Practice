-- 这一道题一个默认条件就是如果
-- Invoices =
-- | invoice_id | price | user_id |
-- | ---------- | ----- | ------- |
-- 那么不返回任何结果，这就意味着我们invoices和别的表其实应该是join关系而不是left join关系


-- 当表多起来的时候，我其实更推荐用cte，然后把所有内容变得清晰一点。
with users_summary as
(select
a.customer_id,
a.customer_name,
count(b.contact_name) as contacts_cnt,
count(c.customer_name) as trusted_contacts_cnt
from Customers a
left join Contacts b on a.customer_id = b.user_id
left join Customers c on b.contact_name = c.customer_name and b.contact_email = c.email
group by 1,2
)
-- 先用cte把users的内容给搞定，确定好有多少一个users对应的contact是多少，以及trusted contract是多少

select
invoice_id,
customer_name,
price,
contacts_cnt,
trusted_contacts_cnt
from users_summary a
inner join Invoices b on a.customer_id = b.user_id
order by 1
-- 然后和Invoice这张表结合

-----------------------------------------------

select 
    invoice_id , 
    b.customer_name,
    price,
    count(c.user_id) as contacts_cnt,
    count(b2.email) as trusted_contacts_cnt
    from Invoices a 
    left join Customers b on a.user_id = b.customer_id
    left join Contacts c on c.user_id = b.customer_id
    left join Customers b2 on b2.email = c.contact_email  --use email instead of name in case two contacts have same name
group by 1,2,3
order by 1

-----------------------------------------------

-- 第二种做法
select i.invoice_id,
c.customer_name,
i.price ,
count(cont.contact_email) contacts_cnt ,
Sum(If(cont.contact_email in (Select distinct email from Customers),1,0)) trusted_contacts_cnt
from invoices i
join customers c on c.customer_id = i.user_id
left join Contacts cont on cont.user_id = c.customer_id
group by i.invoice_id
order by i.invoice_id

-----------------------------------------------

-- 之后的做法：
-- 我们首先判断Contacts这张表到底哪些是trust的哪些不是
-- 而后再进行常规操作
with trust as
(select 
    user_id,
    contact_name,
    case when customer_name is not null then 'trusted' else 'untrusted' end as trust_or_not
from Contacts c left join Customers cu on c.contact_name = cu.customer_name)

select 
invoice_id,
customer_name,
price,
count(contact_name) as contacts_cnt,
sum(case when trust_or_not = 'trusted' then 1 else 0 end) as trusted_contacts_cnt
from Invoices i 
left join Customers c on i.user_id = c.customer_id
left join trust t on i.user_id = t.user_id
group by 1,2,3
order by 1

-----------------------------------------------

-- 另一种做法
with cnt as
(select 
user_id,
count(distinct contact_name) as contacts_cnt,
count(customer_name) as trusted_contacts_cnt
from
Contacts co
left join Customers c 
on co.contact_name = c.customer_name and co.contact_email = c.email
group by 1)


select 
invoice_id,
customer_name,
price,
ifnull(contacts_cnt,0) as contacts_cnt,
ifnull(trusted_contacts_cnt,0) as trusted_contacts_cnt
from Invoices i 
left join Customers c on i.user_id = c.customer_id
left join cnt on i.user_id = cnt.user_id
order by 1

-----------------------------------------------

-- Python
-- 上面写的我觉得有点复杂了
-- 我的思路就是直接全部join起来，然后最后进行aggregation的处理
import pandas as pd

def count_trusted_contacts(customers: pd.DataFrame, contacts: pd.DataFrame, invoices: pd.DataFrame) -> pd.DataFrame:
    invoices_customers = pd.merge(invoices,customers, left_on = 'user_id', right_on = 'customer_id', how = 'left')
    invoices_customers_contacts = pd.merge(invoices_customers,contacts, on ='user_id', how = 'left')
    summary = pd.merge(invoices_customers_contacts,customers,left_on = 'contact_email', right_on = 'email', how = 'left')
    summary = summary[['invoice_id','price','customer_name_x','contact_name','email_y']].drop_duplicates()

    res = summary.groupby(['invoice_id','customer_name_x','price'], as_index = False).agg(
        contacts_cnt = ('contact_name','count'),
        trusted_contacts_cnt = ('email_y','count')
    )
    return res.rename(columns = {'customer_name_x':'customer_name'}).sort_values('invoice_id')

-----------------------------------------------

-- 第二次写的
import pandas as pd

def count_trusted_contacts(customers: pd.DataFrame, contacts: pd.DataFrame, invoices: pd.DataFrame) -> pd.DataFrame:
    merge1 = pd.merge(invoices,customers,left_on = 'user_id',right_on = 'customer_id').merge(contacts, on = 'user_id',how = 'left').merge(customers,left_on = 'contact_email',right_on = 'email',how = 'left')
    summary = merge1.groupby(['invoice_id','customer_name_x','price'],as_index = False).agg(
        contacts_cnt = ('contact_name','nunique'),
        trusted_contacts_cnt = ('email_y','nunique')
    )
    return summary.rename(columns = {'customer_name_x':'customer_name'}).sort_values('invoice_id')
