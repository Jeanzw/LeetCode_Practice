WITH RECURSIVE a AS (
    SELECT  id,
            ROW_NUMBER() OVER () AS new_id,
            drink
    FROM CoffeeShop
), cte AS (
    SELECT  id,
            drink,
            new_id
    FROM a
    WHERE new_id = 1
    
    UNION ALL
    
    SELECT  a.id,
            (CASE WHEN a.drink iS NULL THEN cte.drink ELSE a.drink END) AS drink,
            a.new_id
    FROM cte JOIN a ON cte.new_id + 1 = a.new_id   
)

SELECT  id,
        drink
FROM cte