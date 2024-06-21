# REF: https://github.com/AntonFriberg/dagster-project-example/blob/6d23bf1186afef35e30819a94c73ea540b6f1b35/docker/Dockerfile

FROM python:3.10-slim

# Change working directory
WORKDIR /usr/src/app
ENV DAGSTER_HOME=/usr/src/app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy source code
COPY docker/dagster.yaml workspace.yaml ./
COPY dagster ./dagster

CMD ["dagit", "-w", "workspace.yaml", "-h", "0.0.0.0", "-p", "3000"]