/*解说过程
如果两表联合应该是这样的
Id	Employee-id	amount	Pay_date	Department_id
1	1	        9000	2017-03-31	1
2	2	        6000	2017-03-31	2
3	3	        10000	2017-03-31	2
4	1	        7000	2017-02-28	1
5	2	        6000	2017-02-28	2
6	3	        8000	2017-02-28	2

然后我们从中抽取想要的列
select department_id, avg(amount) as department_avg, date_format(pay_date,'%Y-%m') as pay_month
from Salary left join employee on employee.employee_id = salary.employee_id
group by department_id,pay_month

Department_id	department_avg 	pay_month
1	            7000.0000	2017-02
1	            9000.0000	2017-03
2	            7000.0000	2017-02
2	            8000.0000	2017-03

select avg(amount) as month_avg, date_format(pay_date,'%Y-%m') as pay_month
from salary
group by pay_month

month_avg	pay_month
7000.0000	2017-02
8333.3333	2017-03


department_id	department_avg	pay_month	month_avg	pay_month
1	            7000.0000	    2017-02	    7000.0000	2017-02
2	            7000.0000	    2017-02	    7000.0000	2017-02
1	            9000.0000	    2017-03	    8333.3333	2017-03
2	            8000.0000	    2017-03	    8333.3333	2017-03

*/


select a.pay_month, department_id,
case 
when department_avg>month_avg then 'higher'
when department_avg<month_avg then 'lower'
else 'same' end as comparison
from 
(select department_id, avg(amount) as department_avg, date_format(pay_date,'%Y-%m') as pay_month
from Salary join employee on employee.employee_id = salary.employee_id
group by department_id,pay_month) as a
join
(select avg(amount) as month_avg, date_format(pay_date,'%Y-%m') as pay_month
from salary
group by pay_month) as b
on a.pay_month = b.pay_month
order by pay_month desc, department_id