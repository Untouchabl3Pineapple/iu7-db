/* 
    11. Создание новой временной локальной таблицы из результирующего набора
    данных инструкции SELECT.
    
    Создание новой таблицы на основе данных из задания 10.
*/

SELECT nickname,
       CASE
            WHEN lvl < 4 THEN 'Новичок'
            WHEN lvl > 3 AND lvl < 8 THEN 'Бывалый'
            WHEN lvl > 7 THEN 'Нереальный монстр'
       END as lvlClass
INTO TEMP usersClass
FROM users, users_statistics
WHERE users.id = users_statistics.fk_users_id