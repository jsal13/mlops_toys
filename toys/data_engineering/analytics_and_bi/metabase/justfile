set shell := ["zsh", "-cu"]

default:
  just --list

create_users:
  # If you change the MB port, change it here too.
  MB_HOSTNAME=localhost MB_PORT=3000 ./create_users.sh

up:
  docker compose up --remove-orphans -w

down:
  docker compose down --remove-orphans --volumes

build:
  docker compose build
