from django.shortcuts import render
from mysite.models import Users, UsersStatistics

from django.db import connection

from peewee import *


def case2_1(request):
    print(Users.select(Users.nickname))
    data = list(Users.objects.values())
    return render(request, "mysite/case2_1.html", {"json_users_data": data})


def case2_2(request):
    data = list(Users.objects.values())
    # update nickname
    data[0]["nickname"] = "lupaipupa"

    return render(request, "mysite/case2_2.html", {"json_users_data": data})


def case2_3(request):
    data = list(Users.objects.values())
    # append new data
    data.append(
        {
            "id": 8899,
            "nickname": "zero",
            "country": "us",
            "guid": "e20dfd0c-67d7-4c1f-9758-6998b1004ea6",
            "steam_id": "STEAM_1:0:39449284",
        }
    )

    return render(request, "mysite/case2_3.html", {"json_users_data": data})


def case3_1(request):
    return render(
        request, "mysite/case3_1.html", {"users_obj_list": Users.objects.all()}
    )


def case3_2(request):
    return render(
        request,
        "mysite/case3_2.html",
        {"usersstats_obj_list": UsersStatistics.objects.all().select_related("users")},
    )


def case3_3(request):
    # insert cell
    insert_cell = Users(
        id=2001,
        nickname="test_nickname_kek",
        country="ru",
        guid="someguid4ec46sigkmwed",
        steam_id="somesteamid3234lkmlkw",
    )
    insert_cell.save()

    # update cell
    update_cell = Users.objects.get(id=5)
    update_cell.nickname = "kekwkkk"
    update_cell.save()

    # delete cell
    temp_cell = Users(
        id=6666,
        nickname="test_nickname_wow",
        country="ru",
        guid="someguid4ec46sigkmwkeke",
        steam_id="somesteamid-2495kego4keke",
    )
    temp_cell.save()
    delete_info = temp_cell.delete()

    return render(
        request,
        "mysite/case3_3.html",
        {
            "insert_cell": insert_cell,
            "update_cell": update_cell,
            "delete_info": delete_info,
        },
    )


def case3_4(request):
    """
    CREATE OR REPLACE PROCEDURE change_nickname(uid INT, unickname VARCHAR(30))
    AS $$
    BEGIN
        UPDATE users
        SET
            nickname = unickname
        WHERE users.id = uid;
    END;
    $$ LANGUAGE PLPGSQL;
    """

    with connection.cursor() as cursor:
        cursor.execute("CALL change_nickname(1, 'TestCase')")

    proc_result = Users.objects.get(id=1)

    return render(request, "mysite/case3_4.html", {"proc_result": proc_result})
