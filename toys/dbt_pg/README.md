# Starter Project

## QUICKSTART

First run `docker compose up` to create a postgres db.

```shell
cd seeds && jafgen --years 1  # Generate data.
dbt seed  # Runs seeding.
dbt test  # Runs tests.
dbt debug  # Checks configs.
dbt run  # Runs model creation, etc.

dbt docs generate
dbt docs serve --port 8001
```
