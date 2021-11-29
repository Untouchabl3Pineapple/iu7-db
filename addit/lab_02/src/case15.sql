/* 
    15. Инструкция SELECT, консолидирующая данные с помощью предложения
    GROUP BY и предложения HAVING.
    
    Выборка статистики нажатых кнопок по цветам, у которых количество нажатых кнопок > 1000.
*/

SELECT ButtonColor, COUNT(*)
FROM ButtonsEvents
GROUP BY ButtonColor
HAVING COUNT(*)>1000;