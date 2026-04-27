#!/bin/bash
set -e

zig c++ ./src/main.cpp -o ./.build-out/main \
    -lraylib -lGL -lm -lpthread -ldl -lrt

mkdir -p ./.build-out
./.build-out/main
