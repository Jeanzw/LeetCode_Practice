select Name as Customers from Customers
where Id not in (select CustomerId from Orders)



-- 也可以用下面的query来写
select
    Name as Customers
    from Customers c
    left join Orders o on c.Id = o.CustomerId
    where o.CustomerId is null