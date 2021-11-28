DROP TABLE IF EXISTS Types_sweets, Retail_outlets, Suppliers, Types_sweets_Retail_outlets, Retail_outlets_Suppliers, Suppliers_Types_sweets;

/*
    Создание сущностей
*/

CREATE TABLE IF NOT EXISTS Types_sweets
(
    ID                  INT PRIMARY KEY,
    Name                TEXT NOT NULL,
    Composition         TEXT NOT NULL,
    Description         TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Retail_outlets
(
    ID                  INT PRIMARY KEY,
    Name                TEXT NOT NULL,
    Adress              TEXT NOT NULL,
    Reg_date            DATE NOT NULL,
    Rating              INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Suppliers
(
    ID                  INT PRIMARY KEY,
    Name                TEXT NOT NULL,
    INN                 INT NOT NULL,
    Adress              TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Types_sweets_Retail_outlets
(
    Types_sweets_ID       INT NOT NULL REFERENCES Types_sweets(ID),
    Retail_outlets_ID     INT NOT NULL REFERENCES Retail_outlets(ID)
);

CREATE TABLE IF NOT EXISTS Retail_outlets_Suppliers
(
    Retail_outlets_ID     INT NOT NULL REFERENCES Retail_outlets(ID),
    Suppliers_ID          INT NOT NULL REFERENCES Suppliers(ID)
);

CREATE TABLE IF NOT EXISTS Suppliers_Types_sweets
(
    Suppliers_ID          INT NOT NULL REFERENCES Suppliers(ID),
    Types_sweets_ID       INT NOT NULL REFERENCES Types_sweets(ID)
);

/*
    Заполнение данными
*/

INSERT INTO Types_sweets
VALUES
    (1, 'test_sweetname_1', 'test_compos_1', 'test_desc_1'),
    (2, 'test_sweetname_2', 'test_compos_2', 'test_desc_2'),
    (3, 'test_sweetname_3', 'test_compos_3', 'test_desc_3'),
    (4, 'test_sweetname_4', 'test_compos_4', 'test_desc_4'),
    (5, 'test_sweetname_5', 'test_compos_5', 'test_desc_5'),
    (6, 'test_sweetname_6', 'test_compos_6', 'test_desc_6'),
    (7, 'test_sweetname_7', 'test_compos_7', 'test_desc_7'),
    (8, 'test_sweetname_8', 'test_compos_8', 'test_desc_8'),
    (9, 'test_sweetname_9', 'test_compos_9', 'test_desc_9'),
    (10, 'test_sweetname_10', 'test_compos_10', 'test_desc_10');

INSERT INTO Retail_outlets
VALUES
    (1, 'test_retailname_1', 'test_adress_1', CURRENT_DATE + 1, 1),
    (2, 'test_retailname_2', 'test_adress_2', CURRENT_DATE + 2, 2),
    (3, 'test_retailname_3', 'test_adress_3', CURRENT_DATE + 3, 3),
    (4, 'test_retailname_4', 'test_adress_4', CURRENT_DATE + 4, 4),
    (5, 'test_retailname_5', 'test_adress_5', CURRENT_DATE + 5, 5),
    (6, 'test_retailname_6', 'test_adress_6', CURRENT_DATE + 6, 6),
    (7, 'test_retailname_7', 'test_adress_7', CURRENT_DATE + 7, 7),
    (8, 'test_retailname_8', 'test_adress_8', CURRENT_DATE + 8, 8),
    (9, 'test_retailname_9', 'test_adress_9', CURRENT_DATE + 9, 9),
    (10, 'test_retailname_10', 'test_adress_10', CURRENT_DATE + 10, 10);

INSERT INTO Suppliers
VALUES
    (1, 'test_suppliername_1', 12341, 'test_adress_1'),
    (2, 'test_suppliername_2', 12342, 'test_adress_2'),
    (3, 'test_suppliername_3', 12343, 'test_adress_3'),
    (4, 'test_suppliername_4', 12344, 'test_adress_4'),
    (5, 'test_suppliername_5', 12345, 'test_adress_5'),
    (6, 'test_suppliername_6', 12346, 'test_adress_6'),
    (7, 'test_suppliername_7', 12347, 'test_adress_7'),
    (8, 'test_suppliername_8', 12348, 'test_adress_8'),
    (9, 'test_suppliername_9', 12349, 'test_adress_9'),
    (10, 'test_suppliername_10', 12350, 'test_adress_10');

INSERT INTO Types_sweets_Retail_outlets
VALUES
    (1, 2),
    (2, 4),
    (1, 3),
    (1, 3),
    (5, 7),
    (6, 2),
    (3, 2),
    (4, 2),
    (1, 8),
    (2, 3);

INSERT INTO Retail_outlets_Suppliers
VALUES
    (1, 2),
    (2, 4),
    (1, 3),
    (1, 3),
    (5, 7),
    (6, 2),
    (3, 2),
    (4, 2),
    (1, 8),
    (2, 3);

INSERT INTO Suppliers_Types_sweets
VALUES
    (1, 2),
    (2, 4),
    (1, 3),
    (1, 3),
    (5, 7),
    (6, 2),
    (3, 2),
    (4, 2),
    (1, 8),
    (2, 3);

/*
    Выполнение запросов
*/

/*
    Инструкция SELECT, использующая предикат сравнения.
    Использую предикат сравнения для фильтрации даты регистрации
    если дата рега больше текущей даты, то вывожу (выведятся все записи,
    так как они начинаются только с завтрашнего дня)
*/

SELECT *
FROM Retail_outlets
WHERE Reg_date > CURRENT_DATE;

/*
    Инструкция, использующая оконную функцию.
    Инструкция роу намбер, которая пронумерует
    количество одинаковых записей (ну посчитает по полю
    reg_date) везде будут 1, так как у нас уникальные значения даты.
    Эти данные можно использовать для дальнейшей фильтрации :)
*/

SELECT ROW_NUMBER() OVER(PARTITION BY reg_date), *
FROM Retail_outlets;

/*
    Инструкция, SELECT, использующая вложенные коррелированные подзапросы
    в качетсве производных таблиц в предложении FROM.
    Сделал такой не оч полезные запрос, но для наглядности пойдет.
    Вывожу название и дату регистрации торговой точки по вложенному запросу
    айди которой равен единице.
*/

SELECT Name, Reg_date
FROM (SELECT *
	  FROM Retail_outlets
	  WHERE ID=1) que;


-- Дроп процедуры
DROP PROCEDURE IF EXISTS print_procs_funcs(string TEXT);
-- Дроп временной таблицы
DROP TABLE IF EXISTS Temp_out;

-- Создание временной таблицы для вывода
CREATE TEMP TABLE IF NOT EXISTS Temp_out
(
	rout_type TEXT NOT NULL,
	rout_name Name NOT NULL
);

-- Хранимая процедура
CREATE OR REPLACE PROCEDURE print_procs_funcs(string TEXT)
AS $$
BEGIN
	INSERT INTO Temp_out
	(SELECT routine_name, routine_type 
    FROM information_schema.routines
    WHERE specific_schema='public' AND routine_definition LIKE concat('%', string, '%'));
END;
$$ LANGUAGE PLPGSQL;

-- Вызов процедуры
CALL print_procs_funcs('Lvl');

-- Вывод содержимого
SELECT *
FROM Temp_out;