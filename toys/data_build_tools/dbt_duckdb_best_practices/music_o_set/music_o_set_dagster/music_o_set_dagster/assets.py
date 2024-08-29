from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

from .project import music_o_set_project


@dbt_assets(manifest=music_o_set_project.manifest_path)
def music_o_set_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
    