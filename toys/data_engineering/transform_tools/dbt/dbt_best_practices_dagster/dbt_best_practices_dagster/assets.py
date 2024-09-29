from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

from .project import dbt_best_practices_project


@dbt_assets(manifest=dbt_best_practices_project.manifest_path)
def dbt_best_practices_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
    