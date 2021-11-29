/* 
    2. Инструкция SELECT, использующая предикат BETWEEN.

    Выборка нажатых кнопок с номера от 3 до 7.
*/

SELECT Number, ButtonColor
FROM ButtonsEvents
WHERE Number BETWEEN 3 AND 7;