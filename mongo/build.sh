#!/bin/bash

set -e

# 本地挂载目录
mongodir="/opt/volumes/mongo"

# mongos 服务名
rs_mongos="mongo"

# shardsvr 服务列表。与 conf 文件夹内文件名保持一致
rs_shardsvrs=("rs-shardsvr-1" "rs-shardsvr-2" "rs-shardsvr-3")

# configsvr 服务列表。与 conf 文件夹内文件名保持一致
rs_configsvrs=("rs-configsvr-1" "rs-configsvr-2" "rs-configsvr-3")


# 拷贝 conf 文件夹下配置文件至挂载目录
conf() {
  echo -e "🍺 \033[36mdiscover conf\033[0m"

  if [[ ! -d "$mongodir" ]]; then
    sudo mkdir -p $mongodir/{db,log,conf}
  fi

  # mongos
  if [[ ! -f "$mongodir/conf/$rs_mongos/mongo.conf" ]]; then
    sudo mkdir -p $mongodir/conf/$rs_mongos && cp conf/$rs_mongos.conf $mongodir/conf/$rs_mongos/mongo.conf
  fi

  # shardsvr
  for i in ${rs_shardsvrs[@]}; do
    if [[ ! -f "$mongodir/conf/$i/mongo.conf" ]]; then
      sudo mkdir -p $mongodir/conf/$i && cp conf/$i.conf $mongodir/conf/$i/mongo.conf
    fi
  done
  
  # configsvr
  for i in ${rs_configsvrs[@]}; do
    if [[ ! -f "$mongodir/conf/$i/mongo.conf" ]]; then
      sudo mkdir -p $mongodir/conf/$i && cp conf/$i.conf $mongodir/conf/$i/mongo.conf
    fi
  done
}

keyfile() {
  if [[ ! -f "$mongodir/keyfile" ]]; then
    echo -e "🍺 \033[36mgenerate keyfile\033[0m"

    openssl rand -base64 756  > $mongodir/keyfile
    sudo chmod 400 $mongodir/keyfile
    sudo chown 999 $mongodir/keyfile
  fi
}

waiting() {
  echo -e "🍺 \033[36mwatting for server start\033[0m"

  for true; do
    if [[ -n `docker ps | grep "0.0.0.0:27017->27017/tcp"` ]]; then
      break
    else
      sleep 1
    fi
  done
}

setting() {
  # rs-configsvr
  echo -e "🍺 \033[36mconfigure configsvr\033[0m"
  rs_configsvr=${rs_configsvrs[0]}
  docker exec $rs_configsvr bash -c "echo 'rs.initiate(`cat $rs_configsvr.json`)' | mongo "
  createuser $rs_configsvr

  # rs-shardsvr
  echo -e "🍺 \033[36mconfigure shardsvr\033[0m"
  for rs_shardsvr in ${rs_shardsvrs[@]}; do
    docker exec $rs_shardsvr bash -c "echo 'rs.initiate(`cat $rs_shardsvr.json`)' | mongo"
    createuser $rs_shardsvr
  done

  # mongos
  echo -e "🍺 \033[36mconfigure mongos\033[0m"
  docker exec $rs_mongos bash -c "echo '`cat _addShard.sql`' | mongo"
}

createuser() {
  image=$1

  if [[ -z $image ]]; then
    echo -e "🍺 \033[31mcreateuser: no parameters [docker image]\033[0m"
    exit
  fi

  docker exec $image bash -c "echo -e 'use admin\n db.createUser(`cat _createUser.json`)' | mongo"
}

main() {
  conf
  keyfile

  echo -e "🍺 \033[36mdocker-compose up -d\033[0m"
  docker-compose -p mongodb up -d

  waiting
  setting

  echo -e "✨✨ \033[32mCompleted\033[0m ✨✨"
}

main