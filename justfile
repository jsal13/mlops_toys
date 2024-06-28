set shell := ["zsh", "-cu"]

default:
    just toys

toys:
    du -d 3 | sed -nE 's/.\/toys\/(.*)\/(.*)/\1 \2/p' | awk '{ print $2 " :: "  $3}' | sort

generate name:
    @echo 'Generating ./{{name}} folder...'
    @cp -R ./_toy_template './{{name}}'
    @sed -i -e 's/TOY_NAME/{{name}}/g' './{{name}}/README.md'