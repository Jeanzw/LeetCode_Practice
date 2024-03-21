CREATE PROCEDURE UnpivotProducts()
BEGIN
	# Write your MySQL query statement below.
    set session group_concat_max_len = 1000000;
    
    set @macro = null;
    
	select group_concat(
        concat(
            'select product_id, "', `column_name`, '" as store, ', `column_name`,
            ' as price from products where ', `column_name`, ' is not null'
        ) separator ' union '
    )
        into @macro
        from `information_schema`.`columns`
        where `table_schema`='test' and `table_name`='products' and `column_name` != 'product_id';
    
    prepare sql_query from @macro;
    execute sql_query;
    deallocate prepare sql_query;
END