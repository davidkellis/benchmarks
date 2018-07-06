# Taken from https://github.com/kostya/benchmarks/blob/master/base64/test.py

import base64
import hashlib

STR_SIZE = 1000000
TRIES = 20

str = b"a" * STR_SIZE
print(hashlib.md5(str).hexdigest())

for _ in range(0, TRIES):
  str = base64.b64encode(str)
print(hashlib.md5(str).hexdigest())

for _ in range(0, TRIES):
  str = base64.b64decode(str)
print(hashlib.md5(str).hexdigest())
