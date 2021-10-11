-- Дроп процедуры.
DROP PROCEDURE IF EXISTS getDbMeta(dbname TEXT);

-- Процедура доступа к метаданным
CREATE OR REPLACE PROCEDURE getDbMeta(dbname TEXT)
AS $$
DECLARE
    dbid INT;
BEGIN
    SELECT pg_database.oid
	FROM pg_database
	WHERE pg_database.datname = dbname
    INTO dbid;
    RAISE NOTICE 'DB: %, ID: %', dbname, dbid;
END;
$$ LANGUAGE PLPGSQL;

CALL getDbMeta('d9h6l2fsgivg2v');