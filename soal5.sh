#!/bin/bash

cat /var/log/syslog | awk '/cron/ && !/sudo/' | awk 'NF < 13' >> /home/arino/modul1
