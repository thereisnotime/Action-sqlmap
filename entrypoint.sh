#!/bin/sh -l

echo "Hello there $1"
time=$(date)
echo "time=$time" >>$GITHUB_OUTPUT
