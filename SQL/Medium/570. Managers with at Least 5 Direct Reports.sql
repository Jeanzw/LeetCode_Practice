select Name from Employee where Id in
(select ManagerId from Employee
group by 1 having count(ManagerId) >= 5)