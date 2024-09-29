import pandas as pd
from constants import DEFAULT_OUTPUT_LOC
from customer import Customers
from customer_loan_lookup import CustomerLoanLookup
from lender import Lenders
from loan_info import LoanInfoRows
from loan_status import LoanStatuses
from utils import to_duckdb, to_pandas


def generate_all() -> dict[str, pd.DataFrame]:
    """Generate a dict of dataframes for the db."""
    customers: pd.DataFrame = to_pandas(Customers.generate_random().customer_rows)
    loan_info_rows: pd.DataFrame = to_pandas(
        LoanInfoRows.generate_random().loan_info_rows
    )
    lenders: pd.DataFrame = to_pandas(Lenders.generate_random().lender_rows)
    statuses: pd.DataFrame = to_pandas(LoanStatuses.generate_random().loan_status_rows)
    loan_customer_lookup: pd.DataFrame = pd.DataFrame(
        CustomerLoanLookup.generate_random().customer_loan_associations
    )

    return {
        "customers": customers,
        "loan_info": loan_info_rows,
        "lenders": lenders,
        "statuses": statuses,
        "loan_customer_lookup": loan_customer_lookup,
    }


if __name__ == "__main__":
    loc: str = DEFAULT_OUTPUT_LOC

    payload = generate_all()
    to_duckdb(payload=payload, output_loc=loc)
