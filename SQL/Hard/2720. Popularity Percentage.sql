with summary as
(select user1 as user, user2 as friend from Friends
union
select user2 as user, user1 as friend from Friends
)
, total as
(select count(distinct user) as tt from summary)

select 
user as user1, round(100 * count(distinct friend)/(select tt from total),2) as percentage_popularity
from summary
group by 1
order by 1

-- 也可以用window function来做
with summary as
(select user1 as user, user2 as friend from Friends
union
select user2 as user, user1 as friend from Friends
)
select 
user as user1, round(100 * count(distinct friend)/count(user) over (),2) as percentage_popularity
from summary
group by 1
order by 1



-- Python
import pandas as pd

def popularity_percentage(friends: pd.DataFrame) -> pd.DataFrame:
    # Expand friendships in both directions
    expanded_friends = pd.concat(
        [
            friends.rename(columns={'user1': 'primary_user', 'user2': 'friend_user'}),
            friends.rename(columns={'user1': 'friend_user', 'user2': 'primary_user'}),
        ]
    )

    # Count the number of unique friends for each user
    friend_count = expanded_friends.groupby('primary_user')['friend_user'].nunique()

    # Calculate the total number of users
    total_users = expanded_friends['primary_user'].nunique()

    # Calculate the popularity percentage
    popularity_percentage = 100 * friend_count / total_users

    # Create the result DataFrame
    result = pd.DataFrame(
        {
            'user1': popularity_percentage.index,
            'percentage_popularity': popularity_percentage.values.round(2),
        }
    ).reset_index(drop=True)

    return result
