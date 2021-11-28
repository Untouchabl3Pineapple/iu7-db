from random import randint, choice
from uuid import uuid4
from faker import Faker
import psycopg2


class Database(object):
    def __init__(self, host, user, password, db_name):
        self.fake = Faker(locale="ru_RU")

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

    def __del__(self):
        if self.__connection:
            self.__cursor.close()
            self.__connection.close()
            print("PostgreSQL connection closed ✅")

    def buttonsEvents(self, amount=3000):
        # Наполнение сущности ButtonsEvents
        for i in range(amount):
            try:
                self.__cursor.execute(
                    """
                    --sql
                    INSERT INTO ButtonsEvents (ID, ButtonColor, Number)
                    VALUES (%s, %s, %s)
                    """,
                    (str(uuid4()), randint(1, 3), randint(1, 14)),
                )
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)
                return

        print("ButtonsEvents inform added ✅")

    def eventsTypes(self, amount=1000):
        # Наполнение сущности EventsTypes
        for i in range(amount):
            try:
                self.__cursor.execute(
                    """
                    --sql
                    INSERT INTO EventsTypes (ID, EventType)
                    VALUES (%s, %s)
                    """,
                    (str(uuid4()), self.fake.text()),
                )
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)
                return

        print("EventsTypes inform added ✅")

    def users(self, amount=1000):
        # Наполнение сущности Users
        for i in range(amount):
            try:
                self.__cursor.execute(
                    """
                    --sql
                    INSERT INTO Users (Login, Name, Surname)
                    VALUES (%s, %s, %s)
                    """,
                    (
                        self.fake.user_name(),
                        self.fake.first_name(),
                        self.fake.last_name(),
                    ),
                )
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)
                continue

        print("Users inform added ✅")

    def eventsAdditInform(self):
        # Получаем список uuid типов происшествий
        try:
            self.__cursor.execute(
                """
                --sql
                SELECT ID
                FROM EventsTypes;
                """
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return
        events_types_id_list = self.__cursor.fetchall()

        # Получаем список логинов пользователей
        try:
            self.__cursor.execute(
                """
                --sql
                SELECT Login
                FROM Users;
                """
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return
        users_login_list = self.__cursor.fetchall()

        # Получаем список uuid ивентов
        try:
            self.__cursor.execute(
                """
                --sql
                SELECT ID
                FROM Events;
                """
            )
        except Exception as err:
            print("Error while working with PostgreSQL ❌", err)
            return
        events_id_list = self.__cursor.fetchall()

        # Заполняем дополнительную информацию в сущности Events
        for id in events_id_list:
            try:
                self.__cursor.execute(
                    """
                    --sql
                    UPDATE Events
                    SET EventType_ID=%s, User_Login=%s, EventDescription=%s
                    WHERE ID=%s
                    """,
                    (
                        choice(events_types_id_list)[0],
                        choice(users_login_list)[0],
                        self.fake.text(),
                        id[0],
                    ),
                )
            except Exception as err:
                print("Error while working with PostgreSQL ❌", err)
                continue

        print("Events addit inform added ✅")
