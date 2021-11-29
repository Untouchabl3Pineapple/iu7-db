/* 
    7. Инструкция SELECT, использующая агрегатные функции в выражениях
    столбцов.

    Выборка максимального, минимального и среднего номеров кнопок.
*/

SELECT MAX(Number), MIN(Number), AVG(Number)::INT
FROM ButtonsEvents;