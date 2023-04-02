# Kafka-Prefect-Postgres Pipeline

## Description

### Architecture

```mermaid
graph LR;
  A>Incoming Data];
  B[Kafka];
  C{{Prefect}};
  D[(Postgres)];

  A-->B;
  B-->C;
  C-->|Schedules Batch Jobs|D
    
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
