FROM python:3.10-slim AS builder

ENV POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_NO_INTERACTION=1

ENV PATH="$POETRY_HOME/bin:$PATH"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /app

COPY pyproject.toml .

RUN poetry install --no-root --no-ansi --without dev

# ---

FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH" \
    PYTHONPATH="/app/toys:$PYTHONPATH" \
    IN_DOCKER_CONTAINER=true

WORKDIR /app

COPY --from=builder /app/.venv .venv

# Context is ../.., so at the root of the repo.
COPY ./toys/ds_models /app/toys/ds_models

ENTRYPOINT ["/app/.venv/bin/python", "-m", "uvicorn", "--host", "0.0.0.0", "--port", "4042", "toys.ds_models.sensor_event_model.api:api", "--reload"]
