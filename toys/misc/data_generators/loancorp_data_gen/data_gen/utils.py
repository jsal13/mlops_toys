import os
from collections.abc import Sequence

import duckdb
import pandas as pd
from attrs import asdict
from base_table import BaseTable
from constants import DEFAULT_OUTPUT_LOC


def to_csv(payload: dict[str, pd.DataFrame], output_dir: str = "./data/") -> None:
    """Convert all tables to CSV."""
    for val, df in payload.items():
        df.to_csv(os.path.join(output_dir, val) + ".csv", index=False)


def to_duckdb(
    payload: dict[str, pd.DataFrame], output_loc: str = DEFAULT_OUTPUT_LOC
) -> None:
    """Convert all tables into DuckDB tables."""
    with duckdb.connect(output_loc) as con:
        for val, df in payload.items():  # noqa: B007
            con.sql(f"CREATE TABLE {val} AS SELECT * FROM df")

def to_pandas(obj: Sequence[BaseTable]) -> pd.DataFrame:
    """Convert an `attrs``-defined class obj into pandas."""
    dict_obj = [asdict(row) for row in obj]
    df_obj = pd.DataFrame(dict_obj)
    return df_obj
