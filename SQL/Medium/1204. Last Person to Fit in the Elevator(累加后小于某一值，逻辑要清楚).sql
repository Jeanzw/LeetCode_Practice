select person_name from Queue
where turn =
(select a.turn from Queue a,Queue b
where a.turn >= b.turn
group by a.turn
having sum(b.weight)<=1000  
/*这里相当于就是说，把小于a.turn的b.turn的重量加起来
因为a.turn >= b.turn，所以当a.turn = 1的时候，b.turn = 1，那么sum(b.weight)就是turn = 1的重量
当a.turn = 2的时候，b.turn <= 2，那么sum(b.weight)就是turn = 1+2的重量
当a.turn = 3的时候，b.turn <= 3，那么sum(b.weight)就是turn = 1+2+3的重量
所以抽出来的内容会是前三排的
而我最后用一个order by就是抽取最后一个turn也就是我们想要的内容*/
order by a.turn desc limit 1)



-- 下面这种方法应该更容易理解：
-- 我们用一个sum() over来统计重量
-- 然后只要保证这个统计的重量是小于1000的
-- 接着我们按照turn来排名，取1个就好
select person_name from
(select 
    person_id,
    person_name,
    turn,
    sum(weight) over (order by turn) as sum_weight
    from Queue)tmp
    where sum_weight <=1000
    order by turn desc limit 1