-- 注意题目中说的：there should be no "holes" between ranks.
-- 也就意味着只能用dense rank了

select 
    Score, 
    dense_rank() over (order by Score desc) as 'Rank' 
    from Scores