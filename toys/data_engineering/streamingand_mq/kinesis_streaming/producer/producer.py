"""
Reference:
https://github.com/awsdocs/aws-doc-sdk-examples/blob/fe9aa98b89b092440eee51ed9bc54504b007541d/python/example_code/kinesis/streams/kinesis_stream.py#L44
"""

import json
import logging
from typing import Any

from botocore.exceptions import ClientError
from boto3 import client

logger = logging.getLogger(__name__)


class KinesisStream:
    """Encapsulates a Kinesis stream."""

    def __init__(self, kinesis_client):
        """
        Args
        ----
        kinesis_client: A Boto3 Kinesis client.
        """
        self.kinesis_client = kinesis_client
        self.name = None
        self.details = None
        self.stream_exists_waiter = kinesis_client.get_waiter("stream_exists")

    def _clear(self):
        """
        Clears property data of the stream object.
        """
        self.name = None
        self.details = None

    def arn(self):
        """
        Gets the Amazon Resource Name (ARN) of the stream.
        """
        return self.details["StreamARN"]

    def create(self, name: str, wait_until_exists: bool = True):
        """
        Creates a stream.

        Args
        ----
        name (str): The name of the stream.
        wait_until_exists (bool): When True, waits until the service reports that
            the stream exists, then queries for its metadata.
        """
        try:
            self.kinesis_client.create_stream(StreamName=name, ShardCount=1)
            self.name = name
            print(f"Created stream {name}.", flush=True)
            if wait_until_exists:
                print("Waiting until exists.", flush=True)
                self.stream_exists_waiter.wait(StreamName=name)
                self.describe(name)
        except ClientError:
            print("Couldn't create stream {name}.", flush=True)
            raise

    def describe(self, name: str) -> Any:
        """
        Gets metadata about a stream.

        Args
        ----
        name (str): The name of the stream.

        Returns
        -------
        Metadata about the stream.
        """
        try:
            response = self.kinesis_client.describe_stream(StreamName=name)
            self.name = name
            self.details = response["StreamDescription"]
            print(f"Got stream {name}.", flush=True)
        except ClientError:
            logger.exception(f"Couldn't get {name}.", flush=True)
            raise
        else:
            return self.details

    def delete(self):
        """
        Deletes a stream.
        """
        try:
            self.kinesis_client.delete_stream(StreamName=self.name)
            self._clear()
            print(f"Deleted stream {self.name}.", flush=True)
        except ClientError:
            print(f"Couldn't delete stream {self.name}.", flush=True)
            raise

    def put_record(self, data: dict[Any, Any], partition_key: str) -> Any:
        """
        Puts data into the stream. The data is formatted as JSON before it is passed
        to the stream.

        Args
        ----
        data (dict[Any, Any]): The data to put in the stream.
        partition_key (str): The partition key to use for the data.

        Returns
        -------
        Metadata about the record, including its shard ID and sequence number.
        """
        try:
            response = self.kinesis_client.put_record(
                StreamName=self.name, Data=json.dumps(data), PartitionKey=partition_key
            )
            print(f"Put record in stream {self.name}.", flush=True)
            print(f"{response}", flush=True)
        except ClientError:
            print(f"Couldn't put record in stream {self.name}.", flush=True)
            raise
        else:
            return response

    # def get_records(self, max_records):
    #     """
    #     Gets records from the stream. This function is a generator that first gets
    #     a shard iterator for the stream, then uses the shard iterator to get records
    #     in batches from the stream. Each batch of records is yielded back to the
    #     caller until the specified maximum number of records has been retrieved.

    #     :param max_records: The maximum number of records to retrieve.
    #     :return: Yields the current batch of retrieved records.
    #     """
    #     try:
    #         response = self.kinesis_client.get_shard_iterator(
    #             StreamName=self.name,
    #             ShardId=self.details["Shards"][0]["ShardId"],
    #             ShardIteratorType="LATEST",
    #         )
    #         shard_iter = response["ShardIterator"]
    #         record_count = 0
    #         while record_count < max_records:
    #             response = self.kinesis_client.get_records(
    #                 ShardIterator=shard_iter, Limit=10
    #             )
    #             shard_iter = response["NextShardIterator"]
    #             records = response["Records"]
    #             print("Got %s records.", len(records))
    #             record_count += len(records)
    #             yield records
    #     except ClientError:
    #         logger.exception("Couldn't get records from stream %s.", self.name)
    #         raise


if __name__ == "__main__":
    import time
    import requests

    STREAM_NAME = "test"
    PARTITION_KEY = "1234"
    REGION = "us-east-1"
    HTTP_DATA_STREAM_URI = "http://stream_gen:8001/stream_data"

    kinesis_client = client("kinesis", region_name=REGION)
    kinesis_steam_example = KinesisStream(kinesis_client=kinesis_client)

    try:
        kinesis_steam_example.describe(name=STREAM_NAME)
        kinesis_steam_example.name = STREAM_NAME
    except ClientError:
        kinesis_steam_example.create(STREAM_NAME)

    for i in range(1000):
        resp = requests.get(HTTP_DATA_STREAM_URI)
        kinesis_steam_example.put_record(data=resp.json(), partition_key=PARTITION_KEY)
        time.sleep(0.05)
