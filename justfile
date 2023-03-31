set shell := ["zsh", "-cu"]

default:
    just --list

run target:
    (cd ./toys/{{target}} && just)

clean target:
    (cd ./toys/{{target}} && just clean)

toys:
    (cd ./toys && ls -1)