FROM python:3.12.0-alpine3.18

ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY requirements.txt ./
RUN pip3 install --disable-pip-version-check \
    --no-cache-dir -r requirements.txt

COPY app.py /app

ENTRYPOINT ["strawberry", "server", "app"]