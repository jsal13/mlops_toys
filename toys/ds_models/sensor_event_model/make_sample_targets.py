"""
The purpose of this file is to create synthetic labels.

This uses the Sensor data.
"""

import pandas as pd


def make_target(df: pd.DataFrame) -> pd.Series:
    """
    Create a target for the sensor data.

    There are approximately 5% positive labels when this function is used.
    """
    required_cols = ["value_1", "value_2", "value_3", "heat_index", "power"]
    for col in required_cols:
        if not col in df.columns:
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

    target = target.astype("int")

    return target
