select round(sqrt(min(pow(a.x - b.x,2) + pow(a.y - b.y,2))),2) as shortest from point_2d a,point_2d b
where a.x != b.x or a.y != b.y

/*另一种说法*/
SELECT
    ROUND(SQRT(MIN((POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)))), 2) AS shortest
FROM
    point_2d p1
        JOIN
    point_2d p2 ON p1.x != p2.x OR p1.y != p2.y