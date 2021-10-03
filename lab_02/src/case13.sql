/* 
    13. Инструкция SELECT, использующая вложенные подзапросы с уровнем
    вложенности 3.
    
    Выборка пользователя по России с максимальным эло среди всех.
*/

SELECT users.nickname
FROM users, users_statistics
WHERE users.id = users_statistics.fk_users_id
      AND users_statistics.elo = (SELECT MAX(elo)
                                    FROM users_statistics
                                  WHERE users_statistics.fk_users_id IN (SELECT id
                                                                         FROM users
                                                                         WHERE country = 'ru'))