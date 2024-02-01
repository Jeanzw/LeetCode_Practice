# Write your MySQL query statement below
select *,
case when x + y > z and x + z > y and z + y > x then 'Yes' else 'No' end as triangle from triangle


-- Python
import pandas as pd

def triangle_judgement(triangle: pd.DataFrame) -> pd.DataFrame:

    # Define a function to check if three sides can form a triangle
    def is_triangle(row):
        return (
            "Yes"
            if (row["x"] + row["y"] > row["z"])
            and (row["y"] + row["z"] > row["x"])
            and (row["z"] + row["x"] > row["y"])
            else "No"
        )

    # Apply the function to each row in the DataFrame
    triangle["triangle"] = triangle.apply(is_triangle, axis=1)

    # Return the updated DataFrame
    return triangle
