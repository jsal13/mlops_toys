"""
The purpose of this file is to create synthetic labels.

This uses the Sensor data.
"""

import numpy as np
import pandas as pd


def make_target(df: pd.DataFrame) -> pd.Series:
    """
    Create a target for the sensor data.

    There are approximately 5% positive labels when this function is used.
    """
    required_cols = ["value_1", "value_2", "value_3", "heat_index", "power"]
    for col in required_cols:
        if col not in df.columns:
            raise KeyError(f"Column {col} required in df.")

    mask_v1_very_high = df["value_1"] == 20
    mask_v2_v3_out_of_sync_on_high_power = (df["value_2"] * df["value_2"] < 0) & (
        df["power"] == "HIGH"
    )
    mask_v1_and_power_out_of_sync = ((df["value_1"] <= -18) & (df["power"] == "HIGH")) | (
        (df["value_1"] >= 18) & (df["power"] == "LOW")
    )

    target = (
        mask_v1_and_power_out_of_sync
        | mask_v1_very_high
        | mask_v2_v3_out_of_sync_on_high_power
    )

    return target.astype("int")


def invert_labels(
    target: pd.Series, val_to_invert: bool = True, percentage: float = 0.1
) -> pd.Series:
    """Invert ``val_to_invert`` to its boolean negation."""
    target = target.astype("bool")

    labels = target.index[target.index == val_to_invert]
    flip_indexes = np.random.choice(
        labels,
        size=int(np.ceil(percentage * len(labels))),
        replace=False,
    )
    target[flip_indexes] = ~target[flip_indexes]

    return target.astype("int")
