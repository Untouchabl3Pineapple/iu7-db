/* 
    13. Инструкция SELECT, использующая вложенные подзапросы с уровнем
    вложенности 3.
    
    Выборка описаний инцидентов с номером кнопки = 1;
*/

SELECT e.EventDescription
FROM ButtonsEvents be JOIN Events e ON be.ID=e.ButtonEvent_ID
WHERE e.ButtonEvent_ID IN (SELECT ID
					       FROM ButtonsEvents
						   WHERE ButtonColor IN (SELECT ButtonColor
												 FROM ButtonsEvents
												 WHERE Number=1))