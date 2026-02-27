FROM node:22
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY base64/node-22/run.js .

RUN npm install md5.js

CMD ["./time.sh","node","--max-old-space-size=4096","run.js"]
