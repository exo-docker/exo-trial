#!/bin/sh
#
# Start MongoDB server

. /etc/envvars

if [ ! -d ${MONGO_DATA_DIR} ]; then
  echo "# Creating MongoDB data directory : ${MONGO_DATA_DIR}" | tee -a /var/log/mongodb/mongod.log
  mkdir -p ${MONGO_DATA_DIR}
  chown mongodb:mongodb ${MONGO_DATA_DIR}
fi

touch /var/log/mongodb/mongod.log
chown mongodb:mongodb /var/log/mongodb/mongod.log
exec /usr/local/bin/gosu mongodb /usr/bin/mongod -f /etc/mongod.conf >> /var/log/mongodb/mongod.log 2>&1
