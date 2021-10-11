-- Удаление триггера.
DROP TRIGGER IF EXISTS userInsert on users;

-- Удаление функции.
DROP FUNCTION IF EXISTS userInsertInform();

-- Создание функции.
CREATE OR REPLACE FUNCTION userInsertInform()
RETURNS trigger
AS $$
BEGIN
    RAISE NOTICE 'The user has been added';

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

-- Создание триггера AFTER.
CREATE TRIGGER userInsert
  AFTER INSERT
  ON users
  FOR EACH ROW
  EXECUTE PROCEDURE userInsertInform();