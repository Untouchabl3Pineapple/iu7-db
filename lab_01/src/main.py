from faceitdb import FaceitDB
import cfg

if __name__ == "__main__":
    faceit_db = FaceitDB(cfg.host, cfg.user, cfg.password, cfg.db_name)

    faceit_db.delete_tables()
    faceit_db.create_tables()

    faceit_db.insert_db_data(["74624044-158f-446a-ad4f-cbd2e0e89423", "b625fdf5-5235-4dab-9ac5-1c3c7bc4b0e0"])
