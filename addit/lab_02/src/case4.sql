/* 
    4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
    
    Выборка нажатых кнопок с красным цветом (номер 1).
*/

SELECT ButtonColor, Number
FROM ButtonsEvents
WHERE ButtonColor IN (SELECT ButtonColor
					  FROM ButtonsEvents
					  WHERE ButtonColor=1);