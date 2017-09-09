#!/bin/bash

if [ -z "$LGSM_GAMESERVERNAME" ]; then
  echo "Need to set LGSM_GAMESERVERNAME environment"
  exit 1
fi

if [ -n "$LGSM_UPDATEINSTALLSKIP" ]; then
  case "$LGSM_UPDATEINSTALLSKIP" in
  "UPDATE")
      ./linuxgsm.sh $LGSM_GAMESERVERNAME
      mv $LGSM_GAMESERVERNAME lgsm-gameserver
      ./lgsm-gameserver auto-install
      echo "Game has been updaed. Starting"
      ;;
  "INSTALL")
      ./linuxgsm.sh $LGSM_GAMESERVERNAME
      mv $LGSM_GAMESERVERNAME lgsm-gameserver
      ls -ltr
      ./lgsm-gameserver auto-install
      echo "Game has been installed. Exiting"
      exit
      ;;
  esac
fi



if [ ! -f lgsm-gameserver ]; then
    echo "No game is installed, please set LGSM_UPDATEINSTALLSKIP"
    exit 1
fi

~/bin/gomplate -f ~/linuxgsm/lgsm/config-default/config-lgsm/common.cfg.tmpl -o ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME/common.cfg
~/bin/gomplate -f ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME/$LGSM_GAMESERVERNAME.cfg.tmpl -o ~/linuxgsm/lgsm/config-lgsm/$LGSM_GAMESERVERNAME/$LGSM_GAMESERVERNAME.cfg
#
./lgsm-gameserver start
sleep 30s
#
./lgsm-gameserver details
#
while :
do
bash lgsm-gameserver monitor
sleep 30s
done