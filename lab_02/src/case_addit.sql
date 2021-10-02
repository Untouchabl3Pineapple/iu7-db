/*
    Дополнительное задание на дополнительные баллы
    Создать таблицы:
    • Table1{id: integer, var1: string, valid_from_dttm: date, valid_to_dttm: date}
    • Table2{id: integer, var2: string, valid_from_dttm: date, valid_to_dttm: date}
    Версионность в таблицах непрерывная, разрывов нет (если valid_to_dttm = '2018-09-05', то для следующей строки соответствующего ID valid_from_dttm = '2018-09-06', т.е. на день больше). Для каждого ID дата начала версионности и дата конца версионности в Table1 и Table2 совпадают.
    Выполнить версионное соединение двух талиц по полю id.
*/

-- Создание первой временной таблицы
CREATE TEMP TABLE Table1
(
	id INT,
	var1 TEXT,
	valid_from_dttm DATE,
	valid_to_dttm DATE
)

-- Создание второй временной таблицы
CREATE TEMP TABLE Table2
(
	id INT,
	var2 TEXT,
	valid_from_dttm DATE,
	valid_to_dttm DATE
)

-- Вставка данных в первую таблицу
INSERT INTO Table1 
    (id, var1, valid_from_dttm, valid_to_dttm)
VALUES
    (1, 'A', '2018-09-01', '2018-09-15')
INSERT INTO Table1 
    (id, var1, valid_from_dttm, valid_to_dttm)
VALUES
    (1, 'B', '2018-09-16', '5999-12-31')

-- Вставка данных во вторую таблицу
INSERT INTO Table2
    (id, var2, valid_from_dttm, valid_to_dttm)
VALUES
    (1, 'A', '2018-09-01', '2018-09-18')
INSERT INTO Table2
    (id, var2, valid_from_dttm, valid_to_dttm)
VALUES
    (1, 'B', '2018-09-19', '5999-12-31')

-- ОТВ
WITH
    -- Отсортированная таблица по valid_from_dttm
	sorted_valid_from_dttm AS
	(
		(
			SELECT id, var1, valid_from_dttm
			FROM Table1
			WHERE id = 1

			UNION

			SELECT id, var2, valid_from_dttm
			FROM Table2
			WHERE id = 1
		)
		ORDER BY 3
	),
	
    -- Отсортированная таблица по valid_to_dttm
	sorted_valid_to_dttm AS
	(
		(
			SELECT id, var1 AS var2
				     , valid_to_dttm
			FROM Table1
			WHERE id = 1

			UNION

			SELECT id, var2, valid_to_dttm
			FROM Table2
			WHERE id = 1
		)
		ORDER BY 3
	),

    -- Создание линков для коннекта таблиц
	numbered_sorted_valid_from_dttm AS
	(
		SELECT ROW_NUMBER() OVER() AS numb, *
		FROM sorted_valid_from_dttm
	),
	
    -- Создание линков для коннекта таблиц
	numbered_sorted_valid_to_dttm AS
	(
		SELECT ROW_NUMBER() OVER() AS numb, *
		FROM sorted_valid_to_dttm
	)

-- Основной запрос
SELECT numbered_sorted_valid_from_dttm.id, var1, var2, valid_from_dttm, valid_to_dttm
FROM numbered_sorted_valid_from_dttm, numbered_sorted_valid_to_dttm
WHERE numbered_sorted_valid_from_dttm.numb = numbered_sorted_valid_to_dttm.numb

