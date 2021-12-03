/*
    Пользовательскую агрегатную функцию CLR.

    Функция собирает информацию по текущему количеству лвлов,
    совпрадающими с лвлов игрока.
*/

CREATE OR REPLACE FUNCTION getLvlsNumber(lvl INT)
RETURNS INT 
AS $$
	query = '''
        SELECT lvl
        FROM users_statistics 
        WHERE lvl = %d;
            ''' %(lvl)
	res = plpy.execute(query)	

	if res is not None:
		counter = 0

		for users in res:
			counter += 1

		return counter
	
$$ LANGUAGE PLPYTHON3U;

SELECT nickname, lvl, getLvlsNumber(lvl)
FROM users_statistics us JOIN users u ON u.id=us.fk_users_id;