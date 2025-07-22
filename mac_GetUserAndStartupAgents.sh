#!/bin/bash
###############################################################################
# Local Users
###############################################################################
dscl . list /Users | grep -v ^_

###############################################################################
# LAUNCHAGENTS
###############################################################################
sudo ls /Library/LaunchAgents

###############################################################################
# LAUNCHDAEMONS
###############################################################################
sudo ls /Library/LaunchDaemons


TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
OUTPUT_FILE="mac_GetUserAndStartupAgents_${TIMESTAMP}.txt"

# Header
echo "Activity Monitor Summary - $(date)" | tee "$OUTPUT_FILE"
echo "==================================================" | tee -a "$OUTPUT_FILE"

###############################################################################
# Local Users
###############################################################################
echo -e "dscl . list /Users | grep -v ^_" | tee -a "$OUTPUT_FILE"
# Print header
printf "Local users on $(hostname)" | tee -a "$OUTPUT_FILE"
dscl . list /Users | grep -v ^_ | tee -a "$OUTPUT_FILE"
