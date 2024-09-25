-- 其实我们可以这么想，就是把相同email的id较大的给抽出来
-- 然后直接把select换成delete

DELETE p1 FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id


delete p2  --delete 是必须把整行给全部删除的，而不能够仅仅删除几列
from Person p1
left join Person p2 on p1.Email = p2.Email and p1.Id < p2.Id


-- 用python
import pandas as pd

def delete_duplicate_emails(person: pd.DataFrame) -> None:
    person.sort_values(by='id', inplace=True)
    person.drop_duplicates(subset='email', keep='first', inplace=True)