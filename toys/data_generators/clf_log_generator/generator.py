import datetime
from typing import Iterable
import random

import faker

from faker import Faker

CLF_DATE_FORMAT = "%d/%b/%Y:%H:%M:%S %z"
BATCH_LOG_DATA_START_DATE = datetime.datetime(
    2023, 1, 2, 3, 4, 5, 0, datetime.timezone.utc
)

fake = Faker()


def _format_log(
    remotehost: str,
    rfc931: str,
    authuser: str,
    date: str,
    request: str,
    status: str,
    bytes: str,
) -> str:
    """Format data into CLF log format."""
    return f'{remotehost} {rfc931} {authuser} [{date}] "{request}" {status} {bytes}'


def _format_http_request(method: str, loc: str) -> str:
    """Format data as an HTTP request."""
    return f"{method} {loc} HTTP/1.0"


def _format_datetime(date: datetime.datetime) -> str:
    """Format date for CLF logs."""
    return date.strftime(CLF_DATE_FORMAT)


def generate_random_log_row(
    status_list: Iterable = ("200", "300", "400", "500"), date: str | None = None
) -> str:
    """Generate a random log row."""

    # Generate random request.
    loc = f"example.com/{fake.uri_page()}/"
    request = _format_http_request(method=fake.http_method(), loc=loc)

    # Generate datetime in the appropriate format.
    if date is None:
        date = _format_datetime(date=datetime.datetime.now(tz=datetime.timezone.utc))

    return _format_log(
        remotehost=fake.ipv4(),
        rfc931="-",
        authuser=fake.user_name(),
        date=date,
        request=request,
        status=random.choices(status_list, k=1)[0],
        bytes=random.randint(0, 8192),
    )


# BATCH
def _generate_date_range(n: int = 10000) -> list[str]:
    """Generate a range of datetimes in the appropriate format."""
    # This is gross but I dunno how to make this realistic otherwise (without Pandas / Numpy).
    datetime_range = [BATCH_LOG_DATA_START_DATE]
    datetime_range_formatted = [_format_datetime(BATCH_LOG_DATA_START_DATE)]
    for idx in range(1, n):
        dt = datetime_range[idx - 1] + datetime.timedelta(seconds=random.randint(0, 10))
        datetime_range.append(dt)
        datetime_range_formatted.append(_format_datetime(dt))
    return datetime_range_formatted


def generate_batch_random_log_data(n: int = 10000) -> list[str]:
    """Generate ``n`` random log rows."""
    date_range = _generate_date_range(n=n)
    return [generate_random_log_row(date=date_range[idx]) for idx in range(n)]
