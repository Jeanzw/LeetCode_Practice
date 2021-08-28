-- 仅用于ms sql
-- Here first LIKE checks that the mail starts with letter and ends with @leetcode.com, 
-- the second LIKE checks that the first part of the mail does not contain any symbol except allowed.

-- NOT LIKE '%[^0-9a-zA-Z_.-]%' -> means that the string does not contain any character except [0-9a-zA-Z_.-]
-- LIKE '%[0-9a-zA-Z_.-]%' -> means that the string contains at least one character from [0-9a-zA-Z_.-]

SELECT
    user_id,
    name,
    mail
FROM Users
WHERE mail LIKE '[a-zA-Z]%@leetcode.com' 
AND LEFT(mail, LEN(mail) - 13) NOT LIKE '%[^0-9a-zA-Z_.-]%'