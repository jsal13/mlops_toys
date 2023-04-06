set shell := ["zsh", "-cu"]

default:
    just --list

run target:
    (cd {{target}} && just run)

clean target:
    (cd {{target}} && just clean)

toys:
    (cd ./toys && ls -1)