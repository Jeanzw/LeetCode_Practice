WITH RECURSIVE Chain AS (
    -- 初始链路：从任意 giver_id 开始
    SELECT
        giver_id AS start_id,
        giver_id,
        receiver_id,
        gift_value,
        CONCAT(giver_id) AS chain_path, -- 跟踪链路路径
        1 AS chain_length,
        gift_value AS total_value
    FROM SecretSanta
    UNION ALL
    -- 递归部分：寻找链路的下一个 receiver_id
    SELECT
        Chain.start_id,
        s.giver_id,
        s.receiver_id,
        s.gift_value,
        CONCAT(Chain.chain_path, '->', s.giver_id) AS chain_path,
        Chain.chain_length + 1 AS chain_length,
        Chain.total_value + s.gift_value AS total_value
    FROM Chain
    JOIN SecretSanta s
      ON Chain.receiver_id = s.giver_id
    WHERE s.giver_id != Chain.start_id -- 避免直接回到起点
      AND NOT FIND_IN_SET(s.giver_id, Chain.chain_path) -- 避免重复访问
)

-- 找到循环链路
,CircularChains AS (
    SELECT
        start_id,
        MIN(giver_id) AS chain_id, -- 使用最小的 giver_id 作为链路标识
        chain_length,
        total_value
    FROM Chain
    WHERE receiver_id = start_id -- 确保形成循环
    GROUP BY start_id, chain_length, total_value
)
, smallest_chain as
-- 找到独一无二的链条
(select distinct chain_length, total_value from CircularChains)

-- 按要求返回结果
SELECT
    DENSE_RANK() OVER (ORDER BY chain_length desc, total_value desc) AS chain_id, -- 为每个链路分配唯一 ID
    chain_length,
    total_value as total_gift_value
FROM smallest_chain
ORDER BY chain_length DESC, total_value DESC;
