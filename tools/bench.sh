#!/usr/bin/env bash
set -ex

ROOT=$(cd $(dirname $0)/..;pwd)

echo "clear logs"
ssh -t isu01 "sudo rm -f /var/log/nginx/access.log"
ssh -t isu01 "sudo rm -f /var/log/nginx/error.log"

ssh -t bench "cd /home/isucon/isuumo/bench; /home/isucon/isuumo/bench/bench --target-url http://18.183.153.63"
