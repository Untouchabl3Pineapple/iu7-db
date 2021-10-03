/* 
    12. Инструкция SELECT, использующая вложенные коррелированные
    подзапросы в качестве производных таблиц в предложении FROM.
    
    Выборка никнеймов пользователей на основе дочерней таблицы.
*/

SELECT u.id, u.nickname
FROM users as u
    JOIN
        (SELECT *
         FROM users_matches_hubs) AS umh
         ON u.id = umh.fk_users_id