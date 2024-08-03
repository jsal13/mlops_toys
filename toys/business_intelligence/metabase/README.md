# Metabase with Postgres

## Last Updated

2024-08-03

## Status

**Not Working.**

## Description

An example of metabase with postgres database.  Uses jaffie-data tables.

## Quickstart

```shell
# Run the metabase compose.
docker compose up

# After it's up, create sample users with its API.
just create-users 
```

Metabase is at <http://localhost:3000>.  WYou're able to use adminer to see the DB at <http://localhost:8080/>.  You can connect to the PG DB via port 5432.

## Credentials

|             |                        |
| ----------- | ---------------------- |
| MB User     | `admin@metabase.local` |
| MB Pass     | `example`              |
| PG User     | `admin`                |
| PG Password | `example1234`          |

## Notes

## Resources
