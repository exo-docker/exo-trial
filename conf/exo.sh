#!/bin/bash
#
# Start eXo Platform trial edition

touch /var/log/exo/platform.log
chown exo:exo /var/log/exo/platform.log

echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# " | tee -a /var/log/exo/platform.log
echo "#    \ \      / /_ _ _ __ _ __ (_)_ __   __ _  | |" | tee -a /var/log/exo/platform.log
echo "#     \ \ /\ / / _ \| '__| '_ \| | '_ \ / _  | | |" | tee -a /var/log/exo/platform.log
echo "#      \ V  V / (_| | |  | | | | | | | | (_| | |_|" | tee -a /var/log/exo/platform.log
echo "#       \_/\_/ \__,_|_|  |_| |_|_|_| |_|\__, | (_)" | tee -a /var/log/exo/platform.log
echo "#                                    |___/     " | tee -a /var/log/exo/platform.log
echo "# " | tee -a /var/log/exo/platform.log
echo "#        This eXo Platform container must be used " | tee -a /var/log/exo/platform.log
echo "#            for EVALUATION purpose only ..." | tee -a /var/log/exo/platform.log
echo "# " | tee -a /var/log/exo/platform.log
echo "# - the database is HSQLDB (non production ready SGBDR)" | tee -a /var/log/exo/platform.log
echo "# - the mongodb is not secured" | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" | tee -a /var/log/exo/platform.log
echo "# List of add-ons already installed:" >> /var/log/exo/platform.log
/sbin/setuser exo /opt/exo/current/addon list --installed 2>&1 >> /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" >> /var/log/exo/platform.log
echo "# -------------------------------------------------------- #" >> /var/log/exo/platform.log

exec /sbin/setuser exo /opt/exo/current/start_eXo.sh -nc --data /srv/exo >> /dev/null 2>&1
