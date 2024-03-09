#!/bin/bash

export REUTERS_URL=https://kdd.ics.uci.edu/databases/reuters21578/reuters21578.tar.gz
export REUTERS_TARGZ_FILE=reuters.tar.gz

mkdir -p reuters_sample_data \
    && cd reuters_sample_data \
    && curl -o $REUTERS_TARGZ_FILE $REUTERS_URL \
    && tar -xvzf $REUTERS_TARGZ_FILE
    && rm $REUTERS_TARGZ_FILE

