# Trino

## Last Updated

2023-11-18

## Status

**Not Working.**

If not working:

- [x] In progress

## Description

[Trino](https://trino.io/) is a query engine.  We can query databases (like postgres) and a [variety of other things](https://trino.io/docs/current/connector.html).

(_While it is not technically a DB, I group it in with the DBs for simplicity._)

## Quickstart

```bash
docker compose \
    -f compose.yaml \
    -f ./pg/compose.yaml \
    -f ./mysql/compose.yaml \
    up
```

## Credentials

|                |           |
| -------------- | --------- |
| Trino User     | `admin`   |
| PG User        | `admin`   |
| PG Password    | `example` |
| PG Database    | `admin`   |
| MySQL User     | `root`    |
| MySQL Password | `example` |
| MySQL Database | `test`    |

## Notes

## Resources
