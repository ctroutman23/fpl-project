from sqlalchemy import create_engine, Column, Integer, Float, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker



from fastapi import FastAPI

app = FastAPI()


DATABASE_URL = "sqlite:///.data/fpl_picks.db"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()




def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# GET data
@app.get("/users/", response_model=List[UserResponse]) #return a list of users
def read_users(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)): #paginate results by 10 records at a time
    users = db.query(User).offset(skip).limit(limit).all() #
    return users

# This is too complicated for where I am right now.
