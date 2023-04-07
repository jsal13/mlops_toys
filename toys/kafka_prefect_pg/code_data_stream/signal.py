import json
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum, auto


class Power(Enum):
    """Enum for ``Power`` field in ``Signal``."""

    HIGH = auto()
    MEDIUM = auto()
    LOW = auto()


@dataclass
class Signal:
    """
    Single ``Signal`` for use in a data stream.

    ``heat_index`` is the target variable for any ML/DS kind of stuff.
    0 <= heat_index <= 1.

    Note: We cannot constrain the datetime to a certain type because of the following:
    https://github.com/pydantic/pydantic/issues/156
    """

    sensor_id: int
    value_1: int
    value_2: float
    value_3: float
    power: Power
    heat_index: float
    dt: str = field(default=datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

    def to_json(self) -> str:
        """Convert dataclass values to json."""
        # Remove "__pydantic_initialized__" from the dict.
        values = self.__dict__.copy()

        return json.dumps(values, default=lambda x: x.name)

    def to_csv(self) -> str:
        """Convert dataclass values to csv."""
        # Remove "__pydantic_initialized__" from the dict.
        values = self.__dict__.copy()
        del values["__pydantic_initialised__"]

        return (
            f"{self.sensor_id},{self.value_1},{self.value_2},{self.value_3},"
            + f"{self.power},{self.heat_index},{self.dt}"
        )
