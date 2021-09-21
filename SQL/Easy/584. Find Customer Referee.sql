-- 两种做法，一种是直接如下使得referee_id 不等于2或者为null
-- 另一种做法就是抽出为2的，然后再抽出name，使得referee_id不在这之列就好了
select name from customer where referee_id != 2 or referee_id is null


-- 也可以
select name from customer
where id not in (select id from customer where referee_id = 2)
-- 如果我们用第二种方法，那么需要注意：
-- 这道题需要注意的点在于：
-- ①存在同名不同id的人，那么我们①不能用name作为not in的指标 
-- ②不能用distinct name，因为虽然名字一样但是id不一样所以是不一样的人