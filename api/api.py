from fastapi import FastAPI
from config import settings


# initialize FastAPI app
app = FastAPI()

@app.get("/")
def hello_api():
    return {"msg":"Hello FastAPI🚀"}

