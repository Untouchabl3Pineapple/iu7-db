from db_query_ex import DatabaseQueryExecutor
import cfg


def menu() -> None:
    print("\n_____________Меню_____________\n")
    print("Выбрать действие:")
    print("1. Выполнить скалярный запрос")
    print("2. Выполнить запрос с несколькими соединениями (JOIN)")
    print("3. Выполнить запрос с ОТВ(CTE) и оконными функциями")
    print("4. Выполнить запрос к метаданным")
    print("5. Вызвать скалярную функцию")
    print("6. Вызвать многооператорную табличную функцию")
    print("7. Вызвать хранимую процедуру")
    print("8. Вызвать системную функцию")
    print("9. Создать таблицу в базе данных, соответствующую тематике БД")
    print(
        "10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT"
    )
    print("0. Выход\n")


def menu_loop() -> None:
    db_query_ex = DatabaseQueryExecutor(cfg.host, cfg.user, cfg.password, cfg.db_name)

    while True:
        menu()
        action = input("Введите действие: ")

        if action == "0":
            break
        elif action == "1":
            response = db_query_ex.scalarQuery()
        elif action == "2":
            response = db_query_ex.joinQuery()
        elif action == "3":
            response = db_query_ex.CTERowNumberQuery()
        elif action == "4":
            response = db_query_ex.metaQuery()
        elif action == "5":
            response = db_query_ex.scalarFuncQuery()
        elif action == "6":
            response = db_query_ex.tabularFuncQuery()
        elif action == "7":
            response = db_query_ex.storedProcCall()
        elif action == "8":
            response = db_query_ex.systemFuncQuery()
        elif action == "9":
            response = db_query_ex.createNewTable()
        elif action == "10":
            response = db_query_ex.insertInNewTable()
        else:
            print("Неправильный пункт меню")
            continue

        print(response)
        