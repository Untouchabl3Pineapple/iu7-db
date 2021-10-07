-- Дроп функции.
DROP FUNCTION IF EXISTS getLvlElo(lvl INT, elo INT);

-- Скалярная функция для вывода статистики игроков текстом.
CREATE OR REPLACE FUNCTION getLvlElo(lvl INT, elo INT)
RETURNS TEXT AS $$
BEGIN
    RETURN FORMAT('Lvl: %s, Elo: %s', lvl, elo);
END;
$$ LANGUAGE PLPGSQL;

-- Основной запрос
SELECT nickname
	   , getLvlElo(lvl, elo)
FROM users_statistics
	JOIN users ON users.id = fk_users_id;