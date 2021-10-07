-- Дроп функции.
DROP FUNCTION IF EXISTS recursion();

-- Дроп временной таблицы.
DROP TABLE IF EXISTS treasure_hunt;

-- Создание временной таблицы.
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

-- Функция с рекурсивным ОТВ.
CREATE OR REPLACE FUNCTION recursion()
RETURNS SETOF treasure_hunt AS $$
BEGIN
    RETURN QUERY
		WITH RECURSIVE
		rec AS
		(
			SELECT id, parent_id, action
			FROM treasure_hunt
			WHERE parent_id = 0

			UNION

			SELECT treasure_hunt.id, treasure_hunt.parent_id, treasure_hunt.action
			FROM treasure_hunt JOIN rec ON treasure_hunt.parent_id = rec.id
		)

		SELECT *
		FROM rec;
END;
$$ LANGUAGE PLPGSQL;

-- Основной запрос.
SELECT *
FROM recursion();

