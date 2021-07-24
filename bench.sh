#!/usr/bin/env bash
set -ex

ROOT=$(cd $(dirname $0);pwd)

echo "clear logs"
# https://serverfault.com/a/980572
ssh -t isu01 "sudo rm -rf /var/log/nginx/access.log"
ssh -t isu01 "sudo rm -rf /var/log/nginx/error.log"
ssh -t isu01 "sudo nginx -s reload"

echo "start benchmark"
ssh -t bench "cd /home/isucon/isuumo/bench; /home/isucon/isuumo/bench/bench --target-url http://18.183.153.63"

echo "fetch logs"
rsync -a --rsync-path="sudo rsync" isu01:/var/log/nginx/access.log $ROOT/log/access.log
rsync -a --rsync-path="sudo rsync" isu01:/var/log/nginx/error.log $ROOT/log/error.log
