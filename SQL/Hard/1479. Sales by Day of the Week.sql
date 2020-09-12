select 
    item_category as Category,
    sum(case when weekday(order_date) = 0 then quantity else 0 end) as Monday,
    sum(case when weekday(order_date) = 1 then quantity else 0 end) as Tuesday,
    sum(case when weekday(order_date) = 2 then quantity else 0 end) as Wednesday,
    sum(case when weekday(order_date) = 3 then quantity else 0 end) as Thursday,
    sum(case when weekday(order_date) = 4 then quantity else 0 end) as Friday,
    sum(case when weekday(order_date) = 5 then quantity else 0 end) as Saturday,
    sum(case when weekday(order_date) = 6 then quantity else 0 end) as Sunday
from Items i left join Orders o on i.item_id = o.item_id
group by 1
order by 1
