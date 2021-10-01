/* 
    24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
    
    Получение информации о самых перспективных игроках на каждом лвле faceit.
*/

SELECT id, nickname, lvl, elo
FROM (
      SELECT id,
             nickname,
             lvl,
             elo,
             MAX(elo) OVER (PARTITION BY lvl) as max_elo
      FROM users, users_statistics
      WHERE users.id = users_statistics.fk_users_id
     ) as t
WHERE elo = max_elo
ORDER BY lvl