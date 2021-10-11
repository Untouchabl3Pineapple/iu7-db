-- Дроп процедуры.
DROP PROCEDURE IF EXISTS get_users();

-- Процедура с курсором.
CREATE OR REPLACE PROCEDURE get_users()
AS $$
DECLARE
	unick TEXT;
	nick_cur CURSOR FOR 
		SELECT nickname
		FROM users;
BEGIN
	OPEN nick_cur;
	LOOP
		FETCH nick_cur INTO unick;
		RAISE NOTICE 'User nickname: %', unick;
		EXIT WHEN NOT FOUND;
	END LOOP;
	CLOSE nick_cur;
END;
$$ LANGUAGE PLPGSQL;

-- Основной запрос.
CALL get_users();