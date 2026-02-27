FROM node:24
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY monte_carlo_pi/node-24/run.js .

CMD ["./time.sh","node","run.js"]
