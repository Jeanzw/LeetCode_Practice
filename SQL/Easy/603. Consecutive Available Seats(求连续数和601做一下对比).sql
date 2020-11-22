select distinct a.seat_id from cinema as a
join cinema as b
on abs(a.seat_id - b.seat_id) = 1 and a.free = 1 and b.free = 1
order by a.seat_id
/*如果不用abs()当然也是可以的，但是就是需要
a.seat_id = b.seat_id + 1 or a.seat_id = b.seat_id - 1这样的形式了
和601做一下对比*/


with raw_data as
(select * from cinema where free = 1)

select distinct r1.seat_id from raw_data r1
join raw_data r2 
on r1.seat_id + 1 = r2.seat_id or r2.seat_id + 1 = r1.seat_id
order by 1