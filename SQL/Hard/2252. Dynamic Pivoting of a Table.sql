CREATE PROCEDURE PivotProducts()
BEGIN
  SET GROUP_CONCAT_MAX_LEN = 1000000;
  SELECT
    GROUP_CONCAT(CONCAT('SUM(IF(store = \'', store, '\', price, NULL)) AS ', store) ORDER BY store ASC)
  INTO
    @sql
  FROM
    (SELECT DISTINCT store FROM Products) AS S;
  
  SET @sql = CONCAT('SELECT product_id, ', @sql, ' FROM Products GROUP BY product_id');
  
  PREPARE statement FROM @sql;
  EXECUTE statement;
  DEALLOCATE PREPARE statement;
END