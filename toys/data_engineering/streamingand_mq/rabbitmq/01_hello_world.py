import sys
import os

import typer

from client import RabbitMQClient

app = typer.Typer()


@app.command()
def send(body: str):
    rmqc = RabbitMQClient(exchange="testing", queue_name="testing_queue")
    rmqc.send(body=body)
    rmqc.close()


@app.command()
def receive() -> None:
    rmqc = RabbitMQClient(exchange="testing", queue_name="testing_queue")
    try:
        rmqc.consume()
    except KeyboardInterrupt:
        print("Interrupted")
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)


# Typer defaults to no sub-command if only one command.
@app.command()
def send_upper(body: str):
    rmqc = RabbitMQClient(exchange="testing", queue_name="testing_queue")
    rmqc.send(body=body.upper())
    rmqc.close()


if __name__ == "__main__":
    app()
