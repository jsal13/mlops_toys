# Kinesis Streaming

## Status

**Working.**

## Description

Kinesis example.  Generate data with *data_gen* and produce records with *producer* to send to Kinesis.

## Quickstart

1. Create (or copy) an AWS configuration with appropriate Kinesis privilages and credentials file to `~/.aws_data/`.  This allows the producer to connect to AWS Kinesis.

2. Set the constants at the end of `producer/producer.py` to match your Kinesis connection.

3. From the root of this directory, run `docker compose up`.

4. You should be able to see the records in your Kinesis stream now!

## Credentials

## Notes

## Resources
