/*
    2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
    Созданная таблица после всех манипуляций должна соответствовать таблице базы данных,
    созданной в первой лабораторной работе.

    3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON,
    или добавить атрибут с типом XML или JSON к уже существующей таблице.
    Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE.
*/

DROP TABLE IF EXISTS UsersFromJson;

CREATE TEMP TABLE IF NOT EXISTS UsersFromJson
(
    id INT PRIMARY KEY,
    nickname VARCHAR(30) UNIQUE NOT NULL,
    country VARCHAR(20) NOT NULL,
    guid VARCHAR(200) UNIQUE NOT NULL,
    steam_id VARCHAR(100) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS temp;

CREATE TEMP TABLE IF NOT EXISTS temp
(
    data JSONB
);

\copy temp(data) FROM 'datasets/users.json';

INSERT INTO UsersFromJson (id, nickname, country, guid, steam_id)
SELECT (data->>'id')::INT, data->>'nickname', data->>'country', data->>'guid', data->>'steam_id'
FROM temp;
