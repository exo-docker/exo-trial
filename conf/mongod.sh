#!/bin/sh
#
# Start MongoDB server
touch /var/log/mongodb/mongod.log
chown mongodb:mongodb /var/log/mongodb/mongod.log
exec /sbin/setuser mongodb /usr/bin/mongod -f /etc/mongod.conf >> /var/log/mongodb/mongod.log 2>&1
