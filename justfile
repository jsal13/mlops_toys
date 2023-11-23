set shell := ["zsh", "-cu"]

default:
    just toys

toys:
    du -d 3 | sed -nE 's/.\/toys\/(.*)\/(.*)/\1 \2/p' | awk '{ print $2 " :: "  $3}' | sort