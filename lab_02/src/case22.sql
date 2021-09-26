/* 
    22. Инструкция SELECT, использующая простое обобщенное табличное
    выражение
    
    Получение информации о пользователях через псевдоним informAboutUsers.
*/

WITH informAboutUsers AS 
    (SELECT *
    FROM users)

SELECT *
FROM informAboutUsers
