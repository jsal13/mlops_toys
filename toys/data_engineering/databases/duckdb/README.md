# DuckDB Database

## Last Updated

2023-12-30

## Status

**Working.**

## Description

An example duckdb in-process database with jaffie-data tables.

## Quickstart

> [!NOTE]  
> You will need to install jafgen if you want to use the sample data in the Jupyter notebook.  Do this with `pip install jafgen`.

1. To install duckdb, use `pip install duckdb`.

2. Run `just make-data` to make data **OR** use the following command in the `./data` folder:

    ```shell
    jafgen 1 \
        && mv jaffle-data/* . \
        && rm -r jaffle-data
    ```

3. Open the Jupyter notebook and run the commands in there for examples.

## Credentials

## Notes

## Resources
