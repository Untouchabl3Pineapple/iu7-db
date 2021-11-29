/* 
    6. Инструкция SELECT, использующая предикат сравнения с квантором.

    Выборка нажатых кнопок, если есть хоть одна кнопка с желтым цветов
    (номер 2).
*/

SELECT *
FROM ButtonsEvents
WHERE ID=ANY(SELECT ID
		  	 FROM ButtonsEvents
		  	 WHERE ButtonColor=2);