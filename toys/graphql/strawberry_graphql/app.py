from faker import Faker
import strawberry

faker = Faker()


@strawberry.type
class User:
    name: str
    address: str


def generate_users() -> list[User]:
    """Generate a list of ``User``s."""
    return [User(name=faker.name(), address=faker.address()) for _ in range(10)]


@strawberry.type
class Query:
    users: list[User] = strawberry.field(resolver=generate_users)


schema = strawberry.Schema(query=Query)
