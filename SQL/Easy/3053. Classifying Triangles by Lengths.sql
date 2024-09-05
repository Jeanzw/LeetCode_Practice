select
case when A + B <= C or A + C <= B or B + C <= A then 'Not A Triangle'
     when A = B and A = C and B = C then 'Equilateral'
     when (A = B and A != C) or (A = C and A != B) or (B = C and A != B) then 'Isosceles'
     else 'Scalene' end as triangle_type
from Triangles


-- Python
import pandas as pd
import numpy as np

def type_of_triangle(triangles: pd.DataFrame) -> pd.DataFrame:
    triangles['triangle_type'] = np.where((triangles['A'] + triangles['B']<= triangles['C']) | (triangles['B'] + triangles['C']<= triangles['A']) | (triangles['A'] + triangles['C']<= triangles['B']),'Not A Triangle',
    np.where((triangles['A'] == triangles['B']) & (triangles['B'] == triangles['C']),'Equilateral',
    np.where((triangles['A'] == triangles['B']) |(triangles['B'] == triangles['C'])|(triangles['C'] == triangles['A']),'Isosceles','Scalene')
    ))
    return triangles[['triangle_type']]