/* 
    2. Инструкция SELECT, использующая предикат BETWEEN.

    Выборка пользователей с faceit lvl = 5, 6, 7.
*/

SELECT *
FROM users, users_statistics
WHERE users.id = users_statistics.fk_users_id
                 AND lvl BETWEEN 5 AND 7