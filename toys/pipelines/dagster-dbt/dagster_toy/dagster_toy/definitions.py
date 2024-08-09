from dagster import Definitions
from dagster_dbt import DbtCliResource
from .assets import jaffle_shop_dbt_assets, raw_customers, order_count_chart
from .project import jaffle_shop_project
from .schedules import schedules

defs = Definitions(
    assets=[raw_customers, jaffle_shop_dbt_assets, order_count_chart],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=jaffle_shop_project),
    },
)
