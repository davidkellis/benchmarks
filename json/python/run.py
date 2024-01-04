# Taken from https://github.com/kostya/benchmarks/blob/master/json/test.py

import json

text = open('./sample.json', 'r').read()
jobj = json.loads(text)
len = len(jobj['coordinates'])
x = 0
y = 0
z = 0

for coord in jobj['coordinates']:
  x += coord['x']
  y += coord['y']
  z += coord['z']

print(x / len)
print(y / len)
print(z / len)