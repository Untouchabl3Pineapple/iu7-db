/* 
    3. Инструкция SELECT, использующая предикат LIKE.

    Выборка типов происшествий с маской *ell*.
*/

SELECT *
FROM EventsTypes
WHERE EventType LIKE '%ell%';