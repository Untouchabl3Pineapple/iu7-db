/* 
    22. Инструкция SELECT, использующая простое обобщенное табличное
    выражение
    
    Обычное ОТВ для вывода сущности EventsTypes.
*/

WITH 
	getEventsTypes AS
	(
		SELECT *
		FROM EventsTypes
	)

SELECT *
FROM getEventsTypes;