import random
import string

import redis

REDIS_HOST = "redis"
REDIS_PORT = 6379

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

for idx in range(100, 150):
    r.set(str(idx), random.choice(string.ascii_lowercase))
