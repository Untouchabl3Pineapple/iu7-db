-- Удаление триггера.
DROP TRIGGER IF EXISTS userInsert on users_view;

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

-- Создание представления.
CREATE OR REPLACE VIEW
users_view AS
SELECT * 
FROM users;

-- Создание триггера INSTEAD OF.
CREATE TRIGGER userInsert
  INSTEAD OF INSERT
  ON users_view
  FOR EACH ROW
  EXECUTE PROCEDURE userInsertInform();

-- Инсерт.
INSERT INTO users_view
SELECT *
FROM users;