select num from my_numbers
group by num
having count(*) = 1
order by num desc limit 1

--上面是我原本的写法，这个写法一般没有问题，可是有一点，当我们没有这个数的时候，我们希望返回的是null而不是空值
--因为这个原因，我们只能用max，因为max会考虑空值
select max(num) as num from
(select num from my_numbers
group by num
having count(*) = 1) tno
