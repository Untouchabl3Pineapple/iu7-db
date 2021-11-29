/* 
    23. Инструкция SELECT, использующая рекурсивное обобщенное табличное
    выражение.
    
    Получение алгоритма действий при поиске клада с помощью ОТВ.
*/

-- Рекурсивное ОТВ
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

SELECT * FROM rec;

-- Создание временной таблицы
CREATE TEMP TABLE treasure_hunt (
    id INT PRIMARY KEY, 
    parent_id INT REFERENCES treasure_hunt(id),  
    action varchar(100)
);

-- Заполнение таблицы
INSERT INTO treasure_hunt
    (id, parent_id, action) 
VALUES
    (0, 0, 'Начало пути'),
    (1, 0, 'Взяли лопату'),
    (2, 1, 'Взяли карту'),
    (3, 2, 'Отправились в поход'),
    (4, 3, 'Дошли до места раскопок'),
    (5, 4, 'Раскопали клад');
