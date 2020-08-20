select a.*,ifnull(npv,0) as npv from Queries a
left join NPV b on a.id = b.id and a.year = b.year