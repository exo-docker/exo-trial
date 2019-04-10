#!/bin/bash
export > /etc/envvars
/usr/bin/runsvdir -P /etc/service
