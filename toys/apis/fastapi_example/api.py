import random

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from faker import Faker

api = FastAPI()

origins = ["*"]

api.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

fake = Faker(locale="en")


@api.get("/name")
def get_name() -> dict[str, str]:
    """Return a random name."""
    return {"data": fake.name()}


@api.get("/text")
def get_name() -> dict[str, str]:
    """Return a random lorel ipsum text."""
    return {"data": fake.text()}


@api.get("/int")
def get_name() -> dict[str, int]:
    """Return a random int."""
    return {"data": random.randint(0, 1000)}
