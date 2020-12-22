select tweet_id from Tweets
where length(content) > 15

/*
https://leetcode.com/problems/invalid-tweets/discuss/968440/MySQL%3A-LENGTH()-is-incorrect.-Important-difference-between-CHAR_LENGTH()-vs-LENGTH()

这道题我虽然通过了，但是看到讨论区里面有人再说，这道题其实不能用length来写，因为length其实是计算byte的，但是这道题要计算的是charater的长度，所以不一样

Using LENGTH() is incorrect. The question is asking for the number of characters used in the content. 
LENGTH() returns the length of the string measured in bytes. 
CHAR_LENGTH() returns the length of the string measured in characters.

打个比方，如果对于这道题的要求，如果计算€的长度，那么其实应该返回1，但是这道题如果用length应该返回的是3
SELECT LENGTH('€')  # is equal to 3
SELECT CHAR_LENGTH('€') # is equal to 1


*/