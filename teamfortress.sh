#!/bin/bash

# <bitbar.title>TF2 time</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Alex</bitbar.author>
# <bitbar.author.github>alexspurling</bitbar.author.github>
# <bitbar.desc>Time until the most important time of the week</bitbar.desc>

tf2time=`date -v16H -v0M -v0S -v+fri +"%s"`
curtime=`date +"%s"`

timesec=$((tf2time - curtime))

if [ "$timesec" -lt 0 ]
then
  echo "🔫 It's TF2 time!! 😈"
elif [ "$timesec" -lt 60 ]
then
  echo "🔫 TF2 in $timesec seconds 😝"
elif [ "$timesec" -lt 3600 ]
then
  secs=$((timesec % 60))
  mins=$((timesec / 60))
  echo "🔫 TF2 in $mins mins $secs secs 😄"
elif [ "$timesec" -lt 86400 ]
then
  mins=$((timesec / 60 % 60))
  hours=$((timesec / 3600))
  echo "🔫 TF2 in $hours hours $mins mins 😏"
else
  days=$((timesec / 86400))
  echo "🔫 TF2 in $days days 😔"
fi
