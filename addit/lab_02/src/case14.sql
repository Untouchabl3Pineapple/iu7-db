/* 
    14. Инструкция SELECT, консолидирующая данные с помощью предложения
    GROUP BY, но без предложения HAVING.
    
    Выборка статистики нажатых кнопок по цветам.
*/

SELECT ButtonColor, COUNT(Number)
FROM ButtonsEvents
GROUP BY ButtonColor;