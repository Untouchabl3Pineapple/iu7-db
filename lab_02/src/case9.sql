/* 
    9. Инструкция SELECT, использующая простое выражение CASE.
    
    Выборка faceit lvls и составление таблицы lvlText, где текстом пишет название лвла.
*/

SELECT lvl,
       CASE lvl
            WHEN 1 THEN 'Первый'
            WHEN 2 THEN 'Второй'
            WHEN 3 THEN 'Третий'
            WHEN 4 THEN 'Четвертый'
            WHEN 5 THEN 'Пятый'
            WHEN 6 THEN 'Шестой'
            WHEN 7 THEN 'Седьмой'
            WHEN 8 THEN 'Восьмой'
            WHEN 9 THEN 'Девятый'
            WHEN 10 THEN 'Десятый'
       END as lvlText
FROM users_statistics