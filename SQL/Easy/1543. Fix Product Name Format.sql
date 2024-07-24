-- 其实这道题的关键就在于如何删减空格
-- SQL 中的TRIM 函数是用来移除掉一个字串中的字头或字尾。 最常见的用途是移除字首或字尾的空白。 这个函数在不同的资料库中有不同的名称： MySQL: TRIM( ), RTRIM( ), LTRIM( )
SELECT LOWER(TRIM(product_name)) product_name, DATE_FORMAT(sale_date, "%Y-%m") sale_date, count(sale_id) total
FROM sales
GROUP BY 1, 2
ORDER BY 1, 2


-- Python
import pandas as pd

def fix_name_format(sales: pd.DataFrame) -> pd.DataFrame:
    sales['product_name'] = sales['product_name'].str.lower().str.strip()
    sales['sale_date'] = sales['sale_date'].dt.strftime('%Y-%m')

    res = sales.groupby(['product_name','sale_date'],as_index = False).sale_id.nunique().rename(columns = {'sale_id':'total'})
    return res.sort_values(['product_name','sale_date'])