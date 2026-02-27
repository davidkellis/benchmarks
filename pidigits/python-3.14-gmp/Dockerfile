FROM python:3.14
RUN apt-get update && apt-get install -y time libgmp-dev libmpfr-dev libmpc-dev

WORKDIR /app
COPY time.sh .
COPY pidigits/python-3.14-gmp/run.py .

RUN pip install gmpy2

CMD ["./time.sh","python","run.py","10000"]
