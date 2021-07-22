with day_max_amount as
(select 
    date_format(day,'%Y-%m-%d') as day,
    max(amount) as amount from Transactions
group by 1)

select transaction_id from Transactions
where (date_format(day,'%Y-%m-%d'),amount) in (select day,amount from day_max_amount)
order by 1