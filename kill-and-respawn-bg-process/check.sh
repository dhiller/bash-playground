#!/bin/bash

set -euo pipefail

function test {
    while true; do
        echo "test: sleeping..."
        sleep 1
    done
}

function run_test {
    test &
    pid=$!
}

function cleanup {
    echo "Killing $pid"
    kill $pid
}

trap cleanup EXIT SIGINT SIGTERM

run_test

set +e                         
while true; do                 
    ./maybe-failing.sh
    if [ $? -eq 0 ]; then      
        break                  
    fi      
    echo "main: sleeping before kill..."
    sleep 2 
    echo "main: killing $pid"                  
    cleanup
    run_test
    echo "main: respawned as $pid"
done                           
set -e                         

