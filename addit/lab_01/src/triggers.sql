--------------------------------------------------------------------------------

-- Удаление триггера T1
DROP TRIGGER IF EXISTS T1 ON ButtonsEvents;

-- Удаление функции InsertInEvents()
DROP FUNCTION IF EXISTS InsertInEvents();

-- Создание функции InsertInEvents()
CREATE OR REPLACE FUNCTION InsertInEvents()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.buttoncolor = 1 THEN
        INSERT INTO Events (ID, ButtonEvent_ID)
        VALUES             (gen_random_uuid(), NEW.ID);
    END IF;
	
	IF NEW.buttoncolor = 2 THEN
		UPDATE Events
        SET fixingtime=CURRENT_TIMESTAMP
		WHERE ButtonEvent_ID=(SELECT be.id
                              FROM buttonsevents be JOIN events e ON e.buttonevent_id=be.id
                              WHERE be.number=NEW.number
                              ORDER BY detectingtime DESC LIMIT 1);
	END IF;

    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

/*
    Создание триггера T1, который реагирует на нажатие кнопки
    и заносит информацию в Events
*/
CREATE TRIGGER T1
AFTER INSERT ON ButtonsEvents FOR EACH ROW
EXECUTE PROCEDURE InsertInEvents();

--- ! TESTS ! ---

INSERT INTO ButtonsEvents(ID, ButtonColor, Number)
VALUES (gen_random_uuid(), 1, 9);

--------------------------------------------------------------------------------

-- Удаление триггера T2
DROP TRIGGER IF EXISTS T2 ON ButtonsEvents;

-- Удаление функции UpdateButtonColor()
DROP FUNCTION IF EXISTS UpdateButtonColor();

-- Создание функции UpdateButtonColor()
CREATE OR REPLACE FUNCTION UpdateButtonColor()
RETURNS TRIGGER
AS $$
BEGIN
    UPDATE ButtonsPosts
    SET LeftColor = NEW.ButtonColor
    WHERE LeftSide = NEW.Number;

    UPDATE ButtonsPosts
    SET RightColor = NEW.ButtonColor
    WHERE RightSide = NEW.Number;

    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

/*
    Создание триггера T2, который реагирует на нажатие кнопки
    и изменяет цвет блоков на табло (сущность ButtonsPosts)
*/
CREATE TRIGGER T2
AFTER INSERT ON ButtonsEvents FOR EACH ROW
EXECUTE PROCEDURE UpdateButtonColor();

--- ! TESTS ! ---

-- Инициализация ButtonsPosts
INSERT INTO ButtonsPosts(Post, LeftSide, RightSide, LeftColor, RightColor)
SELECT i, i, i + 1, 2, 2
FROM generate_series(0, 13) i;

INSERT INTO ButtonsEvents(ID, ButtonColor, Number)
VALUES (gen_random_uuid(), 1, 9);

--------------------------------------------------------------------------------

