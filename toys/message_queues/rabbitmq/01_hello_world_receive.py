import sys
import os

from client import RabbitMQClient

if __name__ == "__main__":
    rmqc = RabbitMQClient(exchange="testing", queue_name="testing_queue")
    try:
        rmqc.consume()
    except KeyboardInterrupt:
        print("Interrupted")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
