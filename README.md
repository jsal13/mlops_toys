# MLOps Toys

A collection of MLOps Pipeline toys (templates for how to do things) for creating standard pipelines.

Most of these will be contained to a single folder.  The README in that folder will explain what the pipeline is.

## Current Toys

- :white_check_mark: Working.
- :construction: In Progress.
- :x: Not Working.

- :white_check_mark: apis :: fastapi_example
- :white_check_mark: credential_mgmt :: sops
- :white_check_mark: data_build_tools :: dbt_pg
- :white_check_mark: data_generators :: clf_log_generator
- :white_check_mark: data_generators :: flog
- :white_check_mark: data_platforms :: mlflow
- :white_check_mark: data_processing :: pyspark
- :white_check_mark: databases :: mysql
- :white_check_mark: databases :: pg
- :white_check_mark: databases :: redis
- :white_check_mark: databases :: trino
- :white_check_mark: doc_styles :: diataxis
- :x: ds_models :: sensor_event_model
- :x: ds_models :: utils
- :white_check_mark: graphql :: strawberry_graphql
- :construction: local_dev :: localstack
- :construction: logging :: grafana
- :construction: logging :: prometheus
- :white_check_mark: orchestration_tools :: airflow
- :white_check_mark: streaming :: kafka_consumer_producer
- :white_check_mark: streaming :: kinesis_streaming
- :white_check_mark: terraform_template :: \_template

## Making a New Toy

The only requirements are:

- The folder must contain a README made from `README.md.tmpl`.

- The folder must have one of the following (if applicable):

  - Dockerfiles or a docker-compose.yaml

  - Terraform-related files

  - Helm-related files

## To Create

Things I need to create or migrate.

- Trino (w/ Postgres + maybe minio)
- Grafana
- MLFlow basic
- Flyte (?) basic
- Prefect (?)
- Airflow (?)
