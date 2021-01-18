UPDATE salary
SET
    sex = CASE sex
        WHEN 'm' THEN 'f'
        ELSE 'm'
    END;



UPDATE salary
SET 
sex = 
CASE WHEN sex = 'm' then 'f' else 'm' end