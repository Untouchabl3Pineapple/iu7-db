/*
    8. Инструкция SELECT, использующая скалярные подзапросы в выражениях
    столбцов.

    Выборка кнопок с дополнительным атрибутом, показывающим средний номер кнопки
    по текущему цвету. 
*/

SELECT *, (SELECT AVG(Number)::INT
		   FROM ButtonsEvents
		   WHERE ButtonColor=be.ButtonColor)
FROM ButtonsEvents be

