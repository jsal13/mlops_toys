from pathlib import Path

from dagster_dbt import DbtProject

music_o_set_project = DbtProject(
    project_dir=Path(__file__).joinpath("..", "..", "..").resolve(),
    packaged_project_dir=Path(__file__).joinpath("..", "..", "dbt-project").resolve(),
)
music_o_set_project.prepare_if_dev()