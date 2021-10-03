-- Защита к лабораторной

-- Первые десять матчей, в которых принимали участие игроки
-- с самым большим количеством сыгранных матчей (ТОП 10 игроков)

-- ОТВ
WITH
    -- Выборка с нумерацией каждого матча игрока
    users_matches AS
    (
        SELECT ROW_NUMBER() OVER(PARTITION BY fk_users_id) AS mVal, *
        FROM users_matches_hubs
    ),
        
    -- Выборка ТОП 10 игроков и их количество матчей
    sorted_users_matches AS
    (
        SELECT fk_users_id, 
               max(mVal) AS matchesVal
        FROM users_matches
        GROUP BY fk_users_id
        ORDER BY matchesVal DESC LIMIT 10
    )

-- Выборка первых 10 матчей с ТОП 10 игроками
SELECT *
FROM users_matches_hubs, sorted_users_matches
WHERE users_matches_hubs.fk_users_id = sorted_users_matches.fk_users_id
ORDER BY fk_matches_id LIMIT 10
