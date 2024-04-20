import 

rmqc = RabbitMQClient()
rmqc.send(body="Hello Cos!")
rmqc.close()
