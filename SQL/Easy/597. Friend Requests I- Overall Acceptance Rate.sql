

select
ifnull(round((count(distinct requester_id,accepter_id)
              /
              count(distinct sender_id,send_to_id)),2),0) as accept_rate from request_accepted,friend_request



-- 比较简洁的做法：
with accept as
(select count(distinct requester_id,accepter_id) as accept from request_accepted
)
,request as 
(select count(distinct sender_id,send_to_id) as request from friend_request
)

select ifnull(round(accept/request,2),0.00)as accept_rate from accept,request



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