FROM python:3.12.0-alpine3.18

ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY requirements.txt ./
RUN pip3 install --disable-pip-version-check \
    --no-cache-dir -r requirements.txt

COPY api.py /app

ENTRYPOINT [ "python", "-m", "uvicorn", "--host", "0.0.0.0", "--port", "4041", "api:api", "--reload" ]