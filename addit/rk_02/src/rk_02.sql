DROP TABLE IF EXISTS Region, Sanatorium, Vacationer, Sanatorium_Vacationer;

/*
    Создание сущностей
*/

CREATE TABLE IF NOT EXISTS Region
(
    ID                  INT PRIMARY KEY,
    Name                TEXT NOT NULL,
    Description         TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Sanatorium
(
    ID                  INT PRIMARY KEY,
    Name                TEXT NOT NULL,
    Year                DATE NOT NULL,
    Description         TEXT NOT NULL,
    Region_ID           INT NOT NULL REFERENCES Region(ID)
);

CREATE TABLE IF NOT EXISTS Vacationer
(
    ID                  INT PRIMARY KEY,
    FIO                 TEXT NOT NULL,
    Date_b              DATE NOT NULL,
    Adress              TEXT NOT NULL,
    Mail                TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Sanatorium_Vacationer
(
    Sanatorium_ID       INT NOT NULL REFERENCES Sanatorium(ID),
    Vacationer_ID       INT NOT NULL REFERENCES Vacationer(ID)
);

/*
    Заполнение данными
*/

INSERT INTO Region
VALUES
    (1, 'test_regname_1', 'test_desc_1'),
    (2, 'test_regname_2', 'test_desc_2'),
    (3, 'test_regname_3', 'test_desc_3'),
    (4, 'test_regname_4', 'test_desc_4'),
    (5, 'test_regname_5', 'test_desc_5'),
    (6, 'test_regname_6', 'test_desc_6'),
    (7, 'test_regname_7', 'test_desc_7'),
    (8, 'test_regname_8', 'test_desc_8'),
    (9, 'test_regname_9', 'test_desc_9'),
    (10, 'test_regname_10', 'test_desc_10');

INSERT INTO Sanatorium
VALUES
    (1, 'test_sanname_1', CURRENT_DATE + 1, 'test_desc_1', 1),
    (2, 'test_sanname_2', CURRENT_DATE + 2, 'test_desc_2', 2),
    (3, 'test_sanname_3', CURRENT_DATE + 3, 'test_desc_3', 3),
    (4, 'test_sanname_4', CURRENT_DATE + 4, 'test_desc_4', 4),
    (5, 'test_sanname_5', CURRENT_DATE + 5, 'test_desc_5', 5),
    (6, 'test_sanname_6', CURRENT_DATE + 6, 'test_desc_6', 6),
    (7, 'test_sanname_7', CURRENT_DATE + 7, 'test_desc_7', 7),
    (8, 'test_sanname_8', CURRENT_DATE + 8, 'test_desc_8', 8),
    (9, 'test_sanname_9', CURRENT_DATE + 9, 'test_desc_9', 9),
    (10, 'test_sanname_10', CURRENT_DATE + 10, 'test_desc_10', 10);

INSERT INTO Vacationer
VALUES
    (1, 'test_fio_1', CURRENT_DATE + 1, 'test_adress_1', 'test_mail_1'),
    (2, 'test_fio_2', CURRENT_DATE + 2, 'test_adress_2', 'test_mail_2'),
    (3, 'test_fio_3', CURRENT_DATE + 3, 'test_adress_3', 'test_mail_3'),
    (4, 'test_fio_4', CURRENT_DATE + 4, 'test_adress_4', 'test_mail_4'),
    (5, 'test_fio_5', CURRENT_DATE + 5, 'test_adress_5', 'test_mail_5'),
    (6, 'test_fio_6', CURRENT_DATE + 6, 'test_adress_6', 'test_mail_6'),
    (7, 'test_fio_7', CURRENT_DATE + 7, 'test_adress_7', 'test_mail_7'),
    (8, 'test_fio_8', CURRENT_DATE + 8, 'test_adress_8', 'test_mail_8'),
    (9, 'test_fio_9', CURRENT_DATE + 9, 'test_adress_9', 'test_mail_9'),
    (10, 'test_fio_10', CURRENT_DATE + 10, 'test_adress_10', 'test_mail_10');

INSERT INTO Sanatorium_Vacationer
VALUES
    (1, 2),
    (2, 4),
    (1, 7),
    (1, 3),
    (5, 2),
    (6, 2),
    (3, 2),
    (1, 2),
    (1, 8),
    (6, 3);

/*
    Выполнение запросов
*/

/*
    Инструкция SELECT, использующая поисковое выражение CASE.
    Для перевода айдишника в текстовый формат (столбец ToTextForm)
*/
SELECT 
CASE
	WHEN ID=1 THEN '1 ID'
	WHEN ID=2 THEN '2 ID'	
	WHEN ID=3 THEN '3 ID'	
	WHEN ID=4 THEN '4 ID'	
	WHEN ID=5 THEN '5 ID'	
	WHEN ID=6 THEN '6 ID'	
	WHEN ID=7 THEN '7 ID'	
	WHEN ID=8 THEN '8 ID'	
	WHEN ID=9 THEN '9 ID'	
	WHEN ID=10 THEN '10 ID'
	ELSE 'WTF'
END as ToTextForm
FROM Region;

/*
    Инструкция UPDATE со скалярным подзапросом в предложении SET.
    Для изменения имени региона, у которого ID=1, на имя региона,
    у которого ID=3
*/
UPDATE Region
SET Name=(SELECT Name
		  FROM Region
		  WHERE ID=3)
WHERE ID=1;

/*
    Инструкция SELECT, консолидирующая данные с помощью предложения
    GROUP BY и предложения HAVING.
    Довально бессмысленная группировка по айдишнику с максимальной датой год
    и фильтровка с помощью сравнения с текущей датой (все записи выведутся, потому
    что они на день больше, это можно увидеть по инсертам)
    
*/
SELECT MAX(Year)
FROM Sanatorium
GROUP BY ID
HAVING MAX(Year) > CURRENT_DATE;


-- Дроп процедуры
DROP PROCEDURE IF EXISTS drop_views();

-- Хранимая процедура с выходным параметром - количество удаленных представлений
CREATE OR REPLACE PROCEDURE drop_views()
AS $$
BEGIN
	-- Вывод всех команд дропа таблиц public
	SELECT 'DROP VIEW ' || table_name || ';'
    FROM information_schema.views
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema') AND table_name !~ '^pg_';
	-- Не успел дописать логику для EXECUTE всех команд из вывода сверху
	
	-- Вывод количество удаленных представлений
    RAISE NOTICE 'Number of deleted: %',
	(SELECT COUNT(*)
	FROM information_schema.views
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
	AND table_name !~ '^pg_');
END;
$$ LANGUAGE PLPGSQL;

-- Вызов процедуры
CALL drop_views();

