/*
    25. Оконные функции для устранения дублей
    Придумать запрос, в результате которого в данных появляются полные дубли.
    Устранить дублирующиеся строки с использованием функции ROW_NUMBER().
    
    Устранение дублирующейся информации о нажатых кнопках.
*/

WITH 
    getDuplicateTable AS
    (
        SELECT *
        FROM ButtonsEvents

        UNION ALL
        
        SELECT *
        FROM ButtonsEvents
    ),

    getNumberedTable AS
    (
        SELECT ROW_NUMBER() OVER(PARTITION BY ID) AS num, *
        FROM getDuplicateTable
    )

SELECT ID, ButtonColor, Number
FROM getNumberedTable
WHERE num=1;