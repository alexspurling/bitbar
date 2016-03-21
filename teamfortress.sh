#!/bin/bash

# <bitbar.title>TF2 time</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Alex</bitbar.author>
# <bitbar.author.github>alexspurling</bitbar.author.github>
# <bitbar.desc>Time until the most important time of the week</bitbar.desc>

set -o pipefail

steamlogfile="$HOME/Library/Application Support/Steam/logs/content_log.txt"

#Let's check how long we have until friday 16:00
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

#Now let's check if Steam has any TF2 updates available
api=`curl -s 'http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=440&count=10&maxlength=50&format=json' | grep steam_updates -B1`

if [ $? -ne 0 -o -z "$api" ]
then
  echo "Failed to check Steam API for TF2 updates"
  exit 1
fi

d=`echo $api | awk '{print $2}'`
latestupdate=${d%%[^0-9]}

#And let's check when TF2 was last updated
timestamp=`grep -E 'AppID 440 state changed : Fully Installed,.?$' "$steamlogfile" | tail -n 1 | awk '{print $1 " " $2}'`

if [ $? -ne 0 -o -z "$timestamp" ]
then
  echo "Failed to find / parse Steam log file"
  exit 1
fi

timestamp=${timestamp#[}
timestamp=${timestamp%]}
lastupdated=`date -jf "%Y-%m-%d %H:%M:%S" "$timestamp" +"%s"`

if [ "$lastupdated" -lt "$latestupdate" ]
then
  echo "🔫 TF2 update available|color=red"
else
  echo ---
  echo "TF2 is up to date 😀|color=green"
fi

