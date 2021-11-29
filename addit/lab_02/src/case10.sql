/* 
    10. Инструкция SELECT, использующая поисковое выражение CASE.
    
    Перевод номеров цветов кнопок в цвета в виде строки.
*/

SELECT
   CASE
		WHEN ButtonColor=1 THEN 'Красный'
		WHEN ButtonColor=2 THEN 'Желтый'
		WHEN ButtonColor=3 THEN 'Зеленый'
   END as ColorString
FROM ButtonsEvents;