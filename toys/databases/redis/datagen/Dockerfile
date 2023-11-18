FROM python:3.10-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /data

COPY requirements.txt ./
COPY app.py .

RUN pip3 install --disable-pip-version-check \
    --no-cache-dir -r requirements.txt

CMD ["python", "/data/app.py"]
