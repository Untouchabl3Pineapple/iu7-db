from database import Database
import cfg

if __name__ == "__main__":
    db = Database(cfg.host, cfg.user, cfg.password, cfg.db_name)

    db.buttonsEvents()
    db.eventsTypes()
    db.users()
    db.eventsAdditInform()
