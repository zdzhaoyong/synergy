#!/bin/sh
##BEGIN_INTRODUCTION##	This script is used to control the whole service.
##END_INTRODUCTION##

#####################  Build in Things   ######################
#. $Function_Top/Include/Enviroment_Config.inc
Call_Path=$(pwd) #Where this call from?
#Where is here?
if [ -n "$Function_Path" ];then
	Here_Path=$Function_Path
else
	Here_Path=$(dirname $(readlink -f $0))
fi
#Who am I?
if [ -n "$Function_Name" ];then
	File_Name=$Function_Name.func
else
	File_Name=${0##*/};
	Function_Name=${File_Name%.*};
fi

echo_introduction() #Introduce myself
{
	if [ -n "$1" ];then
	FILE_Content=$(cat < $1)
	else
	FILE_Content=$(cat < $Here_Path/$File_Name)
	fi
	INTRO=${FILE_Content#*##BEGIN_INTRODUCTION##};
	INTRO=${INTRO%%##END_INTRODUCTION##*};
	echo "$INTRO"
}

echo_help() #Echo my help or others'
{
	if [ -n "$1" ];then
		FILE_Content=$(cat < $1)
	else
		FILE_Content=$(cat < $Here_Path/$File_Name)
	fi
	HELP=${FILE_Content##*##BEGIN_HELP##};
	HELP=${HELP%##END_HELP##*};
	echo "usage:  $Function_Name [options values]"
	echo options:"$HELP"
}

##################### other functions below ######################

# CHANGE_ME
SERVICE_NAME=synergy
source ~/.bashrc

install()
{
  sudo apt install ros-$ROS_DISTRO-mavros
}

start() # Start the service
{
 export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)
 ./synergy # server
 # ./synergyc 192.168.1.191 # client, please change to the server ip
}

start_service() # this one is general
{ 
  echo "Installing service $SERVICE_NAME, please do not remove this folder for service running ..."
  #cp $Here_Path/servicedemo.service /tmp/servicedemo.service
  echo "[Unit]" > /tmp/$SERVICE_NAME.service
  echo "Description=$SERVICE_NAME" >> /tmp/$SERVICE_NAME.service
  echo "After=network-online.target" >> /tmp/$SERVICE_NAME.service
  echo "[Install]" >> /tmp/$SERVICE_NAME.service
  echo "WantedBy=multi-user.target" >> /tmp/$SERVICE_NAME.service
  echo "[Service]" >> /tmp/$SERVICE_NAME.service
  echo "WantedBy=multi-user.target" >> /tmp/$SERVICE_NAME.service
  echo "Type=simple" >> /tmp/$SERVICE_NAME.service
  echo "KillMode=control-group" >> /tmp/$SERVICE_NAME.service
  echo "Restart=on-failure" >> /tmp/$SERVICE_NAME.service
  echo "RestartSec=10sec" >> /tmp/$SERVICE_NAME.service
  echo "Environment=DISPLAY=:0" >> /tmp/$SERVICE_NAME.service
  echo "User=$USER" >> /tmp/$SERVICE_NAME.service
  echo "ExecStart=/bin/bash " $(readlink -f $0) >> /tmp/$SERVICE_NAME.service
  echo "Environment=XAUTHORITY=/home/$USER/.Xauthority" >> /tmp/$SERVICE_NAME.service
  echo "WorkingDirectory=$Here_Path" >> /tmp/$SERVICE_NAME.service

  sudo cp /tmp/$SERVICE_NAME.service /etc/systemd/system

  sudo systemctl enable $SERVICE_NAME.service
  sudo systemctl restart $SERVICE_NAME.service

  echo "$SERVICE_NAME service installed, please use 'systemctl disable $SERVICE_NAME' to stop the service."
}

######################  main below  ##############################
if [ -n "$1" ];then
	while [ -n "$1" ]; do
	case $1 in
##BEGIN_HELP##
		-h)     shift 1;echo_help;exit 1;;                   #Show usages 
		-i)     shift 1;echo_introduction;exit 1;;           #Show introduction 
		-edit)  shift 1;gedit $Here_Path/$File_Name;exit 1;; #Edit this function 
		-*)     echo "error: no such option $1. -h for help";exit 1;; 
		*)      $*;exit 1;;                                  #Call function here
##END_HELP##
	esac
	done
else
	start
fi
#echo ---------------------End Of $Function_Name-----------------------


