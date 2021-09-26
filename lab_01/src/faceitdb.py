import requests
import psycopg2


class FaceitDB(object):
    """
    JSON main links

    https://api.faceit.com/stats/v1/stats/users/6a65cf56-281d-464a-98c0-46babd0c97c0/games/csgo
    https://api.faceit.com/stats/v1/stats/time/users/6a65cf56-281d-464a-98c0-46babd0c97c0/games/csgo?page=0&size=1000
    https://api.faceit.com/leaderboard/v1/ranking/hub/b625fdf5-5235-4dab-9ac5-1c3c7bc4b0e0?leaderboardType=hub_general&limit=50&offset=0
    https://chat-server.faceit.com/v4/meta/match-1-9ba483a7-fc47-417f-bb06-69e090fbce3e
    https://api.faceit.com/search/v1/hubs?game=csgo&offset=0&limit=100&joinableOnly=false&sort=-activity&queue.open=true
    https://api.faceit.com/match/v2/match/1-9ba483a7-fc47-417f-bb06-69e090fbce3e
    """

    def __init__(self, host, user, password, db_name):
        try:
            self.__connection = psycopg2.connect(
                host=host,
                user=user,
                password=password,
                database=db_name,
            )
            self.__connection.autocommit = True
            self.__cursor = self.__connection.cursor()
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        """
        ! For normal output in terminal
        """

        self.__users_counter = 1
        self.__users_statistics_counter = 1
        self.__matches_counter = 1
        self.__users_matches_hubs_counter = 1
        self.__matches_statistics_counter = 1
        self.__hubs_counter = 1

        """
        ! For the correct operation of the database
        """

        self.__users_const = 1
        self.__matches_const = 1
        self.__hubs_const = 1
        self.__users_matches_hubs_const = 1

    def __del__(self):
        if self.__connection:
            self.__cursor.close()
            self.__connection.close()
            print("PostgreSQL connection closed ✅")

    def create_tables(self):
        try:
            self.__cursor.execute(
                """
                --sql
                CREATE TABLE users
                (
                    id INT PRIMARY KEY,
                    nickname VARCHAR(30) UNIQUE NOT NULL,
                    country VARCHAR(20) NOT NULL,
                    guid VARCHAR(200) UNIQUE NOT NULL,
                    steam_id VARCHAR(100) UNIQUE NOT NULL
                )
                ;

                CREATE TABLE users_statistics
                (
                    lvl INT NOT NULL,
                    elo INT NOT NULL,
                    matches INT NOT NULL,
                    average_kd_ratio FLOAT4 NOT NULL,
                    fk_users_id INT REFERENCES users(id)
                )
                ;

                CREATE TABLE matches
                (
                    id INT PRIMARY KEY,
                    match_id VARCHAR(200) UNIQUE NOT NULL,
                    region VARCHAR(20) NOT NULL,
                    map VARCHAR(50) NOT NULL,
                    score VARCHAR(10) NOT NULL
                )
                ;

                CREATE TABLE hubs
                (
                    id INT PRIMARY KEY,
                    hub_id VARCHAR(200) UNIQUE NOT NULL,
                    name VARCHAR(200) NOT NULL,
                    region VARCHAR(20) NOT NULL,
                    game_mode VARCHAR(100) NOT NULL,
                    min_skill_lvl INT NOT NULL,
                    max_skill_lvl INT NOT NULL
                )
                ;

                CREATE TABLE users_matches_hubs
                (
                    id SERIAL PRIMARY KEY,
                    fk_users_id INT REFERENCES users(id),
                    fk_matches_id INT REFERENCES matches(id),
                    fk_hubs_id INT REFERENCES hubs(id)
                )
                ;

                CREATE TABLE matches_statistics
                (
                    kills INT NOT NULL,
                    deaths INT NOT NULL,
                    average_kd_ratio FLOAT4 NOT NULL,
                    mvps INT NOT NULL,
                    triple_kills INT NOT NULL,
                    quadro_kills INT NOT NULL,
                    penta_kills INT NOT NULL,
                    fk_users_matches_hubs_id INT REFERENCES users_matches_hubs(id)
                )
                ;
                """
            )
            print("The tables have been added ✅")
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)

    def delete_tables(self):
        try:
            self.__cursor.execute(
                """
                --sql
                DROP TABLE users, users_statistics, users_matches_hubs, matches, matches_statistics, hubs
                """
            )
            print("The tables have been deleted ✅")
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)

    def __filling_users(self, hub_id, expected_users=1100):
        self.__users_const = self.__users_counter

        absolute_limit = 1000
        limit_in_one_response = 50
        offset = 0

        while offset <= absolute_limit and self.__users_counter < expected_users:
            response = requests.get(
                "https://api.faceit.com/leaderboard/v1/ranking/hub/"
                + hub_id
                + "?leaderboardType=hub_general&limit="
                + str(limit_in_one_response)
                + "&offset="
                + str(offset)
            ).json()

            rating_table = response["payload"]["rankings"]

            for i in range(limit_in_one_response):
                nickname = rating_table[i]["placement"]["entity_name"]

                get_player = requests.get(
                    "https://api.faceit.com/core/v1/nicknames/" + nickname,
                    headers={"Accept-Encoding": "identity"},
                ).json()

                if get_player["result"] == "error":
                    continue

                payload = get_player["payload"]  # general path

                country = payload["country"]
                guid = payload["guid"]
                steam_id = payload["steam_id"]

                try:
                    self.__cursor.execute(
                        """--sql
                        INSERT INTO users (id, nickname, country, guid, steam_id) VALUES (%s, %s, %s, %s, %s)""",
                        (self.__users_counter, nickname, country, guid, steam_id),
                    )
                    print(f"{self.__users_counter} users have been added 😎")
                    self.__users_counter += 1
                except Exception as err:
                    print("Error while working with PostgreSQL ❌", err)

            offset += limit_in_one_response

    def __filling_users_statistics(self):
        try:
            self.__cursor.execute(
                """
                --sql
                SELECT nickname, guid from users where id >= (%s)
                ;
                """,
                (self.__users_const,),
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        users_list = (
            self.__cursor.fetchall()
        )  # users_list[i][0] - nicknames, users_list[i][1] - guids
        users_rows = len(users_list)

        for i in range(users_rows):
            nickname = users_list[i][0]
            guid = users_list[i][1]

            get_player = requests.get(
                "https://api.faceit.com/core/v1/nicknames/" + nickname,
                headers={"Accept-Encoding": "identity"},
            ).json()

            if get_player["result"] == "error":
                continue

            try:
                get_player_path = get_player["payload"]["games"][
                    "csgo"
                ]  # path leads to information: skill_level, faceit_elo
            except Exception as err:
                print(
                    "Error while working with filling_users_statistics (get_player) ❌",
                    err,
                )
                continue

            get_game_stats = requests.get(
                "https://api.faceit.com/stats/v1/stats/users/" + guid + "/games/csgo"
            ).json()

            try:
                get_game_stats_path = get_game_stats[
                    "lifetime"
                ]  # path leads to information: Matches, Average K/D Ratio
            except Exception as err:
                print(
                    "Error while working with filling_users_statistics (get_game_stats) ❌",
                    err,
                )
                continue

            lvl = get_player_path["skill_level"]
            elo = get_player_path["faceit_elo"]
            matches = int(get_game_stats_path["m1"])  # string -> int
            kd = float(get_game_stats_path["k5"])  # string -> float

            try:
                self.__cursor.execute(
                    """--sql
                    INSERT INTO users_statistics (lvl, elo, matches, average_kd_ratio, fk_users_id) VALUES (%s, %s, %s, %s, %s)""",
                    (lvl, elo, matches, kd, self.__users_statistics_counter),
                )
                print(
                    f"Statistics were filled in for {self.__users_statistics_counter} people 📈 🤩"
                )
                self.__users_statistics_counter += 1
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)

    def __filling_matches(self):
        self.__matches_const = self.__matches_counter

        try:
            self.__cursor.execute(
                """
                --sql
                SELECT guid from users where id >= (%s)
                ;
                """,
                (self.__matches_counter,),
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        users_list = self.__cursor.fetchall()  # users_list[i] - guids
        users_rows = len(users_list)

        for i in range(users_rows):
            guid = users_list[i][0]

            get_game_stats = requests.get(
                "https://api.faceit.com/stats/v1/stats/time/users/"
                + guid
                + "/games/csgo?page=0&size=1000"
            ).json()

            exp_flag = 0
            for match in get_game_stats:
                get_match_info = requests.get(
                    "https://api.faceit.com/match/v2/match/" + dict(match)["matchId"]
                ).json()

                try:
                    match_type = get_match_info["payload"]["entity"]["type"]
                except:
                    break

                if match_type == "hub":
                    exp_flag = 1
                    match_id = match["matchId"]
                    region = match["i0"]
                    game_map = match["i1"]
                    score = match["i18"]
                    break

            if exp_flag == 0:
                print(
                    "The hub was not selected for this match, check the information ❌"
                )
                continue

            try:
                self.__cursor.execute(
                    """--sql
                    INSERT INTO matches (id, match_id, region, map, score) VALUES (%s, %s, %s, %s, %s)""",
                    (self.__matches_counter, match_id, region, game_map, score),
                )
                print(f"{self.__matches_counter} matches have been added 🎮")
                self.__matches_counter += 1
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)

    def __filling_hubs(self, expected_hubs=2000):
        self.__hubs_const = self.__hubs_counter

        absolute_limit = 10000
        limit_in_one_response = 100
        offset = 0

        while offset <= absolute_limit and self.__hubs_counter < expected_hubs:
            response = requests.get(
                "https://api.faceit.com/search/v1/hubs?game=csgo&offset="
                + str(offset)
                + "&limit="
                + str(absolute_limit)
                + "&joinableOnly=false&sort=-activity&queue.open=true"
            ).json()

            hubs = response["payload"]["results"]
            hubs_rows = len(hubs)

            for i in range(hubs_rows):
                hub = hubs[i]

                id = hub["id"]
                name = hub["name"]
                region = hub["region"]
                mode = hub["queue"]["gameMode"]
                min_skill_lvl = hub["minSkillLevel"]
                max_skill_lvl = hub["maxSkillLevel"]

                try:
                    self.__cursor.execute(
                        """--sql
                        INSERT INTO hubs (id, hub_id, name, region, game_mode, min_skill_lvl, max_skill_lvl) VALUES (%s, %s, %s, %s, %s, %s, %s)""",
                        (
                            self.__hubs_counter,
                            id,
                            name,
                            region,
                            mode,
                            min_skill_lvl,
                            max_skill_lvl,
                        ),
                    )
                    print(f"{self.__hubs_counter} hubs have been added 👩‍💻")
                    self.__hubs_counter += 1
                except Exception as err:
                    print("Error while working with PostgreSQL ❌", err)

            offset += limit_in_one_response

    def __filling_users_matches_hubs(self):
        self.__users_matches_hubs_const = self.__users_matches_hubs_counter

        try:
            self.__cursor.execute(
                """
                --sql
                SELECT match_id from matches where id >= (%s)
                ;
                """,
                (self.__matches_const,),
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        matches_list = self.__cursor.fetchall()
        matches_rows = len(matches_list)

        try:
            self.__cursor.execute(
                """
                --sql
                SELECT guid from users where id >= (%s)
                ;
                """,
                (self.__users_const,),
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        guids_list = self.__cursor.fetchall()

        try:
            self.__cursor.execute(
                """
                --sql
                SELECT hub_id from hubs where id >= (%s)
                ;
                """,
                (self.__hubs_const,),
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        hubs_tuples_list = self.__cursor.fetchall()

        hubs_list = []
        for hub in hubs_tuples_list:
            hubs_list.append(hub[0])

        for i in range(matches_rows):
            match_id = matches_list[i][0]

            get_match_info = requests.get(
                "https://api.faceit.com/match/v2/match/" + match_id
            ).json()

            hub_id = get_match_info["payload"]["entity"]["id"]

            try:
                get_chat_server = requests.get(
                    "https://chat-server.faceit.com/v4/meta/match-" + match_id
                ).json()
            except:
                continue

            members = get_chat_server["members"]
            guids_in_match = []

            for member in members:
                guids_in_match.append(member["u"])

            for j in range(len(guids_list)):
                if guids_list[j][0] in guids_in_match and hub_id in hubs_list:
                    try:
                        self.__cursor.execute(
                            """--sql
                            INSERT INTO users_matches_hubs (fk_users_id, fk_matches_id, fk_hubs_id) VALUES (%s, %s, %s)""",
                            (
                                j + 1,
                                i + self.__matches_const,
                                hubs_list.index(hub_id) + 1,
                            ),
                        )
                        print(
                            f"{self.__users_matches_hubs_counter} links have been added 😋 🎮"
                        )
                        self.__users_matches_hubs_counter += 1
                    except Exception as err:
                        print("Error while working with PostgreSQL ❌", err)

    def __filling_matches_statistics(self):
        try:
            self.__cursor.execute(
                """
                --sql
                SELECT fk_users_id, fk_matches_id from users_matches_hubs where id >= (%s)
                ;
                """,
                (self.__users_matches_hubs_counter,),
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return

        users_matches_hubs = self.__cursor.fetchall()
        users_matches_hubs_rows = len(users_matches_hubs)

        for i in range(users_matches_hubs_rows):
            match_data = users_matches_hubs[i]

            try:
                self.__cursor.execute(
                    """
                    --sql
                    SELECT guid from users where id = (%s)
                    ;
                    """,
                    (match_data[0],),
                )
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)
                return

            guid = self.__cursor.fetchone()[0]

            try:
                self.__cursor.execute(
                    """
                    --sql
                    SELECT match_id from matches where id = (%s)
                    ;
                    """,
                    (match_data[1],),
                )
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)
                return

            match_id = self.__cursor.fetchone()[0]

            get_game_stats = requests.get(
                "https://api.faceit.com/stats/v1/stats/time/users/"
                + guid
                + "/games/csgo?page=0&size=1000"
            ).json()

            for i in range(len(get_game_stats)):
                match_stats = get_game_stats[i]

                if match_stats["matchId"] == match_id:
                    try:
                        self.__cursor.execute(
                            """--sql
                            INSERT INTO matches_statistics
                            (kills, deaths, average_kd_ratio, mvps, triple_kills, quadro_kills, penta_kills, fk_users_matches_hubs_id)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""",
                            (
                                match_stats["i6"],
                                match_stats["i8"],
                                match_stats["c2"],
                                match_stats["i9"],
                                match_stats["i14"],
                                match_stats["i15"],
                                match_stats["i16"],
                                self.__matches_statistics_counter,
                            ),
                        )
                        print(
                            f"{self.__matches_statistics_counter} match statistics have been added 📈 👾"
                        )
                        self.__matches_statistics_counter += 1
                    except Exception as err:
                        print("Error while working with PostgreSQL ❌", err)

    def insert_db_data(self, hubs_list):
        self.__filling_hubs()

        for hub_id in hubs_list:
            self.__filling_users(hub_id)
            self.__filling_users_statistics()
            self.__filling_matches()
            self.__filling_users_matches_hubs()
            self.__filling_matches_statistics()
