# Airflow

## Status

**Working.**

## Description

Spins up Airflow.

## Quickstart

```shell
# First run this command!
mkdir -p ./dags ./logs ./plugins ./config
echo -e "AIRFLOW_UID=$(id -u)" > .env

# Then...
docker compose --profile flower up
```

- [Flower](https://github.com/mher/flower) is at <http://localhost:5555/>.
- Web UI is at <http://localhost:8080/>.
- PG is at <http://localhost:5432>.
- Redis is at <http://localhost:6379>.

## Credentials

|             |           |
| ----------- | --------- |
| AF User     | `airflow` |
| AF Password | `airflow` |
| PG User     | `airflow` |
| PG Password | `airflow` |
| PG Database | `airflow` |

## Notes

## Resources
