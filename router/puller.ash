#!/bin/ash

SLEEP_SEC=10
PINGER_ADDRESS=XX.XX.XX.XX
PROTOCOL=http
PINGER_USER=d1feb8d074
PINGER_TOKEN=ec406fe475aa
ROUTER_NUMBER=3141

while true; do
  if [ -f "update.dat" ]; then
      echo "File 'update.dat' exists."
      rm -f current.dat
      mv update.dat current.dat
  else
      echo -n "0" > current.dat
      echo "File 'update.dat' does not exist."
  fi

  wget -q --user=$PINGER_USER --password=$PINGER_TOKEN $PROTOCOL://$PINGER_ADDRESS/$PINGER_USER/$ROUTER_NUMBER/update.dat

  content=$(cat "update.dat")

  if [ "$content" = "0" ]; then
      rm -f current.dat
      echo -n "0" > current.dat
  fi

  if cmp -s "update.dat" "current.dat"; then
    echo "Stay put."
  else
    echo "Pull and execute new policy."
    rm -f policy.ash
    wget -q --user=$PINGER_USER --password=$PINGER_TOKEN $PROTOCOL://$PINGER_ADDRESS/$PINGER_USER/$ROUTER_NUMBER/policy.ash
    ash policy.ash
  fi

	sleep $SLEEP_SEC
done
