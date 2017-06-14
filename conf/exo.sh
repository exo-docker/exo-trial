#!/bin/bash
#
# Start eXo Platform trial edition

if [ ! -d ${EXO_DATA_DIR} ]; then
  echo "# Creating eXo data directory : ${EXO_DATA_DIR}" | tee -a /var/log/exo/platform.log
  mkdir -p ${EXO_DATA_DIR}
  chown ${EXO_USER}:${EXO_GROUP} ${EXO_DATA_DIR}
fi
if [ ! -d ${EXO_DATA_DIR}/.eXo ]; then
  mkdir -p ${EXO_DATA_DIR}/.eXo
  chown ${EXO_USER}:${EXO_GROUP} ${EXO_DATA_DIR}/.eXo
fi

touch /var/log/exo/platform.log
chown ${EXO_USER}:${EXO_GROUP} /var/log/exo/platform.log

echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# " | tee -a /var/log/exo/platform.log
echo "#    \ \      / /_ _ _ __ _ __ (_)_ __   __ _  | |" | tee -a /var/log/exo/platform.log
echo "#     \ \ /\ / / _ \| '__| '_ \| | '_ \ / _  | | |" | tee -a /var/log/exo/platform.log
echo "#      \ V  V / (_| | |  | | | | | | | | (_| | |_|" | tee -a /var/log/exo/platform.log
echo "#       \_/\_/ \__,_|_|  |_| |_|_|_| |_|\__, | (_)" | tee -a /var/log/exo/platform.log
echo "#                                    |___/     " | tee -a /var/log/exo/platform.log
echo "# " | tee -a /var/log/exo/platform.log
echo "#        This eXo Platform image must be used " | tee -a /var/log/exo/platform.log
echo "#            for EVALUATION purpose only ..." | tee -a /var/log/exo/platform.log
echo "# " | tee -a /var/log/exo/platform.log
echo "# - the database is HSQLDB (non production ready SGBDR)" | tee -a /var/log/exo/platform.log
echo "# - the mongodb is not secured" | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# List of add-ons already installed:" | tee -a /var/log/exo/platform.log
/sbin/setuser ${EXO_USER} /opt/exo/addon list --installed 2>&1 | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log

exec /sbin/setuser ${EXO_USER} /opt/exo/start_eXo.sh --data /srv/exo
