/* 
    12. Инструкция SELECT, использующая вложенные коррелированные
    подзапросы в качестве производных таблиц в предложении FROM.
    
    Выборка цвета кнопки, номера кнопки и описания к данному инциденту.
*/

SELECT be.ButtonColor, be.Number, e.EventDescription
FROM ButtonsEvents be JOIN (SELECT ButtonEvent_ID, EventDescription
							FROM Events) e
							ON be.ID=e.ButtonEvent_ID