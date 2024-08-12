CREATE PROCEDURE getUserIDs(startDate DATE, endDate DATE, minAmount INT)
BEGIN
	# Write your MySQL query statement below.
	select distinct user_id from Purchases
    where time_stamp between startDate and endDate
    -- 我们这里是不能改成date(time_stamp) between startDate and endDate
    -- 因为题目中说了：To convert the dates to times, both dates should be considered as the start of the day
    and amount >= minAmount
    order by 1;
END