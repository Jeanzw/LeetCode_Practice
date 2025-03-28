select
ifnull(round((count(distinct requester_id,accepter_id)
              /
              count(distinct sender_id,send_to_id)),2),0) as accept_rate from request_accepted,friend_request

------------------------

-- 比较简洁的做法：
with accept as
(select count(distinct requester_id,accepter_id) as accept from request_accepted
)
,request as 
(select count(distinct sender_id,send_to_id) as request from friend_request
)

select ifnull(round(accept/request,2),0.00)as accept_rate from accept,request

------------------------

-- 其实更加准确的做法是这样的：
-- 就直接在分子分母的时候带入原表
select
round(
    ifnull(
    (select count(*) from (select distinct requester_id, accepter_id from request_accepted) as A)
    /
    (select count(*) from (select distinct sender_id, send_to_id from friend_request) as B),
    0)
, 2) as accept_rate;

------------------------

-- 也可以直接改成
select
round(
    ifnull(
    (select count(distinct requester_id, accepter_id) from RequestAccepted)
    /
    (select count(distinct sender_id, send_to_id) from FriendRequest),
    0)
, 2) as accept_rate

-- ifnull和round谁在前谁在后没有影响

------------------------

-- Python
import pandas as pd

def acceptance_rate(friend_request: pd.DataFrame, request_accepted: pd.DataFrame) -> pd.DataFrame:
    friend_request = len(friend_request[['sender_id','send_to_id']].drop_duplicates())
    request_accepted = len(request_accepted[['requester_id','accepter_id']].drop_duplicates())
    if friend_request == 0:
        accept_rate = 0
    else:
        accept_rate = round(request_accepted/friend_request,2)
    return pd.DataFrame({'accept_rate':[accept_rate]})