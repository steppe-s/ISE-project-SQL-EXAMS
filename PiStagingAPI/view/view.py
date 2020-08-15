from fastapi import APIRouter

from controller.controller import ControllerData

app = APIRouter()

controller = ControllerData()


@app.get("/refresh")
async def update_data():
    return controller.update_data()