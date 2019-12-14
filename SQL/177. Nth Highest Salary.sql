CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
Declare M Int;
set M = N-1;

  RETURN (
      # Write your MySQL query statement below.
      select distinct salary from Employee order by Salary Desc limit M,1  #我们这里相当于先把前M给砍掉，然后取1个，那么这个就是第N个了
  );
END




