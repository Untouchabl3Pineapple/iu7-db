/* 
    10. Инструкция SELECT, использующая поисковое выражение CASE.
    
    Классификация игроков по их уровню игры :).
*/

SELECT nickname,
       CASE
            WHEN lvl < 4 THEN 'Новичок'
            WHEN lvl > 3 AND lvl < 8 THEN 'Бывалый'
            WHEN lvl > 7 THEN 'Нереальный монстр'
       END as lvlClass
FROM users, users_statistics
WHERE users.id = users_statistics.fk_users_id