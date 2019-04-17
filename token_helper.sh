#!/bin/bash

get() {
  echo "badtokenfixme"
}

store() {
  # Grab the token passed from Vault on stdin. Only expected for TH_CMD="store", 
  STDIN_LINES=0
  unset TOKEN
  while IFS='$\n' read -r line; do
    if [ $STDIN_LINES -gt 0 ]; then
      log "More than one line passed into stdin"  
      exit 1
    fi
    TOKEN=$line
    mask_secret $TOKEN
    STDIN_LINES+=1
    echo $STDIN_LINES
  done
}

erase() {
  echo "erase"
}

mask_secret() {
  secret=$1
  len=${#secret}
  echo "${secret:0:2}____${secret:len-2:len-1}"
}

log() {
  LOG_FILE="$(dirname "$0")/token_helper.log"
  echo $* >> $LOG_FILE
   (>&2 echo $*)  
}

###### Script entry
log "-------------------------------------------------------------------------"
log `date "+%Y-%m-%d %H:%M:%S"` "$0 invoked by Vault" 

# Grab the command argument passed in by Vault. Should only be "get", "store" or "erase"
TH_CMD=$1


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

