/* 
    19. Инструкция UPDATE со скалярным подзапросом в предложении SET.
    
    Присвоение пользователю с внешним ключем = 1 максимального эло среди всех игроков.
*/

UPDATE users_statistics
SET elo = (SELECT MAX(elo)
           FROM users_statistics)
WHERE fk_users_id = 1