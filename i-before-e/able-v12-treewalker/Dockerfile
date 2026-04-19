FROM able-v12-base

COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/able-v12-treewalker/run.able .

CMD ["./time.sh", "able", "--exec-mode=treewalker", "run", "run.able", "wordlist.txt"]
