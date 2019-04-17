#!/bin/bash

get() {
  echo "badtokenfixme"
}

store() {
  echo "store"
}

erase() {
  echo "erase"
}

mask_secret() {
  secret=$1
  len=${#secret}
  echo "${secret:0:2}____${secret:len-2:len-1}"
}

###### Script entry

date >> token_helper.log

# Grab the command argument passed in by Vault. Should only be "get", "store" or "erase"
TH_CMD=$1
# Grab the token passed from Vault on stdin. Only expected for TH_CMD="store", 
STDIN_LINES=0
unset TOKEN
while IFS='$\n' read -r line; do
  if [ $STDIN_LINES -gt 0 ]; then
    echo "More than one line passed into stdin"
  fi
  TOKEN=$line
  mask_secret $TOKEN
  STDIN_LINES+=1
  echo $STDIN_LINES
done

echo "TH_CMD is: $TH_CMD" >> token_helper.log

if [[ "$TH_CMD" == "" ]]; then 
  (>&2 echo "Error!!! No argument passed into $0")
elif [[ "$TH_CMD" == "get" ]]; then
  get
elif [[ "$TH_CMD" == "store" ]]; then
  store
elif [[ "$TH_CMD" == "erase" ]]; then
  erase
else
  (>&2 echo "Error!!! Argument passed into $0 was unexpected: $TH_CMD")
fi

