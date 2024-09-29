import random

from attrs import define
from base_table import BaseTable
from constants import DEFAULT_CUSTOMER_NUMBER
from faker import Faker


@define
class Customer(BaseTable):
    """Customer Information."""

    # ids
    customer_id: int
    # strings
    name: str
    address: str
    ssn: str
    # numerics
    age: int

    @classmethod
    def generate_random(cls, customer_id: int) -> "Customer":
        """Generate a random Customer object."""
        fake = Faker()

        return cls(
            customer_id=customer_id,
            name=fake.name(),
            address=fake.address().replace("\n", " "),
            ssn=fake.ssn(),
            age=random.randint(21, 100),
        )


@define
class Customers(BaseTable):
    """Generate list of ``Customer`` objects."""

    customer_rows: list[Customer]

    @classmethod
    def generate_random(
        cls, num_customers: int = DEFAULT_CUSTOMER_NUMBER
    ) -> "Customers":
        """Generate many ``Customer`` objects."""
        customer_rows = [
            Customer.generate_random(customer_id=_id)
            for _id in range(0, num_customers + 1)
        ]
        return Customers(customer_rows=customer_rows)
