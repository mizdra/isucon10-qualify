#!/usr/bin/env bash
set -ex

ROOT=$(cd $(dirname $0)/..;pwd)

echo "clear logs"
for server in isu01; do
  ssh -t $server "sudo rm -f /var/log/nginx/access.log"
  ssh -t $server "sudo rm -f /var/log/nginx/error.log"
done

ssh -t bench "cd /home/isucon/isuumo/bench; /home/isucon/isuumo/bench/bench --target-url http://18.183.153.63"
