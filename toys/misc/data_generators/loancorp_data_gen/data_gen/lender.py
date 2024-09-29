from attrs import define
from base_table import BaseTable
from faker import Faker


@define
class Lender(BaseTable):
    """Lookup for a Lender."""

    lender_id: int
    lender_name: str


@define
class Lenders(BaseTable):
    """Lookup for Lenders."""
    lender_rows: list[Lender]

    @classmethod
    def generate_random(cls, num_lenders: int = 5) -> 'Lenders':
        """Generate random companies to be lenders."""
        fake = Faker()
        lender_rows: list[Lender] = [
            Lender(lender_id=idx, lender_name=fake.company())
            for idx in range(num_lenders)
        ]
        return cls(lender_rows=lender_rows)
