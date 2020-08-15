import uvicorn
from fastapi import FastAPI
from view.view import app as view_results


app = FastAPI()
app.include_router(view_results, prefix='/results', tags=['result'])

if __name__ == '__main__':
    # Run the application
    uvicorn.run(app)

