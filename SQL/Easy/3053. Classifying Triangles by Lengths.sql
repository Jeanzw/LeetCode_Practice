select
case when A + B <= C or A + C <= B or B + C <= A then 'Not A Triangle'
     when A = B and A = C and B = C then 'Equilateral'
     when (A = B and A != C) or (A = C and A != B) or (B = C and A != B) then 'Isosceles'
     else 'Scalene' end as triangle_type
from Triangles