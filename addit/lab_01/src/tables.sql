-- Удаление сущностей
DROP TABLE IF EXISTS Events, EventsTypes, Users, ButtonsEvents, ButtonsPosts;

-- Создание сущности EventsTypes
CREATE TABLE IF NOT EXISTS EventsTypes
(
    ID                  UUID PRIMARY KEY,
    EventType           TEXT UNIQUE NOT NULL
);

-- Создание сущности Users
CREATE TABLE IF NOT EXISTS Users
(
    Login                VARCHAR(255) PRIMARY KEY,
    Name                 VARCHAR(127) NOT NULL,
    Surname              VARCHAR(127) NOT NULL,
    MiddleName           VARCHAR(127)
);

-- Создание сущности ButtonsEvents
CREATE TABLE IF NOT EXISTS ButtonsEvents
(
    ID                   UUID PRIMARY KEY,
    ButtonColor          SMALLINT NOT NULL,
    Number               SMALLINT NOT NULL
);

-- Создание сущности ButtonsPosts
CREATE TABLE IF NOT EXISTS ButtonsPosts
(
    Post                 SMALLINT PRIMARY KEY,
    LeftSide             SMALLINT NOT NULL,
    RightSide            SMALLINT NOT NULL,
    LeftColor            SMALLINT NOT NULL,
    RightColor           SMALLINT NOT NULL
);

-- Создание сущности Events
CREATE TABLE IF NOT EXISTS Events
(
    ID                  UUID PRIMARY KEY,
    ButtonEvent_ID      UUID NOT NULL REFERENCES ButtonsEvents(ID),
    EventType_ID        UUID REFERENCES EventsTypes(ID) ON DELETE SET NULL,
    EventDescription    TEXT,
    DetectingTime       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FixingTime          TIMESTAMP WITH TIME ZONE,
    TimeUpdate          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    User_Login          VARCHAR(255) REFERENCES Users(Login)
);