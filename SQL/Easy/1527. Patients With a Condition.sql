SELECT * FROM PATIENTS 
WHERE CONDITIONS LIKE '% DIAB1%'  --这里注意，前面一定要是有空格，这种是针对ACNE DIAB100的情况，同时保证了没有这样的浑水摸鱼SADIAB100
OR CONDITIONS LIKE 'DIAB1%'  --而这种就是很简单以DIAB1开头的