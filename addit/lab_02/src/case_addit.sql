/*
    Дополнительное задание на дополнительные баллы
    Создать таблицы:
    • Table1{id: integer, var1: string, valid_from_dttm: date, valid_to_dttm: date}
    • Table2{id: integer, var2: string, valid_from_dttm: date, valid_to_dttm: date}
    Версионность в таблицах непрерывная, разрывов нет (если valid_to_dttm = '2018-09-05', то для следующей строки соответствующего ID valid_from_dttm = '2018-09-06', т.е. на день больше). Для каждого ID дата начала версионности и дата конца версионности в Table1 и Table2 совпадают.
    Выполнить версионное соединение двух талиц по полю id.
*/

-- Дроп временных таблиц.
DROP TABLE IF EXISTS table1, table2
;

-- Создание первой временной таблицы.
CREATE TEMP TABLE Table1
(
    id INT,
    var1 TEXT,
    valid_from_dttm DATE,
    valid_to_dttm DATE
)
;

-- Создание второй временной таблицы.
CREATE TEMP TABLE Table2
(
    id INT,
    var2 TEXT,
    valid_from_dttm DATE,
    valid_to_dttm DATE
)
;

-- Вставка данных в первую таблицу.
INSERT INTO Table1 
    (id, var1, valid_from_dttm, valid_to_dttm)
VALUES
      (1, 'A', '2018-09-01', '2018-09-15')
    , (1, 'B', '2018-09-16', '5999-12-31')
    , (2, 'C', '2018-09-01', '2018-09-13')
    , (2, 'D', '2018-09-14', '5999-12-31')
;
 
-- Вставка данных во вторую таблицу.
INSERT INTO Table2
    (id, var2, valid_from_dttm, valid_to_dttm)
VALUES
      (1, 'A', '2018-09-01', '2018-09-18')
    , (1, 'B', '2018-09-19', '5999-12-31')
    , (2, 'Y', '2018-09-01', '2018-09-23')
    , (2, 'J', '2018-09-24', '5999-12-31')
;

-- ОТВ.
WITH
    -- Отсортированная таблица по valid_from_dttm.
    sorted_valid_from_dttm AS
    (
        (
            SELECT id, valid_from_dttm
            FROM Table1
 
            UNION
 
            SELECT id, valid_from_dttm
            FROM Table2
        )
        ORDER BY 1, 2
    ),
    
    -- Отсортированная таблица по valid_to_dttm.
    sorted_valid_to_dttm AS
    (
        (
            SELECT id, valid_to_dttm
            FROM Table1
 
            UNION
 
            SELECT id, valid_to_dttm
            FROM Table2
        )
        ORDER BY 1, 2
    ),
    
    -- Создание линков для коннекта таблиц по атрибутам:
    -- id, valid_from_dttm, valid_to_dttm.
    numbered_sorted_valid_from_dttm AS
    (
        SELECT ROW_NUMBER() OVER() AS numb, *
        FROM sorted_valid_from_dttm
    ),
    numbered_sorted_valid_to_dttm AS
    (
        SELECT ROW_NUMBER() OVER() AS numb, *
        FROM sorted_valid_to_dttm
    ),
    
    -- Таблица с атрибутами: id, valid_from_dttm, valid_to_dttm.
    valid_dttm AS
    (
        SELECT numbered_sorted_valid_from_dttm.numb, numbered_sorted_valid_from_dttm.id, valid_from_dttm, valid_to_dttm
        FROM numbered_sorted_valid_from_dttm, numbered_sorted_valid_to_dttm
        WHERE numbered_sorted_valid_from_dttm.numb = numbered_sorted_valid_to_dttm.numb
    ),
    
    -- Выборка с атрибутом var1.
    get_var1 AS
    (
        SELECT var1
        FROM Table1, valid_dttm
        WHERE Table1.id = valid_dttm.id AND
                valid_dttm.valid_from_dttm >= Table1.valid_from_dttm
                AND valid_dttm.valid_to_dttm <= Table1.valid_to_dttm
    ),
    
    -- Выборка с атрибутом var2.
    get_var2 AS
    (
        SELECT var2
        FROM Table2, valid_dttm
        WHERE Table2.id = valid_dttm.id AND
                valid_dttm.valid_from_dttm >= Table2.valid_from_dttm
                AND valid_dttm.valid_to_dttm <= Table2.valid_to_dttm
    ),
    
    -- Создание линков для коннекта таблиц по атрибутам:
    -- var1, var2.
    numbered_var1 AS
    (
        SELECT ROW_NUMBER() OVER() AS numb, *
        FROM get_var1
    ),
    numbered_var2 AS
    (
        SELECT ROW_NUMBER() OVER() AS numb, *
        FROM get_var2
    )
 
-- Основной запрос.
SELECT id, var1, var2, valid_from_dttm, valid_to_dttm
FROM valid_dttm, numbered_var1, numbered_var2
WHERE valid_dttm.numb = numbered_var1.numb 
      AND valid_dttm.numb = numbered_var2.numb
;