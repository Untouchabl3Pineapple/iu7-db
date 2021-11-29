/* 
    5. Инструкция SELECT, использующая предикат EXISTS с вложенным
    подзапросом.

    Выборка всех кнопок, если в сущности ButtonsEvents
    есть хоть одна нажатая кнопка с красным цветом (номер 1).
*/

SELECT ButtonColor, Number
FROM ButtonsEvents
WHERE EXISTS (SELECT ButtonColor
			  FROM ButtonsEvents
			  WHERE ButtonColor=1);