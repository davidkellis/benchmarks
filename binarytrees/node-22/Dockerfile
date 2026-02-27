FROM node:22
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY binarytrees/node-22/run.js .

CMD ["./time.sh","node","run.js","21"]
