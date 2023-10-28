import json
import random
import time

from faker import Faker
from flask import Flask, Response

app = Flask(__name__)


class DataGenerator:
    """Data Generating Object."""

    def __init__(self) -> None:
        self.fake = Faker()

    def _generate_row(self) -> str:
        """Generate a dict and return a json.dumps of it."""
        return {
            "name": self.fake.name(),
            "address": self.fake.address(),
            "date": self.fake.date(),
            "id": self.fake.ssn(),
            "net_worth": random.randint(30000, 1000000),
        }

    def generate_data(self, num_rows: int = 10, secs_apart: float = 1):
        """Generate streaming data JSON."""
        for _ in range(num_rows):
            yield json.dumps(self._generate_row())
            time.sleep(secs_apart)


dg = DataGenerator()


@app.route("/stream_data")
def stream_data():
    """Route to GET stream data."""
    print("ok, cool")
    return Response(
        dg.generate_data(num_rows=100, secs_apart=1), content_type="application/json"
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8001)
