select sum(TIV_2016) as TIV_2016 from insurance
where TIV_2015 IN (select TIV_2015 from insurance group by TIV_2015 having count(*) >1)
and
concat(LAT,LON) IN (select concat(LAT,LON) from insurance group by LAT,LON having count(*)=1)

/*or*/

select round(sum(TIV_2016),2) as TIV_2016 from Insurance
where TIV_2015 in (select TIV_2015 from insurance group by TIV_2015 having count(TIV_2015) > 1)
and concat(LAT,LON) not in   /*我们这里就是要将两个维度放在一起考虑的，所以这里一定要用concat将他们两个给组合到一起*/
(select concat(LAT,LON) from insurance group by LAT,LON having count(concat(LAT,LON)) > 1)




-- 其实我们也可以不用concat，而直接用
with unique_tiv_2015 as
(select TIV_2015 from insurance
group by 1
having count(*) = 1)
-- 上面我们找出TIV_2015是独一无二的，然后保证最后结果不在这之内
, unique_location as
(select LAT,LON from insurance
group by 1,2
having count(*) = 1)
-- 上面这我们找出LAT，LON是独一无二的，然后保证最后结果就在这之内

select round(sum(TIV_2016),2) as TIV_2016 from insurance 
where TIV_2015 not in (select * from unique_tiv_2015)
and (LAT,LON) in (select * from unique_location)
