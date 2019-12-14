select a.Id from Weather a, Weather b
where Datediff(a.RecordDate, b.RecordDate) = 1 
and a.Temperature>b.Temperature
#mysql的datediff的应用：
#https://www.w3school.com.cn/sql/func_datediff_mysql.asp