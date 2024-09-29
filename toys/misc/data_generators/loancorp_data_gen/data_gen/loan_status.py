from attrs import define
from base_table import BaseTable
from constants import LOAN_STATUSES


@define
class LoanStatus(BaseTable):
    """Lookup for a Loan Status."""

    loan_status_id: int
    loan_status_value: str

@define
class LoanStatuses(BaseTable):
    """Lookup for Loan Statuses."""
    loan_status_rows: list[LoanStatus]

    @classmethod
    def generate_random(cls) -> 'LoanStatuses':
        """Generate a list of ``LoanStatus`` objects."""
        loan_status_rows = [
            LoanStatus(loan_status_id=_id, loan_status_value=value)
            for _id, value in enumerate(LOAN_STATUSES)
        ]
        return cls(loan_status_rows=loan_status_rows)
