FROM able-v12-base

COPY time.sh .
COPY matrixmultiply/able-v12-bytecode/run.able .

CMD ["./time.sh", "able", "--exec-mode=bytecode", "run", "run.able"]
