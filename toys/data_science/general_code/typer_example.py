import typer

app = typer.Typer()


@app.command()
def hello() -> None:
    person_name = typer.prompt("What's your name?")
    print(f"Hello {person_name}")


@app.command()
def goodbye(name: str, formal: bool = False) -> None:
    if formal:
        print("Goodbye, You Prince of New England.")
    else:
        print(f"Bye, {name}!")


if __name__ == "__main__":
    app()
