from attrs import define, field
import pika

from pika.connection import Parameters, Connection  # types
from pika.channel import Channel  # types

QUEUE_NAME = "hello"
CONN_PARAMS: Parameters = pika.ConnectionParameters("localhost")
EXCHANGE_NAME = ""  # Default exchange.


@define
class RabbitMQClient:
    connection: Connection = field(
        default=pika.BlockingConnection(CONN_PARAMS), repr=False
    )
    queue_name: str = field(default=QUEUE_NAME)
    exchange: str = field(default="")
    channel: Channel = field(init=False, repr=False)

    def __attrs_post_init__(self):
        self.channel = self.connection.channel()

        # Makes queue if needed.  Like "CREATE TABLE IF NOT EXISTS".
        self.channel.queue_declare(queue=QUEUE_NAME)

    def send(self, body: str) -> None:
        self.channel.basic_publish(
            exchange=self.exchange, routing_key=self.queue_name, body=body
        )

        print(f" [x] Sent '{body}'")

    def close(self) -> None:
        """Close connection."""
        self.connection.close()
