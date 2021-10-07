-- Дроп функции.
DROP FUNCTION IF EXISTS getUsersStats();

-- Многооператорная табличная функция для вывода статистики игроков.
CREATE OR REPLACE FUNCTION getUsersStats()
RETURNS TABLE
        (
            user_nickname VARCHAR(30)
            , user_lvl INT
            , user_elo INT
        ) AS $$
BEGIN
    DROP TABLE IF EXISTS usersStats;
    
    CREATE TEMP TABLE usersStats(
            user_nickname VARCHAR(30)
            , user_lvl INT
            , user_elo INT
        );

    INSERT INTO usersStats (user_nickname
                            , user_lvl
                            , user_elo)
    SELECT nickname, lvl, elo
		   		 FROM users, users_statistics
		   		 WHERE users.id = fk_users_id;

    RETURN query SELECT *
		   		 FROM usersStats;
END;
$$ LANGUAGE PLPGSQL;

-- Основной запрос.
SELECT *
FROM getUsersStats();

