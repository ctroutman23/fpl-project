from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    Project_Name: str = "FPL Analysis"
    Project_Version: str = "1.0.0"
    database_url: str = "sqlite:///.data/fpl_picks.db"
    debug: bool = True


settings = Settings()