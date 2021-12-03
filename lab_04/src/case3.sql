/*
    Определяемую пользователем табличную функцию CLR.

    Функция фильтрует данные по сущностям и выводит
    информацию о пользователях, у которых эло больше заданного.
*/

CREATE OR REPLACE FUNCTION getFilteredUsers(elo INT)
RETURNS TABLE
(
    nickname VARCHAR(30), 
    elo INT, 
    lvl INT
)
AS $$
	query = '''
        SELECT nickname, elo, lvl
        FROM users_statistics us JOIN users u ON u.id=us.fk_users_id;
            '''
	res = plpy.execute(query)	

	res_list = []
	if res is not None:
		for user in res:
			if user["elo"] > elo:
				res_list.append(user)
		return res_list
		
$$ LANGUAGE PLPYTHON3U;

SELECT *
FROM getFilteredUsers(3000);