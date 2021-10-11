-- Дроп процедуры
DROP PROCEDURE IF EXISTS change_nickname(uid INT, unickname VARCHAR(30));

-- Хранимая процедура с параметрами
CREATE OR REPLACE PROCEDURE change_nickname(uid INT, unickname VARCHAR(30))
AS $$
BEGIN
	UPDATE users
    SET
        nickname = unickname
	WHERE users.id = uid;
END;
$$ LANGUAGE PLPGSQL;

-- Вызов процедуры
CALL change_nickname(1, 'TestName');