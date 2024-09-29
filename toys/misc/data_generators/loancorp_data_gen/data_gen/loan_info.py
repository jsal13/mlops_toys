import random
from datetime import UTC, date, datetime, timedelta
from decimal import Decimal

from attrs import define
from base_table import BaseTable
from constants import DEFAULT_LOANS_MAX_NUMBER
from faker import Faker


@define
class LoanInfoRow(BaseTable):
    """Generate row of daily record of a loan's info, status, values, etc."""

    # ids
    loan_id: int
    loan_status_id: int
    lender_id: int

    # dates
    recorded_at: datetime
    followup_on: date
    previous_payment_on: date
    next_payment_on: date

    # numerics
    due_interest_amount: Decimal
    due_principal_amount: Decimal
    due_escrow_amount: Decimal
    due_fees_amount: Decimal
    previous_payment_amount: Decimal
    next_payment_amount: Decimal
    credit_limit_amount: Decimal
    number_of_unique_delinquencies: int

    @classmethod
    def generate_random(
        cls,
        loan_id: int,
    ) -> "LoanInfoRow":
        """Generate a random LoanInfoRow object."""
        fake = Faker()

        recorded = fake.date_time()
        next_payment_on = fake.date_between_dates(
            recorded + timedelta(days=10), datetime.now(UTC)
        )
        previous_payment_on = fake.date_between_dates(
            recorded - timedelta(days=random.randint(7, 70)), recorded
        )
        followup_on = fake.date_between_dates(previous_payment_on, next_payment_on)

        return cls(
            loan_id=loan_id,
            loan_status_id=random.randint(0, 2),
            lender_id=random.randint(0, 5),
            # dates
            recorded_at=recorded,
            followup_on=followup_on,
            previous_payment_on=previous_payment_on,
            next_payment_on=next_payment_on,
            # numerics
            due_interest_amount=round(10 ** random.randint(1, 5) * random.random(), 2),
            due_principal_amount=round(10 ** random.randint(1, 5) * random.random(), 2),
            due_escrow_amount=round(10 ** random.randint(1, 5) * random.random(), 2),
            due_fees_amount=round(10 ** random.randint(1, 5) * random.random(), 2),
            previous_payment_amount=round(
                10 ** random.randint(1, 5) * random.random(), 2
            ),
            next_payment_amount=round(10 ** random.randint(2, 4) * random.random(), 2),
            credit_limit_amount=round(10 ** random.randint(3, 5) * random.random(), 0),
            number_of_unique_delinquencies=random.randint(0, 10),
        )


@define
class LoanInfoRows(BaseTable):
    """Generate rows of daily record of a loan's info, status, values, etc."""

    loan_info_rows: list[LoanInfoRow]

    @classmethod
    def generate_random(
        cls, max_num_loans: int = DEFAULT_LOANS_MAX_NUMBER
    ) -> "LoanInfoRows":
        """Generate LoanInfo rows."""
        loan_info_rows: list[LoanInfoRow] = [
            LoanInfoRow.generate_random(loan_id=_id)
            for _id in range(0, max_num_loans + 1)
        ]
        return cls(loan_info_rows=loan_info_rows)
