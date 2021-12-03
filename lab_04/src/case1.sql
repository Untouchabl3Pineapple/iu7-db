/*
    Определяемую пользователем скалярную функцию CLR.

    Функция работает со строками пайтон и конкатенирует
    lvl + elo игрока.
*/

CREATE OR REPLACE FUNCTION getLvlElo(lvl INT, elo INT)
RETURNS TEXT 
AS $$
    return "LVL:"+ str(lvl) + " ELO:" + str(elo)
$$ LANGUAGE PLPYTHON3U;

SELECT getLvlElo(lvl, elo)
FROM users_statistics;