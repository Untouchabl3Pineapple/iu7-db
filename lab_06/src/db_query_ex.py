import psycopg2


class DatabaseQueryExecutor(object):
    def __init__(self, host, user, password, db_name):
        try:
            self.__connection = psycopg2.connect(
                host=host,
                user=user,
                password=password,
                database=db_name,
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        self.__connection.autocommit = True
        self.__cursor = self.__connection.cursor()

        print("PostgreSQL connection opened ✅")

    def __del__(self):
        if self.__connection:
            self.__cursor.close()
            self.__connection.close()
            print("PostgreSQL connection closed ✅")

    def __sqlWrapper(self, sql) -> str:
        try:
            self.__cursor.execute(sql)
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return
        
        return sql

    def scalarQuery(self) -> int:
        sql =   """
                -- Среднее эло всех игроков

                SELECT AVG(elo)::INT
                FROM users_statistics;
                """

        if self.__sqlWrapper(sql) is not None:
            db_select = self.__cursor.fetchone()
            return db_select[0]

    def joinQuery(self) -> list:
        sql =   """
                -- Лвл, никнейм и айди хаба, где игрок сыграл
                SELECT us.lvl, u.nickname, umh.fk_hubs_id
                FROM users_statistics us JOIN users u
                                                        ON us.fk_users_id = u.id
                                         JOIN users_matches_hubs umh
                                                        ON u.id = umh.fk_users_id
                """
        
        if self.__sqlWrapper(sql) is not None:
            db_select = self.__cursor.fetchall()
            return db_select

    def CTERowNumberQuery(self) -> list:
        sql =   """
                -- Устранение дублирующейся информации о пользователях faceit.
                WITH 
                    duplicate_table AS
                    (
                        SELECT *
                        FROM users

                        UNION ALL
                        
                        SELECT *
                        FROM users
                        ORDER BY id
                    ),

                    numbered_table AS
                    (
                        SELECT ROW_NUMBER() OVER(PARTITION BY id) AS num, *
                        FROM duplicate_table
                    )

                SELECT id, nickname, country, guid, steam_id
                FROM numbered_table
                WHERE num = 1;
                """

        if self.__sqlWrapper(sql) is not None:
            db_select = self.__cursor.fetchall()
            return db_select

    def metaQuery(self) -> list:
        sql =   """
                -- Название процедур с более чем 5 параметрами
                SELECT p.proname
                FROM pg_proc p
                WHERE p.pronargs > 5;
                """

        if self.__sqlWrapper(sql) is not None:
            db_select = self.__cursor.fetchall()
            return db_select

    def scalarFuncQuery(self) -> list:
        sql =   """
                -- Скалярная функция для вывода статистики игроков текстом.
                -- CREATE OR REPLACE FUNCTION getLvlElo(lvl INT, elo INT)
                -- RETURNS TEXT AS $$
                -- BEGIN
                --     RETURN FORMAT('Lvl: %s, Elo: %s', lvl, elo);
                -- END;
                -- $$ LANGUAGE PLPGSQL;

                -- Характеристика игроков текстом
                SELECT nickname, getLvlElo(lvl, elo)
                FROM users_statistics
                    JOIN users
                        ON users.id = fk_users_id;
                """
        
        if self.__sqlWrapper(sql) is not None:
            db_select = self.__cursor.fetchall()
            return db_select

    def tabularFuncQuery(self) -> list:
        sql =   """
                -- Многооператорная табличная функция для вывода статистики игроков.
                -- CREATE OR REPLACE FUNCTION getUsersStats()
                -- RETURNS TABLE
                --         (
                --             user_nickname VARCHAR(30)
                --             , user_lvl INT
                --             , user_elo INT
                --         ) AS $$
                -- BEGIN
                --     DROP TABLE IF EXISTS usersStats;
                    
                --     CREATE TEMP TABLE usersStats(
                --             user_nickname VARCHAR(30)
                --             , user_lvl INT
                --             , user_elo INT
                --         );

                --     INSERT INTO usersStats (user_nickname
                --                             , user_lvl
                --                             , user_elo)
                --     SELECT nickname, lvl, elo
                -- 		   		 FROM users, users_statistics
                -- 		   		 WHERE users.id = fk_users_id;

                --     RETURN query SELECT *
                -- 		   		 FROM usersStats;
                -- END;
                -- $$ LANGUAGE PLPGSQL;

                -- Характеристика игроков
                SELECT *
                FROM getUsersStats();
                """
        
        if self.__sqlWrapper(sql) is not None:
            db_select = self.__cursor.fetchall()
            return db_select

    def storedProcCall(self) -> str:
        sql =   """
                -- Хранимая процедура, обновляющая информацию об игроке, в сущности users
                -- CREATE OR REPLACE PROCEDURE change_nickname(uid INT, unickname VARCHAR(30))
                -- AS $$
                -- BEGIN
                --      UPDATE users
                --      SET nickname = unickname
                --      WHERE users.id = uid;
                -- END;
                -- $$ LANGUAGE PLPGSQL;

                -- Обновление информации об игроке
                CALL change_nickname(1, 'TestName');
                """
        
        if self.__sqlWrapper(sql) is not None:
            return "Success"

    def systemFuncQuery(self) -> list:
        sql =   """
                -- Вызов системной функции для генерации uuid
                SELECT gen_random_uuid();
                """
        
        if self.__sqlWrapper(sql) is not None:
            db_select = self.__cursor.fetchone()
            return db_select[0]

    def createNewTable(self) -> str:
        sql =   """
                -- Создание новой сущности
                CREATE TEMP TABLE IF NOT EXISTS UsersDuplicate
                (
                    id INT PRIMARY KEY,
                    nickname VARCHAR(30) UNIQUE NOT NULL,
                    country VARCHAR(20) NOT NULL,
                    guid VARCHAR(200) UNIQUE NOT NULL,
                    steam_id VARCHAR(100) UNIQUE NOT NULL
                );
                """
        
        if self.__sqlWrapper(sql) is not None:
            return "Success"

    def insertInNewTable(self) -> str:
        sql =   """
                -- Вставка данных в новую сущность
                INSERT INTO UsersDuplicate(id, nickname, country, guid, steam_id)
                SELECT *
                FROM users
                """

        if self.__sqlWrapper(sql) is not None:
            return "Success"
