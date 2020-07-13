CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
Declare M Int;
set M = N-1;  

  RETURN (
      # Write your MySQL query statement below.
      select distinct salary from Employee order by Salary Desc limit M,1  --我们这里相当于先把前M给砍掉，然后取1个，那么这个就是第N个了
  );
END


--这一道题，我其实觉得根本就是个没有必要的存在……因为现实生活中，如果我们要去看第几，直接row_number或者用rank或者用dense_rank就好了
--而不会像这道题一样，一定要你用一个变量