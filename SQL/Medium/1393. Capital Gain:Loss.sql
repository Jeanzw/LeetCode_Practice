select stock_name,
sum(case when operation = 'Buy' then -price else price end) as capital_gain_loss from Stocks
group by stock_name


-- Python
def solution(stocks: pd.DataFrame) -> pd.DataFrame:
    # Approach: groupby, apply
    # Helper function to update prices in stocks DataFrame
    def helper(operation, price):
        if operation == "Buy":
            return -int(price)
        elif operation == "Sell":
            return int(price)
        
    # Update 'price' column based on if 'operation' is 'Buy' or 'Sell'
    Stocks['price'] = Stocks.apply(lambda x: helper(x['operation'], x['price']), axis=1)
    
    # Groupby 'stock_name' and sum over 'price' column
    # Rename summed column to 'capital_gain_loss'
    df = Stocks.groupby(by='stock_name')['price'].sum().reset_index(name='capital_gain_loss')
    
    return df