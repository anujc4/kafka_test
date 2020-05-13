# Benchmark Kafka Publisher via Ruby Clients

A simple set of ruby scripts to benchmark performance of kafka when a set of messages are immediately published to kafka rather than batching them in the client

Run the following command in terminal

```bash
docker-compose up
./runner
```

## Output

![alt text](publisher_respone.gif "Timings")

### Results

ruby-kafka 247.329ms (fastest)
waterdrop 276.325ms
rdkafka 10283.635ms (slowest)
