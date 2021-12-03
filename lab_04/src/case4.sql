/*
    Хранимую процедуру CLR.

    Функция обновляет никнейм у пользователя с заданным айди.
*/

CREATE OR REPLACE PROCEDURE updateUserNickname(id INT, nickname VARCHAR(30))
AS $$
    query = plpy.prepare(
            "UPDATE users SET nickname = $2 WHERE users.id = $1;",
            ["INT", "VARCHAR(30)"]
        )

    plpy.execute(query, [id, nickname])
$$ LANGUAGE PLPYTHON3U;

CALL updateUserNickname(7, 'kek');