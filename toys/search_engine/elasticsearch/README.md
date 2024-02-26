# Elasticsearch

> [!WARNING]  
> Before running this docker compose, please read <https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#_start_a_single_node_cluster>:
>
> "If using Docker Desktop, make sure to allocate at least 4GB of memory. You can adjust memory usage in Docker Desktop by going to Settings > Resources."

## Last Updated

2024-02-21

## Status

**Not Working.**

If not working:

- [ ] Error

- [x] In progress

## Description

Elasticsearch toy, uses version 8.12.1 (see `.env`).

## Quickstart

```shell
cp .env.example .env
docker compose up
```

## Credentials

|             |                 |
| ----------- | --------------- |
| ES User     | `elastic`       |
| ES Password | `password`      |
| KB User     | `kibana_system` |
| KB Password | `password`      |

## Notes

## Resources
