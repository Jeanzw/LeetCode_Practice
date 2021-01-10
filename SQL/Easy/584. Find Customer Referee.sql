-- 两种做法，一种是直接如下使得referee_id 不等于2或者为null
-- 另一种做法就是抽出为2的，然后再抽出name，使得referee_id不在这之列就好了
select name from customer where referee_id != 2 or referee_id is null