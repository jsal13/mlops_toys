# Kafka-Prefect-Postgres Pipeline

## Description

### Architecture

```mermaid
graph TB;
  A>Incoming Data];
  B[Kafka];
  C{{Prefect}};
  D[(Postgres)];
  E[DS Model];
  F[MLFlow];

  A-->B;
  B-->C;
  C-->|Schedules Batch Jobs|D
  C-->|Schedules Model Runs|E
  E-.->|Sends Metrics, etc.|F
  D-.-|
    
```

## Quickstart

**To run**:

```shell
just run
```

**To clean up**:

```shell
just clean
```

## Notes

- Remember to start a work-pool and agent.
  - For example, for work-pool `test` you can start an agent in the following way:

  ```shell
  prefect work-pool create test-pool
  prefect agent start -p 'test-pool'
  ```
