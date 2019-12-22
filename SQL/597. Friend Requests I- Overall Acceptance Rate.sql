/*虽然题目中说不需要用到friend_request这一张表，但是实际上还是需要的*/
select
ifnull(round((count(distinct requester_id,accepter_id)
              /
              count(distinct sender_id,send_to_id)),2),0) as accept_rate from request_accepted,friend_request