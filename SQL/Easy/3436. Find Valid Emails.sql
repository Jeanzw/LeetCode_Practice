select * from Users 
where email REGEXP '^[A-Za-z0-9_]+@[A-za-z]+.com';

----------------

-- Python
import pandas as pd

def find_valid_emails(users: pd.DataFrame) -> pd.DataFrame:
    users = users.sort_values(by = 'user_id', ascending = True)
    result = users[users['email'].str.contains(r'^[a-zA-Z0-9_]+@[a-zA-Z]+\.com
```)]
    # ^[a-zA-Z0-9_]+: This part ensures the email starts with alphanumeric characters or underscores.
    # @: There should be exactly one @ symbol.
    # ([a-zA-Z]+): After the @ symbol, we ensure only alphabetic characters are allowed in the domain part.
    # \.com$: Ensures the email ends with .com.
    return result