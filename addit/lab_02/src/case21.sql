/* 
    21. Инструкция DELETE с вложенным коррелированным подзапросом в
    предложении WHERE.
    
    Просто удаление нажатых красных кнопок (номер 1) из сущности.
*/

DELETE FROM ButtonsEvents
WHERE ButtonColor IN (SELECT ButtonColor
					  FROM ButtonsEvents
					  WHERE ButtonColor=1)