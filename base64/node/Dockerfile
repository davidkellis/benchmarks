FROM node:latest

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY base64/node/run.js .

RUN npm install md5.js

CMD ["./time.sh", "node", "--max-old-space-size=4096", "run.js"]
