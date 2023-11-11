set shell := ["zsh", "-cu"]

default:
    just toys

toys:
    (cd ./toys && ls -1)