# Write your MySQL query statement below
select
book_id,
title,
author,
published_year
from books
where rating is null
order by 1



-- Python
import pandas as pd

def find_unrated_books(books: pd.DataFrame) -> pd.DataFrame:
    books = books[books['rating'].isna()]
    return books[['book_id','title','author','published_year']].sort_values('book_id')