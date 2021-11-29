/* 
    24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
    
    Вывод всех записей с тремя доп атрибутами (тремя оконными функциями).
*/

SELECT *,
	   MIN(Number) OVER(PARTITION BY ButtonColor),
	   MAX(Number) OVER(PARTITION BY ButtonColor),
	   AVG(Number) OVER(PARTITION BY ButtonColor)::INT
FROM ButtonsEvents;