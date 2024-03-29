# Grafana

## Last Updated

2023-11-21

## Status

**Not Working.**

If not working:

- [x] In progress

## Description

[Grafana](https://grafana.com/oss/grafana/?plcmt=footer) is an open source data visualization and monitoring solution.  This toy gives a few examples of what it can monitor:

- 

TODO: This is not quite accurate.

```mermaid
graph TD
    A(Grafana):::grafana
    B(Prometheus):::prometheus
    C(PYTHON_API):::python_api
    D(DB):::postgres

    classDef prometheus fill:#660033;
    classDef grafana fill:#006633;
    classDef python_api fill:#994400;
    classDef postgres fill:#003366;

    B---|Pings the <br/>/metrics endpoint|C;
    A---|Connects to|B;
    A---|Connects to|D;
```

## Quickstart

```shell
docker compose \
    -f compose.yaml \
    -f ./example_api/compose.yaml \
    -f ./trino/compose.yaml \
    -f ./trino/pg/compose.yaml \
    -f ./trino/mysql/compose.yaml \
    up

# To tear down
docker compose down --volumes
```

### Sample Queries

```text
rate(http_request_size_bytes_count[20s])
```

## Ports

|          |           |
| -------- | --------- |
| Grafana  | 3000      |
| Postgres | 5432      |
| Mysql    | 3306      |
| Adminer  | 8081 (!!) |
| Trino    | 8080      |

## Credentials

|                  |           |
| ---------------- | --------- |
| Grafana User     | `admin`   |
| Grafana Password | `admin`   |
| Trino User       | `admin`   |
| PG User          | `admin`   |
| PG Password      | `example` |
| PG Database      | `admin`   |
| MySQL User       | `root`    |
| MySQL Password   | `example` |
| MySQL Database   | `test`    |

## Notes

## Resources

## TODO

- Get example queries.
- Get more things to monitor.
- Grafana?  Or maybe in another toy.
- Trino?
