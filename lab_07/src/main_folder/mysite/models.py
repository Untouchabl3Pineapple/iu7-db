# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Hubs(models.Model):
    id = models.IntegerField(primary_key=True)
    hub_id = models.CharField(unique=True, max_length=200)
    name = models.CharField(max_length=200)
    region = models.CharField(max_length=20)
    game_mode = models.CharField(max_length=100)
    min_skill_lvl = models.IntegerField()
    max_skill_lvl = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'hubs'


class Matches(models.Model):
    id = models.IntegerField(primary_key=True)
    match_id = models.CharField(unique=True, max_length=200)
    region = models.CharField(max_length=20)
    map = models.CharField(max_length=50)
    score = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'matches'


class MatchesStatistics(models.Model):
    kills = models.IntegerField()
    deaths = models.IntegerField()
    average_kd_ratio = models.FloatField()
    mvps = models.IntegerField()
    triple_kills = models.IntegerField()
    quadro_kills = models.IntegerField()
    penta_kills = models.IntegerField()
    fk_users_matches_hubs = models.ForeignKey('UsersMatchesHubs', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'matches_statistics'


class Users(models.Model):
    id = models.IntegerField(primary_key=True)
    nickname = models.CharField(unique=True, max_length=30)
    country = models.CharField(max_length=20)
    guid = models.CharField(unique=True, max_length=200)
    steam_id = models.CharField(unique=True, max_length=100)

    class Meta:
        managed = False
        db_table = 'users'


class UsersMatchesHubs(models.Model):
    fk_users = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    fk_matches = models.ForeignKey(Matches, models.DO_NOTHING, blank=True, null=True)
    fk_hubs = models.ForeignKey(Hubs, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'users_matches_hubs'


class UsersStatistics(models.Model):
    lvl = models.IntegerField()
    elo = models.IntegerField()
    matches = models.IntegerField()
    average_kd_ratio = models.FloatField()
    users = models.ForeignKey(Users, models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'users_statistics'
