/* 
    7. Инструкция SELECT, использующая агрегатные функции в выражениях
    столбцов.

    Выборка среднего эло и среднего лвл всех игроков.
*/

SELECT AVG(Cast(elo as Float)) AS EloAVG,
       AVG(Cast(lvl as Float)) AS LvlAVG
FROM users_statistics