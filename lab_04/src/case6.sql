/*
    Определяемый пользователем тип данных CLR.

    Просто получаем лвл и эло игрока.
*/

DROP FUNCTION IF EXISTS getLvlElo(lvl INT, elo INT);
DROP TYPE IF EXISTS temptype;

CREATE TYPE temptype AS (
    lvl    INT,
    elo    INT
);

CREATE OR REPLACE FUNCTION getLvlElo(lvl INT, elo INT)
RETURNS SETOF temptype
AS $$
    return ([lvl, elo],)
$$ LANGUAGE PLPYTHON3U;

SELECT *
FROM getLvlElo(9, 2001);