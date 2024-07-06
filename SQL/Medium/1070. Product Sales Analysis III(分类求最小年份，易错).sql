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


-- 之所以用rank可以但是用row_number不可以是因为这道题目可能出现同一年里有多条records
-- 而题目最后想要实现的是：如果同一年里有多条records那么我们就把这些records全部抽出来



-- Python
import pandas as pd

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
  df = sales.groupby('product_id', as_index=False)['year'].min()
  return sales.merge(df, on='product_id', how='inner')\
    .query('year_x == year_y')\
    .rename(columns={'year_x': 'first_year'})\
    [['product_id', 'first_year', 'quantity', 'price']]
  