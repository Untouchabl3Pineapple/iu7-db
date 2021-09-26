/* 
    15. Инструкция SELECT, консолидирующая данные с помощью предложения
    GROUP BY и предложения HAVING.
    
    Выборка наиболее популярных режимов в хабах по европейскому региону, которые играются в более чем 10 хабах.
*/

SELECT game_mode,
       COUNT(*) as numberOfHubs
FROM hubs
WHERE region = 'EU'
GROUP BY game_mode
HAVING COUNT(*) > 10
ORDER BY numberOfHubs