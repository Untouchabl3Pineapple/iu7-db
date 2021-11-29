/* 
    17. Многострочная инструкция INSERT, выполняющая вставку в таблицу
    результирующего набора данных вложенного подзапроса.
    
    Создание временной таблицы и вставка туда ButtonsEvents и статистики количества
    нажатых кнопок по текущему цвету.
*/

-- Удаление таблицы
DROP TABLE IF EXISTS TempButtonsEvents;

-- Создание таблицы
CREATE TEMP TABLE IF NOT EXISTS TempButtonsEvents
(
    ID                   UUID PRIMARY KEY,
    ButtonColor          SMALLINT NOT NULL,
    Number               SMALLINT NOT NULL,
	Amount				 SMALLINT NOT NULL
);

-- Вставка в таблицу
INSERT INTO TempButtonsEvents
SELECT ID, ButtonColor, Number, (SELECT COUNT(*)
								 FROM ButtonsEvents
								 WHERE ButtonColor=be.ButtonColor)
FROM ButtonsEvents be;

SELECT *
FROM TempButtonsEvents;