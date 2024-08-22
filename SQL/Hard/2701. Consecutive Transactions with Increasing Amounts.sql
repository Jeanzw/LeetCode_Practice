-- 这道题目和我们之前连续数的题目不一样的地方在于我们不仅仅是要把对应的customer_id给求出来，而是只要连续就把起止点求出来
-- 但我们逻辑还是和之前一样的，就是要找个bridge
-- 这一道题目的bridge就完全体现了date function的应用了

with summary as
(select
distinct a.customer_id,
a.transaction_date as fir,
b.transaction_date as sec,
c.transaction_date as thi,
row_number() over (partition by a.customer_id order by a.transaction_date desc) as rnk
from Transactions a
inner join Transactions b on a.customer_id = b.customer_id and datediff(day,a.transaction_date,b.transaction_date) = 1 and a.amount < b.amount
inner join Transactions c on b.customer_id = c.customer_id and datediff(day,b.transaction_date,c.transaction_date) = 1 and b.amount < c.amount)


select customer_id, min(fir) as consecutive_start, max(thi) as consecutive_end from summary
group by customer_id, dateadd(day, rnk,fir)
order by 1


-- Python
import pandas as pd

def consecutive_increasing_transactions(transactions: pd.DataFrame) -> pd.DataFrame:
    # Sort transactions by customer_id and transaction_date, then reset index
    transactions_sorted = (
        transactions.sort_values(["customer_id", "transaction_date"])
        .reset_index()
    )

    # Create a group identifier for consecutive days ('day_group')
    # Subtracting the transaction date from a fixed date to get the number of days since that date
    # and then subtracting the row index to form groups of consecutive days
    transactions_sorted["day_group"] = (
        transactions_sorted["transaction_date"] - pd.to_datetime("2023-01-01")
    ).dt.days - transactions_sorted.index

    # Create a group identifier for increasing transaction amounts ('amount_group')
    # Formed by cumulatively summing where the transaction amount is not greater than the previous amount
    transactions_sorted["amount_group"] = (
        (transactions_sorted.amount <= transactions_sorted.amount.shift(1))
        .cumsum()
        .fillna(0)
    )

    # Group by customer_id, day_group, and amount_group and perform aggregations
    grouped_transactions = (
        transactions_sorted.groupby(["customer_id", "day_group", "amount_group"])
        .agg(
            count=("index", "count"),
            consecutive_start=("transaction_date", "min"),
            consecutive_end=("transaction_date", "max"),
        )
        .reset_index()
    )

    # Filter groups with at least three consecutive increasing transactions and select relevant columns
    result = grouped_transactions.query("count > 2")[
        ["customer_id", "consecutive_start", "consecutive_end"]
    ]

    return result
