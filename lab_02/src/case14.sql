/* 
    14. Инструкция SELECT, консолидирующая данные с помощью предложения
    GROUP BY, но без предложения HAVING.
    
    Выборка айдишников пользователей и количества матчей, которые они сыграли.
*/

SELECT fk_users_id,
       COUNT(fk_matches_id) as numberOfMatches
FROM users_matches_hubs
GROUP BY fk_users_id
ORDER BY fk_users_id