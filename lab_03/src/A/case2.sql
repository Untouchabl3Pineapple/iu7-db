-- Дроп функции.
DROP FUNCTION IF EXISTS getUsersStats();

-- Подставляемая табличная функция для вывода статистики игроков.
CREATE OR REPLACE FUNCTION getUsersStats()
RETURNS TABLE
        (
            user_nickname VARCHAR(30)
            , user_lvl INT
            , user_elo INT
        ) AS $$
BEGIN
    RETURN query SELECT nickname, lvl, elo
		   		 FROM users, users_statistics
		   		 WHERE users.id = fk_users_id;
END;
$$ LANGUAGE PLPGSQL;

-- Основной запрос.
SELECT *
FROM getUsersStats();
