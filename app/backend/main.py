from fastapi import FastAPI
from routes.bridge import router as bridge_router

app = FastAPI()
app.include_router(bridge_router, prefix="/api/bridge")