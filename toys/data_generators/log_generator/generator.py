import datetime

import responses
import faker

from faker import Faker

fake = Faker()

rsp_good = responses.Response(
    method="PUT",
    url="http://example.com",
)
