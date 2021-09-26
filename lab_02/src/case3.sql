/* 
    3. Инструкция SELECT, использующая предикат LIKE.

    Выборка пользователей с маской *hi*.
*/

SELECT *
FROM users
WHERE nickname LIKE '%hi%'