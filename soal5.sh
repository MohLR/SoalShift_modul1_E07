#!/bin/bash

mkdir /home/$USER/modul1
cat /var/log/syslog | awk '/cron/ && !/sudo/' | awk 'NF < 13' >> /home/$USER/modul1/$(date +%Y%m%d%H%M%S).log
