#!/bin/bash

TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
OUTPUT_FILE="mac_GetUserAndStartupAgents_${TIMESTAMP}.txt"

# Clear the screen and scrollback buffer.
  printf '\33c\e[3J'


# Header
  echo "Activity Monitor Summary - $(date)" | tee "$OUTPUT_FILE"
  echo "==================================================" | tee -a "$OUTPUT_FILE"

###############################################################################
# Local Users
###############################################################################
  echo ""
  echo "Running command: dscl . list /Users | grep -v ^_" | tee -a "$OUTPUT_FILE"
  echo "Remove with the commands:" | tee -a "$OUTPUT_FILE"
  echo "     deluser=\"<USER>\"" | tee -a "$OUTPUT_FILE"
  echo "     sudo dscl . delete /users/$deluser" | tee -a "$OUTPUT_FILE"
  echo "     sudo rm -r /users/$deluser" | tee -a "$OUTPUT_FILE"
  echo ""
  echo "Local Users:" | tee -a "$OUTPUT_FILE"
  dscl . list /Users | grep -v ^_ | tee -a "$OUTPUT_FILE"

###############################################################################
# LAUNCHAGENTS
###############################################################################
echo ""
echo "Running command: sudo ls /Library/LaunchAgents" | tee -a "$OUTPUT_FILE"
echo "Remove with command:  sudo rm /Library/LaunchAgents <LAUNCH_AGENT>" | tee -a "$OUTPUT_FILE"
echo ""
echo "Local Launch Agents:" | tee -a "$OUTPUT_FILE"
sudo ls /Library/LaunchAgents | tee -a "$OUTPUT_FILE"

###############################################################################
# LAUNCH DAEMONS
###############################################################################
echo ""
echo "Running command: sudo ls /Library/LaunchDaemons" | tee -a "$OUTPUT_FILE"
echo "Remove with command:  sudo rm /Library/LaunchDaemons <LAUNCH_DAEMON>" | tee -a "$OUTPUT_FILE"
echo ""
echo "Local Launch Daemons" | tee -a "$OUTPUT_FILE"
sudo ls /Library/LaunchDaemons | tee -a "$OUTPUT_FILE"

###############################################################################
# launchctl
###############################################################################
echo ""
echo "Running command: launchctl list | grep -v apple" | tee -a "$OUTPUT_FILE"
echo "Remove with command: launchctl remove <launch_agent>" | tee -a "$OUTPUT_FILE"
echo ""
echo "launchctl" | tee -a "$OUTPUT_FILE"
launchctl list | grep -v apple | tee -a "$OUTPUT_FILE"

	


# cat $OUTPUT_FILE
rm $OUTPUT_FILE
