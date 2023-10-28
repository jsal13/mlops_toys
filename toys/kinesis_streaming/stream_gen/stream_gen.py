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

    def generate_data(self, num_rows: int = 10, secs_apart: float = 1) -> str:
        """
        Generate streaming data JSON.

        Args:
            num_rows (int, optional): Number of rows generated. Defaults to 10.
                Use -1 to have a continuous, limitless stream.
            secs_apart (float, optional): Number of seconds between generation. Defaults to 1.

        Yields:
            str: Generated Row.
        """
        infinite_generation = num_rows == -1  # Do we generate infinitely?
        acc = 0
        while acc < num_rows or infinite_generation:
            yield json.dumps(self._generate_row())
            if not infinite_generation:
                acc += 1
            time.sleep(secs_apart)


dg = DataGenerator()


@app.route("/stream_data")
def stream_data():
    """Route to GET stream data."""

    # TODO: Is this how people do crap?
    return Response(json.dumps(dg._generate_row()), content_type="application/json")


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8001)
