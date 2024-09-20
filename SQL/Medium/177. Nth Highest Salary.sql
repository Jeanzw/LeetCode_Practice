--这一道题，我其实觉得根本就是个没有必要的存在……因为现实生活中，如果我们要去看第几，直接row_number或者用rank或者用dense_rank就好了
--而不会像这道题一样，一定要你用一个变量


CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT;
SET M=N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT M, 1 
      --我们这里相当于先把前M给砍掉，然后取1个，那么这个就是第N个了
  );
END




-- 下面这种方式就是不需要variable
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
-- # DECLARE M INT;
-- # SET M = N - 1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT e1.Salary
      FROM (SELECT DISTINCT Salary FROM Employee) e1
      WHERE (SELECT COUNT(*) FROM (SELECT DISTINCT Salary FROM Employee) e2 WHERE e2.Salary > e1.Salary) = N - 1      
      
      LIMIT 1
      
  );
END



-- 下面这种方式却是最容易理解的
-- 用一个dense_rank来帮助我们排序，同时不需要任何的variable
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select distinct Salary
      from 
      (select DENSE_RANK() over (order by Salary desc) as r, Salary
        from Employee
       ) as t
      where r =N
  );
END




-- Python
import pandas as pd

def nth_highest_salary(employee: pd.DataFrame, N: int) -> pd.DataFrame:
    employee['rnk'] = employee.salary.rank(method = 'dense', ascending = False).astype("int")
    if employee['rnk'].max() < N or N < 1:
        return pd.DataFrame({f'getNthHighestSalary({N})': [None]})
    employee = employee[employee['rnk'] == N]
    return employee[['salary']].drop_duplicates().rename(columns={'salary':f'getNthHighestSalary({N})'})