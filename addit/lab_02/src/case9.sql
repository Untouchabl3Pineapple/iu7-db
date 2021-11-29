/* 
    9. Инструкция SELECT, использующая простое выражение CASE.
    
    Выборка кнопок, где пишет номер цвета и его название текстом.
*/

SELECT ButtonColor,
	   CASE ButtonColor
			WHEN 1 THEN 'Красный'
			WHEN 2 THEN 'Желтый'
			WHEN 3 THEN 'Зеленый'
	   END as ColorString
FROM ButtonsEvents;
