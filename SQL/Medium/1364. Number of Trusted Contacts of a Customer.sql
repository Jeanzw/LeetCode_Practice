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