from dagster import Definitions
from dagster_dbt import DbtCliResource
from .assets import music_o_set_dbt_assets
from .project import music_o_set_project
from .schedules import schedules

defs = Definitions(
    assets=[music_o_set_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=music_o_set_project),
    },
)