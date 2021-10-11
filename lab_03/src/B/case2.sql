-- Дроп процедуры.
DROP PROCEDURE IF EXISTS recursion(step INT);

-- Дроп временных таблиц.
DROP TABLE IF EXISTS treasure_hunt, treasure_hunt_res;

-- Создание временной исходной таблицы.
CREATE TEMP TABLE IF NOT EXISTS treasure_hunt (
    id INT PRIMARY KEY, 
    parent_id INT REFERENCES treasure_hunt(id),  
    action varchar(100)
);

-- Вставка данных в таблицу.
INSERT INTO treasure_hunt
    (id, parent_id, action) 
VALUES
    (0, 0, 'Начало пути'),
    (1, 0, 'Взяли лопату'),
    (2, 1, 'Взяли карту'),
    (3, 2, 'Отправились в поход'),
    (4, 3, 'Дошли до места раскопок'),
    (5, 4, 'Раскопали клад'),
    (6, 5, 'А вот и рекурсия подошла к концу 😢');

-- Создание временной результирующей таблицы.
CREATE TEMP TABLE IF NOT EXISTS treasure_hunt_res (  
    action varchar(100)
);

-- Процедура с рекурсивным ОТВ.
CREATE OR REPLACE PROCEDURE recursion(step INT)
AS $$
BEGIN
    WITH RECURSIVE
    rec AS
    (
        SELECT id, parent_id, action
        FROM treasure_hunt
        WHERE parent_id = step

        UNION

        SELECT treasure_hunt.id, treasure_hunt.parent_id, treasure_hunt.action
        FROM treasure_hunt JOIN rec ON treasure_hunt.parent_id = rec.id
    )

    INSERT INTO treasure_hunt_res (action)
        SELECT action
        FROM rec;
END;
$$ LANGUAGE PLPGSQL;

-- Основной запрос.
CALL recursion(0);
