/* 
    4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
    
    Выборка никнеймов пользователей с faceit lvl = 10.
*/

SELECT nickname
FROM users
WHERE id IN (SELECT fk_users_id
             FROM users_statistics
             WHERE lvl = 10)