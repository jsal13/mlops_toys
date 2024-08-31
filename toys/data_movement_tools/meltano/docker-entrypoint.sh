#!/bin/bash

## EXTRACTORS
# Install github extractor
meltano install extractor tap-github 
meltano select tap-github commits "*"
## LOADERS
# Add a jsonl loader.
meltano install loader target-jsonl

# Add a postgres loader.
meltano add loader target-postgres --variant=meltanolabs

# Configure postgres loader.
meltano config target-postgres set user admin
meltano config target-postgres set password example
meltano config target-postgres set database postgres
meltano config target-postgres set add_record_metadata True

# Note: the host in dockercompose is `db`.
meltano config target-postgres set host db

## DBT
# Add the dbt-postgres utility.
meltano add utility dbt-postgres

# Configure dbt-postgres utility.
meltano config dbt-postgres set host db
meltano config dbt-postgres set port 5432
meltano config dbt-postgres set user admin
meltano config dbt-postgres set password example
meltano config dbt-postgres set dbname postgres
meltano config dbt-postgres set schema analytics


## RUNNING MELTANO
# Run the tap-github on the account in meltano.yml with jsonl output.
# meltano run tap-github target-jsonl

# Run the tap-githob on the acct in meltano.yml with output into pg.
meltano run --full-refresh tap-github target-postgres

# Run the dbt model stuff.
meltano invoke dbt-postgres:run

## CLEANUP

# Otherwise it becomes owned by ROOT with no permissions for anyone else.
chmod 777 meltano.yml