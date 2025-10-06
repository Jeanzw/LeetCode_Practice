WITH RECURSIVE level_cte AS 
-- 这个cte就会让所有的员工不停地进行链接，level不停升高，直到找到最后的大老板停止
-- 而这个时候，最大的level就是这个员工最后应该在的level
(
  SELECT employee_id, manager_id, 1 AS level, salary -- 这里其实相当于是给每一个employee_id一个初时的level
  FROM Employees
  
  UNION ALL

  SELECT a.employee_id, b.manager_id, level + 1, a.salary
  FROM level_cte a
  JOIN Employees b ON b.employee_id = a.manager_id
)
,employee_with_level AS 
-- 这是每个employee最真实的等级
-- 当我们选定了manager_id IS NULL也就是说，当这个员工连接到了最大的老板那么对应的level就是其所在的level
(
  select employee_id, employee_name, level, salary 
  from cte 
  where manager_id is null
)
, team_size_budget as
-- 计算每个manager下面的team size以及budget（不包含自己）
-- 虽然找到这个员工最真实的level我们需要manager_id IS NULL
-- 但是如果找到某个人底下有多少人，那么我们就不能让manager_id IS NULL而应该使用manager_id IS NOT NULL
(SELECT 
    manager_id AS employee_id,
    COUNT(*) AS team_size,
    SUM(salary) AS budget
  FROM level_cte
  WHERE manager_id IS NOT NULL
  GROUP BY manager_id)


SELECT 
  a.employee_id,
  a.employee_name,
  a.level,
  COALESCE(b.team_size, 0) AS team_size,
  a.salary + COALESCE(b.budget, 0) AS budget
FROM employee_with_level a
LEFT JOIN team_size_budget b ON a.employee_id = b.employee_id
ORDER BY level, budget DESC, employee_name