# Kafka Consumer / Producer

## Last Updated

2023-11-18

## Status

**Working.**

## Description

Kafka consumer + producer pipeline.

## Quickstart

```shell
docker compose up
```

### Useful Commands

While on the host machine (not in any docker container) while docker compose is up:

```shell
curl http://localhost:8083/connector-plugins | jq '.[].class' # Gets all installed connectors.
curl http://localhost:8083/connectors | jq # Active connectors.
curl -X POST http://localhost:8083/connectors -d "@datagen-orders-config.json" -H "Content-Type: application/json" # Installs the associated connector.
curl http://localhost:8083/connectors/datagen-orders/status  # Get connector status.
curl -X PUT http://localhost:8083/connectors/datagen-orders/pause
curl -X PUT http://localhost:8083/connectors/datagen-orders/resume
curl -X DELETE http://localhost:8083/connectors/datagen-orders
```

While exec'd into the Kafka broker:

```shell
# Test console consumer...
kafka-console-consumer --bootstrap-server localhost:9092 \
    --topic orders_json --property print.key=true
```

## Credentials

## Notes

## References

- [Kafka Connect Datagen Dockerhub](https://hub.docker.com/r/cnfldemos/kafka-connect-datagen)
- <https://github.com/confluentinc/avro-random-generator#schema-annotations>
- <https://hub.docker.com/r/debezium/postgres>
- <https://medium.com/high-alpha/data-stream-processing-for-newbies-with-kafka-ksql-and-postgres-c30309cfaaf8>
