/* 
    11. Создание новой временной локальной таблицы из результирующего набора
    данных инструкции SELECT.
    
    Создание новой временной таблицы на основе данных из задания 10.
*/

SELECT
   CASE
		WHEN ButtonColor=1 THEN 'Красный'
		WHEN ButtonColor=2 THEN 'Желтый'
		WHEN ButtonColor=3 THEN 'Зеленый'
   END as ColorString
INTO TEMP TempTable
FROM ButtonsEvents;