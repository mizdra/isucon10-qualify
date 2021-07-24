#!/usr/bin/env bash
set -ex

ROOT=$(cd $(dirname $0)/..;pwd)

ssh -t bench "cd /home/isucon/isuumo/bench; /home/isucon/isuumo/bench/bench --target-url http://18.183.153.63"
