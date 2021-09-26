/* 
    5. Инструкция SELECT, использующая предикат EXISTS с вложенным
    подзапросом.

    Выборка всех пользователей, если в таблице users_statistics
    есть хотя бы один пользователь с faceit lvl = 10.
*/

SELECT *
FROM users
WHERE EXISTS (SELECT lvl
              FROM users_statistics
              WHERE lvl = 10)