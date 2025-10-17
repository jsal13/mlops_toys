FROM python:3.10-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /data

COPY requirements.txt ./
COPY init.sql ./

# Creates jaffle data in /data folder.
RUN pip3 install --disable-pip-version-check \
    --no-cache-dir -r requirements.txt

RUN jafgen 1 \
    && mv jaffle-data/* . \
    && rm -r jaffle-data
