FROM able-v12-base

COPY time.sh .
COPY matrixmultiply/able-v12-treewalker/run.able .

CMD ["./time.sh", "able", "--exec-mode=treewalker", "run", "run.able"]
