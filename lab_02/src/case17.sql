/* 
    17. Многострочная инструкция INSERT, выполняющая вставку в таблицу
    результирующего набора данных вложенного подзапроса.
    
    Создание временной таблицы и вставка туда пользователей с 10 lvl faceit.
*/


FROM users, users_statistics
WHERE users.id = users_statistics.fk_users_id
AND users_statistics.lvl = 10

-- Создание временной таблицы
CREATE TEMP TABLE users_lvls
(
    nickname VARCHAR(30) UNIQUE NOT NULL,
    lvl INT NOT NULL
)

-- Вставка данных в таблицу
INSERT INTO users_lvls (nickname, lvl)
SELECT users.nickname, (SELECT MAX(lvl)
                          FROM users_statistics)
FROM users;