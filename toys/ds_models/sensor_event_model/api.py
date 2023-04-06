from dataclasses import asdict, dataclass
from typing import Optional

import pandas as pd
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from toys.ds_models.sensor_event_model.model import EventModel

api = FastAPI()

origins = ["*"]

api.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# This is gross.  Refactor it.
EVENT_MODEL: Optional[EventModel] = None


# Make the model.
@api.post("/make_model")
async def make_model() -> None:
    """Make the model."""
    global EVENT_MODEL

    EVENT_MODEL = EventModel()
    EVENT_MODEL.train_model()
    print(EVENT_MODEL.score_model())
    EVENT_MODEL.save_model(loc=".")


# Define the POST record.
@dataclass
class Row:
    """Represent a row of data."""

    sensor_id: int
    value_1: int
    value_2: float
    value_3: float
    heat_index: float
    power: str


@api.post("/predict")
async def predict(row: Row) -> int:
    """Call predict on the model."""
    if EVENT_MODEL is not None:
        df_row = pd.DataFrame(asdict(row), index=[0])
        return EVENT_MODEL.clf.predict(df_row)[0]
    return -9999
