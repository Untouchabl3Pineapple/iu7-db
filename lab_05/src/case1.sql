/*
    1. Из таблиц базы данных, созданной в первой лабораторной работе,
    извлечь данные в XML (MSSQL) или JSON(Oracle, Postgres).
    Для выгрузки в XML проверить все режимы конструкции FOR XML
*/

\t \a

\o datasets/users.json
SELECT ROW_TO_JSON(u)
FROM users u;

\o datasets/users_statistics.json
SELECT ROW_TO_JSON(us)
FROM users_statistics us;

\o datasets/users_matches_hubs.json
SELECT ROW_TO_JSON(umh)
FROM users_matches_hubs umh;

\o datasets/matches_statistics.json
SELECT ROW_TO_JSON(ms)
FROM matches_statistics ms;

\o datasets/matches.json
SELECT ROW_TO_JSON(m)
FROM matches m;
