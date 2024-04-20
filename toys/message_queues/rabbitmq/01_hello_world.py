from client import RabbitMQClient

rmqc = RabbitMQClient()
rmqc.send(body="Hello Cos!")
rmqc.close()
