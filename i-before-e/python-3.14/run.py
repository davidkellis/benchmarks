# Taken from https://github.com/archer884/i-before-e/blob/master/python-ie/ie.py

import re
import sys

pattern = re.compile('c?ei')

def is_valid(s):
    captures = pattern.findall(s)
    if len(captures) == 0:
        return True
    
    for capture in captures:
        if not capture.startswith('c'):
            return False
    
    return True    

path = sys.argv[1]
with open(path) as input:
    for word in input:
        word = word.strip()
        if not is_valid(word):
            print(word)