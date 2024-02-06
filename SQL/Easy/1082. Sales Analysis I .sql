-- mysql
select seller_id from Sales 
group by 1
having sum(price) =
(select sum(price) from Sales
group by seller_id
order by sum(price) desc limit 1)

-- MS sql
select seller_id from
(select seller_id, rank() over(order by sum(price) desc) as rank
from sales group by seller_id) b
where rank = 1



-- Python
import pandas as pd

def sales_analysis(product: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    # Calculate total sales price for each seller
    aggregated_sales = sales.groupby("seller_id").agg({"price": "sum"})

    # Filter the sellers with maximum total sales price
    best_sellers = aggregated_sales[
        aggregated_sales["price"] == aggregated_sales["price"].max()
    ].reset_index()

    return best_sellers[["seller_id"]]
