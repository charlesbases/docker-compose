use admin;
db.auth("root", "123456");

sh.addShard("shardsvr-1/rs-shardsvr-1:27017");
sh.addShard("shardsvr-2/rs-shardsvr-2:27017");
sh.addShard("shardsvr-3/rs-shardsvr-3:27017");
