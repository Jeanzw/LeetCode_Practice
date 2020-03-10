select a.Id from Weather a, Weather b
where Datediff(a.RecordDate, b.RecordDate) = 1 
and a.Temperature>b.Temperature
#mysql的datediff的应用：
#https://www.w3school.com.cn/sql/func_datediff_mysql.asp


这里是不能用left join的，因为这样其实当第一天的温度是最大的时候：
{"headers": {"Weather": ["Id", "RecordDate", "Temperature"]}, 
  "rows": {"Weather": [[1, "2000-12-16", 3], [2, "2000-12-15", -1]]}}
那么其实得出的结果会是一个[]
  
select a.Id from Weather a
left join Weather b 
  on a.Id -1 = b.Id 
where a.Temperature > b.Temperature


