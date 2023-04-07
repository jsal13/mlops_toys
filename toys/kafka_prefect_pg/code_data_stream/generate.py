import random
from datetime import datetime, timedelta

import numpy as np
from code_data_stream.signal import Power, Signal

NUM_SENSORS = 10


def generate_signal_target_variable(value_1: int, value_2: float, power: Power) -> float:
    """
    Create an example target variable for signal given the other values.

    This can be modified to create other targets, etc.

    Notes
    -----
    We don't use sklearn's datasets / huggingfaces' streaming datasets because
    we want to control what happens in our dataset and compare to the model's solution.

    """
    epsilon = np.random.normal(0, 0.05)

    if (value_2 < 0) and (power in [Power.LOW]):
        return round(np.clip(epsilon, 0.0, 1.0), 4)

    if (value_2 > 1.96) and (power == Power.HIGH):
        return round(np.clip(1 - epsilon, 0.0, 1.0), 4)

    sigmoid = 1 / (1 + np.exp(-(value_2**3 + value_1)))
    if power == Power.LOW:
        sigmoid *= 0.25
    elif power == power.MEDIUM:
        sigmoid *= 0.75

    return round(np.clip(sigmoid, 0.0, 1.0), 4)


def generate_signal() -> Signal:
    """
    Generate a single signal.

    This can be modified to generate other signals, etc.

    This is coupled with ``generate_signal_target_variable`` in order to get a target for
    the signal if doing ML/DS training stuff.
    """
    value_1 = random.randint(-20, 20)
    value_2 = round(np.random.normal(), 4)
    value_3 = round(np.random.normal(), 4)
    power = random.choice([Power.LOW, Power.MEDIUM, Power.HIGH])
    dt = (datetime.now() + timedelta(seconds=random.randint(-10, 10))).strftime(
        ("%Y-%m-%d %H:%M:%S")
    )

    heat_index = generate_signal_target_variable(
        value_1=value_1, value_2=value_2, power=power
    )

    return Signal(
        sensor_id=np.random.randint(1, NUM_SENSORS),
        value_1=value_1,
        value_2=value_2,
        value_3=value_3,
        power=power,
        heat_index=heat_index,
        dt=dt,
    )


if __name__ == "__main__":
    import time

    time.sleep(10)

    while True:
        print(generate_signal())
        time.sleep(1)
