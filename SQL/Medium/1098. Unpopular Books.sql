select book_id,name from Books 
where available_from < '2019-05-23'
and book_id not in
(
    select book_id from Orders
where dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
group by book_id
having sum(quantity) >= 10
)