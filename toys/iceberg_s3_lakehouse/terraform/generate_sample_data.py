import os

import pandas as pd
import numpy as np
from faker import Faker


def generate_sample_data(
    num_rows: int = 100,
    num_files=10,
    output_dir: str = f"./sample_data/",
) -> None:
    """Generate sample data in Parquet format."""

    fake = Faker()
    total_vals = num_files * num_rows
    # COLUMNS = ["id", "name", "invoice_amt", "date"]

    ids = np.arange(total_vals)
    names = np.array([fake.name() for _ in range(total_vals)])
    invoice_amt = np.random.randint(0, 10000, total_vals)
    dates = np.array([fake.date() for _ in range(total_vals)])

    data = np.vstack((ids, names, invoice_amt, dates))
    data_chunks = [
        data[:, (num_rows * idx) : ((num_rows * idx) + num_rows)]
        for idx in range(num_files)
    ]
    for n, chunk in enumerate(data_chunks):
        df = pd.DataFrame(
            {
                "id": chunk[0, :],
                "name": chunk[1, :],
                "invoice_amt": chunk[2, :],
                "date": chunk[3, :],
            }
        )
        df = df.astype({"id": "int32", "invoice_amt": "int32"})
        df.to_parquet(os.path.join(output_dir, f"data_{n:0>2}.parquet"), index=False)


if __name__ == "__main__":
    generate_sample_data(
        num_rows=100, num_files=10, output_dir="./sample_data/"
    )
