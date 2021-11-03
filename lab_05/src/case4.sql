/*
    4. Выполнить следующие действия:     
        (Пункты 1,2 сделаны в прошлом кейсе 2,3)   
        1. Извлечь XML/JSON фрагмент из XML/JSON документа
        2. Извлечь значения конкретных узлов или атрибутов XML/JSON
           документа


        3. Выполнить проверку существования узла или атрибута
        4. Изменить XML/JSON документ
        5. Разделить XML/JSON документ на несколько строк по узлам
*/


-- Пункт 3
DROP FUNCTION IF EXISTS is_key(json_to_check JSONB, key TEXT);

CREATE OR REPLACE FUNCTION is_key(json_to_check JSONB, key TEXT)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN json_to_check->key IS NOT NULL;
END;
$$ LANGUAGE PLPGSQL;

-- Корректный случай
SELECT is_key('{"html": "body"}', 'html');
-- Некорректный случай
SELECT is_key('{"css": "selector"}', 'hmtl');


-- Пункт 4
DROP TABLE IF EXISTS JsonDoc1, JsonDoc2;

CREATE TEMP TABLE IF NOT EXISTS JsonDoc1
(
    data JSONB
);
CREATE TEMP TABLE IF NOT EXISTS JsonDoc2
(
    data JSONB
);

\copy JsonDoc1(data) FROM 'datasets/users.json';
\copy JsonDoc2(data) FROM 'datasets/users_statistics.json';

UPDATE
    JsonDoc1
SET 
    data = jd2.data
FROM
    JsonDoc2 jd2;


-- Пункт 5
SELECT *
FROM jsonb_array_elements
(
    '[
    {"name": "Ilya", "study": "BMSTU"},
    {"name": "Khamit", "study": "DGU"}
    ]'
);

