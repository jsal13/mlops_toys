import os

import duckdb
import pandas as pd
import plotly.express as px
from dagster import AssetExecutionContext, asset, MetadataValue
from dagster_dbt import DbtCliResource, dbt_assets, get_asset_key_for_model

from .project import jaffle_shop_project

DUCKDB_DATABASE_PATH = jaffle_shop_project.project_dir.joinpath("tutorial.duckdb")
PROJECT_PATH = jaffle_shop_project.project_dir
RAW_DATA_PATH = os.path.join(PROJECT_PATH, "_raw_data")


@asset(compute_kind="python")
def raw_customers(context: AssetExecutionContext) -> None:
    data = pd.read_csv(os.path.join(RAW_DATA_PATH, "raw_customers.csv"))
    connection = duckdb.connect(os.fspath(DUCKDB_DATABASE_PATH))
    connection.execute("create schema if not exists jaffle_shop")
    connection.execute(
        "create or replace table jaffle_shop.raw_customers as select * from data"
    )

    # Log some metadata about the table we just wrote. It will show up in the UI.
    context.add_output_metadata({"num_rows": data.shape[0]})


@dbt_assets(manifest=jaffle_shop_project.manifest_path)
def jaffle_shop_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()


@asset(
    compute_kind="python",
    deps=get_asset_key_for_model([jaffle_shop_dbt_assets], "customers"),
)
def order_count_chart(context: AssetExecutionContext):
    # read the contents of the customers table into a Pandas DataFrame
    connection = duckdb.connect(os.fspath(DUCKDB_DATABASE_PATH))
    customers = connection.sql("select * from customers").df()

    # create a plot of number of orders by customer and write it out to an HTML file
    fig = px.histogram(customers, x="number_of_orders")
    fig.update_layout(bargap=0.2)
    save_chart_path = DUCKDB_DATABASE_PATH.parent.joinpath("order_count_chart.html")
    fig.write_html(save_chart_path, auto_open=True)

    # tell Dagster about the location of the HTML file,
    # so it's easy to access from the Dagster UI
    context.add_output_metadata(
        {"plot_url": MetadataValue.url("file://" + os.fspath(save_chart_path))}
    )
