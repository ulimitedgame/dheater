#!/bin/bash

export LC_NUMERIC=C

/bin/grep '^vendor_id\>' /proc/cpuinfo | sed 's%^vendor_id\t: %%' | uniq | xargs echo -e 'vendor\t\t:'
/bin/grep '^model name\>' /proc/cpuinfo | uniq
lscpu --parse=CORE | /bin/grep -v ^# | sort -u | wc -l | xargs echo -e "cpu count\t:"
lscpu --parse=CORE | /bin/grep -v ^# | wc -l | xargs echo -e "core count\t:"
/bin/grep '^cache size\>' /proc/cpuinfo | uniq
lscpu --parse=MAXMHZ | /bin/grep -v ^# | uniq | xargs echo -e "max mhz\t\t:"
lscpu --parse=BOGOMIPS | /bin/grep -v ^# | uniq | xargs echo -e "bogomips\t:"
