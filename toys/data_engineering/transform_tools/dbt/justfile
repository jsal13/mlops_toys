set shell := ["zsh", "-cu"]

default:
  just --list

run_dag:
	cd dbt_best_practices_dagster && dagster dev

# Uses uv package to pip install.
# Ref: https://github.com/astral-sh/uv?tab=readme-ov-file#highlights
venv: 
  export CONDA_PREFIX="" \
    && python -m venv .venv

  # Unsure why I have to export again...
  export CONDA_PREFIX="" \
    && source .venv/bin/activate \
    && pip install uv \
    && uv pip install -r requirements.txt
