/* 
    18. Простая инструкция UPDATE.
    
    Замена типа происшествия по uuid в сущности EventsTypes.
*/

UPDATE EventsTypes
SET EventType='hello'
WHERE ID='2d730fd3-fd18-4653-9f6b-d65b98e77ef7'