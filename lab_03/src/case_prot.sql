-- Реализовать функцию, которая будет возвращать названия 
-- функций, у которых больше number параметров

DROP FUNCTION IF EXISTS getProcs(number INT);

CREATE OR REPLACE FUNCTION getProcs(number INT)
RETURNS TABLE
        (
            proc_name NAME
        ) AS $$
BEGIN
    RETURN query
			SELECT p.proname
			FROM pg_proc p
			WHERE p.pronargs > number;
END;
$$ LANGUAGE PLPGSQL;

SELECT *
FROM getProcs(5)