-- 这道题容易出现的问题是忽略了这一句话：
-- find the npv of all each query of queries table
-- 这就相当于我们要保证Queries的结构不变，而不是说要做一个sum
select a.*,ifnull(npv,0) as npv from Queries a
left join NPV b on a.id = b.id and a.year = b.year