/*
    8. Инструкция SELECT, использующая скалярные подзапросы в выражениях
    столбцов.

    Выборка пользователей с faceit elo большем, чем среднее эло всех игроков.
*/

SELECT nickname, elo 
FROM users, users_statistics
WHERE users.id = users_statistics.fk_users_id 
      AND elo > (SELECT AVG(elo)
             FROM users_statistics)

