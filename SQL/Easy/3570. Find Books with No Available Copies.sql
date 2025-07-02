# Write your MySQL query statement below
with cte as
(select
a.*,
count(distinct record_id) as current_borrowers
from library_books a
join borrowing_records b on a.book_id = b.book_id and b.return_date is null
group by 1,2,3,4,5,6
having total_copies = current_borrowers)

select
book_id,
title,
author,
genre,
publication_year,
current_borrowers
from cte
order by 6 desc, 2

---------------------------

-- Python
import pandas as pd

def find_books_with_no_available_copies(library_books: pd.DataFrame, borrowing_records: pd.DataFrame) -> pd.DataFrame:
    borrowing_records = borrowing_records[borrowing_records['return_date'].isna()]
    merge = pd.merge(library_books,borrowing_records, on = 'book_id')
    merge = merge.groupby(['book_id','title','author','genre','publication_year','total_copies'], as_index = False).record_id.nunique()
    merge = merge[merge['total_copies'] == merge['record_id']]
    return merge[['book_id','title','author','genre','publication_year','total_copies']].rename(columns = {'total_copies':'current_borrowers'}).sort_values(['current_borrowers','title'], ascending = [0,1])