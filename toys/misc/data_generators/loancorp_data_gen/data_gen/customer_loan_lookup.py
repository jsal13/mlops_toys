import random

from attrs import define
from base_table import BaseTable
from constants import DEFAULT_CUSTOMER_NUMBER, DEFAULT_LOANS_MAX_NUMBER


@define
class CustomerLoanLookup(BaseTable):
    """Lookup for a customer-loan pairing using only IDs of each."""

    customer_loan_associations: list[dict[str, int]]  # id-to-id

    @classmethod
    def generate_random(
        cls,
        num_customers: int = DEFAULT_CUSTOMER_NUMBER,
        num_loans: int = DEFAULT_LOANS_MAX_NUMBER,
    ) -> "CustomerLoanLookup":
        """Associate (randomly) Customers with Loans in a CustomerLoanLookup."""
        loan_ids = list(range(num_loans))

        customer_loan_associations: list[dict[str, int]] = []
        for customer_id in range(num_customers):
            num_loans_per_current_customer = random.choices(
                [1, 2, 3, 4, 5], weights=[0.7, 0.2, 0.05, 0.04, 0.01]
            )[0]
            for _ in range(num_loans_per_current_customer):
                loan_id = loan_ids.pop(random.randint(0, len(loan_ids) - 1))
                customer_loan_associations.append(
                    {"loan_id": loan_id, "customer_id": customer_id}
                )

        return cls(customer_loan_associations=customer_loan_associations)
