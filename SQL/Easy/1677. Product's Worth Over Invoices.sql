select 
    name,
    # p.product_id,
    ifnull(sum(rest),0) as rest,
    ifnull(sum(paid),0) as paid,
    ifnull(sum(canceled),0) as canceled,
    ifnull(sum(refunded),0) as refunded
    from Invoice i
    left join Product p on i.product_id = p.product_id
    group by 1
    order by 1

-------------------------------

-- Python
import pandas as pd

def analyze_products(product: pd.DataFrame, invoice: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(product,invoice,on = 'product_id',how = 'left')
    merge = merge.groupby(['name'],as_index = False).agg(
        rest = ('rest','sum'),
        paid = ('paid','sum'),
        canceled = ('canceled','sum'),
        refunded = ('refunded','sum')
    ).fillna(0)
    return merge.sort_values('name')