-- Mysql
select product_id,year as first_year,quantity,price from Sales
where (product_id, year) in
(
select product_id,min(year) as first_year from Sales
group by 1)

-- MS SQL
select product_id,year as first_year,quantity,price from
(select *, rank() over (partition by product_id order by year) as rnk from Sales)tmo
where rnk = 1


-- Python
import pandas as pd

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
  df = sales.groupby('product_id', as_index=False)['year'].min()
  return sales.merge(df, on='product_id', how='inner')\
    .query('year_x == year_y')\
    .rename(columns={'year_x': 'first_year'})\
    [['product_id', 'first_year', 'quantity', 'price']]
  