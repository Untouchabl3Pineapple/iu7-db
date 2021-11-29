/* 
    19. Инструкция UPDATE со скалярным подзапросом в предложении SET.
    
    Пример замены типа происшествия по uuid (в данном случае не сработает запрос,
    так как поле EventType является уникальным)
*/

UPDATE EventsTypes
SET EventType=(SELECT EventType
			   FROM EventsTypes
			   WHERE ID='45eb5203-113c-48b7-8692-7e0cd76a86a9')
WHERE ID='2d730fd3-fd18-4653-9f6b-d65b98e77ef7';