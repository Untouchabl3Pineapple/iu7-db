/* 
    21. Инструкция DELETE с вложенным коррелированным подзапросом в
    предложении WHERE.
    
    Удаление пользователей из сущности users, у которых faceit lvl = 5.
*/

DELETE FROM users as u
WHERE nickname IN (SELECT nickname
                   FROM users_statistics as us
                   WHERE u.id = us.fk_users_id 
                   AND us.lvl = 5)