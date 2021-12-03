/*
    Триггер CLR.

    Триггер after insert печатает никнейм юзера, которого добавили в Users.
*/

CREATE OR REPLACE FUNCTION userInsertInform()
RETURNS TRIGGER
AS $$
    plpy.notice(f"The {TD['new']['nickname']} has been added");
$$ LANGUAGE PLPYTHON3U;

-- Создание триггера AFTER.
CREATE TRIGGER userInsert
  AFTER INSERT
  ON users
  FOR EACH ROW
  EXECUTE PROCEDURE userInsertInform();
 
INSERT INTO Users
VALUES
	(2001, 'kekw', 'ru', 'f9990b5d-dcd1-4e3e-88bf-d2132d6f0ac2', 'STEAM_1:0:39149284f9990b5d-dcd1-4e3e-88bf-d2132d6f0ac1');