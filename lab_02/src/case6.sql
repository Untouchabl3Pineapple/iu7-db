/* 
    6. Инструкция SELECT, использующая предикат сравнения с квантором.

    Выборка пользователей, у которых faciet elo больше
    максимального faceit elo по подзапросу elo < 2500.
*/

SELECT *
FROM users_statistics
WHERE elo > ALL (SELECT elo
                 FROM users_statistics
                 WHERE elo < 2500)