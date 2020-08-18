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