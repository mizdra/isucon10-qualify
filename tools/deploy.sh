#!/usr/bin/env bash
set -ex

ROOT=$(cd $(dirname $0)/..;pwd)


echo "start build"
cd $ROOT/go
GOOS=linux make -B


echo "start deploy ${USER}"
for server in isu01; do
    ssh -t $server "sudo systemctl stop isuumo.go.service"
    ssh -t $server "sudo systemctl stop nginx.service"
    ssh -t $server "sudo systemctl stop mysql.service"

    ssh -t $server "sudo rm -f /var/log/nginx/access.log"
    ssh -t $server "sudo rm -f /var/log/nginx/error.log"

    rsync -a --rsync-path="sudo -u isucon rsync" $ROOT/go/isuumo $server:/home/isucon/isuumo/webapp/go/isuumo
    rsync -a --rsync-path="sudo rsync" $ROOT/nginx/sites-available/ $server:/etc/nginx/sites-available/
    rsync -a --rsync-path="sudo rsync" $ROOT/nginx/nginx.conf $server:/etc/nginx/nginx.conf
    rsync -a --rsync-path="sudo -u isucon rsync" $ROOT/env.sh $server:/home/isucon/env.sh
    rsync -a --rsync-path="sudo rsync" $ROOT/mysql/conf.d/ $server:/etc/mysql/conf.d/
    rsync -a --rsync-path="sudo rsync" $ROOT/mysql/mysql.conf.d/ $server:/etc/mysql/mysql.conf.d/

    ssh -t $server "sudo systemctl start isuumo.go.service"
    ssh -t $server "sudo systemctl start nginx.service"
    ssh -t $server "sudo systemctl start mysql.service"
done
