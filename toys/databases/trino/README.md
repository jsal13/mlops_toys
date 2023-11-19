# Trino

## Last Updated

2023-11-18

## Status

**Not Working.**

If not working:

- [x] In progress

## Description

Trino is a query engine that is made for taking data from different sources and joining all of that together.  _While it is not technically a DB, I group it in with the DBs for simplicity._

## Quickstart

```bash
docker compose \
    -f compose.yaml \
    -f ./pg/compose.yaml \
    up
```

## Credentials

|             |           |
| ----------- | --------- |
| Trino User  | `admin`   |
| PG User     | `admin`   |
| PG Password | `example` |
| PG Database | `admin`   |

## Notes

## Resources
