import os
import shutil
from datetime import datetime, timedelta
from pathlib import Path

from typing import TYPE_CHECKING

import boto3
from boto3.session import Session
import polars as pl
import numpy as np

if TYPE_CHECKING:
    from mypy_boto3_s3.client import S3Client
    from mypy_boto3_s3.service_resource import Bucket

DATA_FOLDER = Path(__file__).parent.resolve().joinpath("data")
BUCKET_NAME = "test-bucket"
LOCALSTACK_ENDPOINT_URL = "http://localstack:4566"


def create_data_folder(path: str = DATA_FOLDER) -> None:
    shutil.rmtree(path=path, ignore_errors=True)
    os.mkdir(path=path)


def generate_sample_parquet_data(path: str = DATA_FOLDER, n: str = 1) -> Path:
    """Generate random parquet data and return the filename."""
    start_dt = datetime(2023, 1, 1) + timedelta(days=n)
    end_dt = start_dt + timedelta(hours=23, minutes=59)

    dts = pl.datetime_range(start_dt, end_dt, "1s", eager=True).alias("dt").to_frame()
    n_rows = len(dts)
    values = pl.from_numpy(data=np.random.rand(n_rows, 3), schema=["a", "b", "c"])
    df = pl.concat([dts, values], how="horizontal")

    output_file = Path(path).joinpath(f"{start_dt.strftime('%Y%m%d')}.parquet")
    df.write_parquet(output_file)
    return output_file


def create_and_populate_s3_bucket() -> None:
    """Create and populate an S3 bucket.  Requires localstack to be running."""

    # Create s3 client.
    s3_client: "S3Client" = boto3.client(
        "s3",
        endpoint_url=LOCALSTACK_ENDPOINT_URL,
        aws_access_key_id="test",
        aws_secret_access_key="test",
    )
    s3_client.create_bucket(Bucket=BUCKET_NAME)

    # Create data.
    create_data_folder()
    for n in range(20):
        output_file_path = generate_sample_parquet_data(n=n)
        file_name = output_file_path.name

        s3_client.upload_file(
            Filename=str(output_file_path),
            Bucket=BUCKET_NAME,
            Key=file_name,
        )


if __name__ == "__main__":
    import time

    time.sleep(10)  # Lets the localstack startup.
    create_and_populate_s3_bucket()
