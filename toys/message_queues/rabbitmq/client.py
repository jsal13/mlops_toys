from attrs import define, field
import pika

from pika.connection import Parameters, Connection  # types
from pika.channel import Channel  # types
from pika import spec

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
        queue = self.channel.queue_declare(queue=self.queue_name)

        self.channel.exchange_declare(exchange=self.exchange, exchange_type="fanout")

        # Bind the channels.
        self.channel.queue_bind(exchange=self.exchange, queue=self.queue_name)

    def send(self, body: str) -> None:
        self.channel.basic_publish(
            exchange=self.exchange, routing_key=self.queue_name, body=body
        )
        print(f" [x] Sent '{body}'")

    def consume(self) -> None:
        self.channel.basic_consume(
            queue=self.queue_name, auto_ack=True, on_message_callback=self.callback
        )
        self.channel.start_consuming()
        print(" [*] Waiting for messages. To exit press CTRL+C")

    def close(self) -> None:
        """Close connection."""
        self.connection.close()

    def callback(
        self, ch: Channel, method: spec.Basic.Deliver, properties, body: str
    ) -> None:
        print(f" [x] Received {body}")
