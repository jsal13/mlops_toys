import sys

import typer

from client import RabbitMQClient

app = typer.Typer()


@app.command()
def send(body: str):
    rmqc = RabbitMQClient(exchange="testing", queue_name="testing_queue")
    rmqc.send(body=body)
    rmqc.close()


# Typer defaults to no sub-command if only one command.
@app.command()
def send_upper(body: str):
    rmqc = RabbitMQClient(exchange="testing", queue_name="testing_queue")
    rmqc.send(body=body.upper())
    rmqc.close()


if __name__ == "__main__":
    app()
