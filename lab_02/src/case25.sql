/*
    25. Оконные фнкции для устранения дублей
    Придумать запрос, в результате которого в данных появляются полные дубли.
    Устранить дублирующиеся строки с использованием функции ROW_NUMBER().
    
    Устранение дублирующейся информации о пользователях faceit.
*/

WITH 
    duplicate_table AS
    (
        SELECT *
        FROM users

        UNION ALL
        
        SELECT *
        FROM users
        ORDER BY id
    ),

    numbered_table AS
    (
        SELECT ROW_NUMBER() OVER(PARTITION BY id) AS num, *
        FROM duplicate_table
    )

SELECT id, nickname, country, guid, steam_id
FROM numbered_table
WHERE num = 1
