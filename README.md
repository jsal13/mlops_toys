# MLOps Toys

A collection of MLOps Pipeline toys (templates for how to do things) for creating standard pipelines.

Most of these will be contained to a single folder.  The README in that folder will explain what the pipeline is.

## Current Toys

- :white_check_mark: Working.
- :construction: In Progress.
- :x: Not Working.

---

- :white_check_mark: apis :: fastapi_example
- :white_check_mark: credential_mgmt :: sops
- :white_check_mark: data_build_tools :: dbt_pg
- :white_check_mark: data_frontend :: streamlit
- :white_check_mark: data_generators :: clf_log_generator
- :white_check_mark: data_generators :: flog
data_lake :: iceberg
- :white_check_mark: data_logging :: whylogs
data_platforms :: mlflow
- :white_check_mark: data_processing :: pyspark
databases :: duckdb
- :white_check_mark: databases :: mysql
- :white_check_mark: databases :: pg
- :white_check_mark: databases :: redis
databases :: trino
- :white_check_mark: doc_styles :: diataxis
- :white_check_mark: ds_models :: utils
- :white_check_mark: graphql :: strawberry_graphql
- :construction: local_dev :: localstack
- :construction: logging :: grafana
- :construction: logging :: prometheus
- :white_check_mark: message_queues :: rabbitmq
- :white_check_mark: model_explanation :: shap
- :white_check_mark: orchestration_tools :: airflow
- :white_check_mark: search_engine :: elasticsearch
- :white_check_mark: streaming :: kafka_consumer_producer
- :white_check_mark: streaming :: kinesis_streaming
- :white_check_mark: terraform_template :: \_template

## Making a New Toy

Use:

```shell
just generate toy_name
```

Where `toy_name` is the name of the toy.  It will make a folder in root.  Move it to where it should be.
