SELECT 
e.left_operand, e.operator, e.right_operand,
    (
        CASE
            WHEN e.operator = '<' AND v1.value < v2.value THEN 'true'
            WHEN e.operator = '=' AND v1.value = v2.value THEN 'true'
            WHEN e.operator = '>' AND v1.value > v2.value THEN 'true'
            ELSE 'false'
        END
    ) AS value
FROM Expressions e
JOIN Variables v1
ON e.left_operand = v1.name
JOIN Variables v2
ON e.right_operand = v2.name

-- 我做的时候一直在想，我如何可以利用 v1.value 和 v2.value 的关系来解题
-- 但是我忽略了在case when 中应用operator这一个条件了