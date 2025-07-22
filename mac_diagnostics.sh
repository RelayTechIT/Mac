#!/bin/bash

TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
OUTPUT_FILE="mac_performance_report_${TIMESTAMP}.txt"

# Header
echo "Activity Monitor Summary - $(date)" | tee "$OUTPUT_FILE"
echo "==================================================" | tee -a "$OUTPUT_FILE"

###############################################################################
# TOP 10 PROCESSES BY CPU USAGE
###############################################################################
echo -e "\nTOP 10 PROCESSES BY CPU USAGE\n" | tee -a "$OUTPUT_FILE"
# Print header
printf "%-8s %-6s %s\n" "PID" "%CPU" "COMMAND" | tee -a "$OUTPUT_FILE"
# List all processes, sort by %CPU (field 2), take top 10, format
ps -e -o pid=,pcpu=,comm= | \
  sort -k2 -nr | head -n 10 | \
  awk '{printf "%-8s %-6.1f %s\n", $1, $2, $3}' \
  | tee -a "$OUTPUT_FILE"

###############################################################################
# TOP 10 PROCESSES BY MEMORY USAGE
###############################################################################
echo -e "\nTOP 10 PROCESSES BY MEMORY USAGE\n" | tee -a "$OUTPUT_FILE"
# Print header
printf "%-8s %-6s %-8s %s\n" "PID" "%MEM" "MEM_MB" "COMMAND" | tee -a "$OUTPUT_FILE"
# List all processes, sort by RSS (field 3), take top 10, convert KB→MB, format
ps -e -o pid=,pmem=,rss=,comm= | \
  sort -k3 -nr | head -n 10 | \
  awk '{printf "%-8s %-6.1f %-8.2f %s\n", $1, $2, $3/1024, $4}' \
  | tee -a "$OUTPUT_FILE"

###############################################################################
# SYSTEM LOAD AVERAGES
###############################################################################
echo -e "\nSYSTEM LOAD (1, 5, 15 min)\n" | tee -a "$OUTPUT_FILE"
uptime | awk -F'load averages:' '{print "Load Averages:" $2}' | tee -a "$OUTPUT_FILE"

###############################################################################
# PHYSICAL MEMORY SUMMARY
###############################################################################
echo -e "\nMEMORY SUMMARY\n" | tee -a "$OUTPUT_FILE"
# vm_stat shows pages; convert pages→GB (4096 bytes/page)
vm_stat | \
  awk '
    /Pages free/        { free=$3 }
    /Pages active/      { active=$3 }
    /Pages inactive/    { inactive=$3 }
    /Pages speculative/ { spec=$3 }
    /Pages wired down/  { wired=$4 }
    END {
      factor=4096/1024/1024/1024
      printf "  Free: %.2f GB   Active: %.2f GB   Inactive: %.2f GB   Speculative: %.2f GB   Wired: %.2f GB\n",
        free*factor, active*factor, inactive*factor, spec*factor, wired*factor
    }' | tee -a "$OUTPUT_FILE"

###############################################################################
# SENTINELONE RESOURCE USAGE
###############################################################################
echo -e "\nSENTINELONE RESOURCE USAGE\n" | tee -a "$OUTPUT_FILE"
ps aux | grep -i '[s]entinel' | \
  awk '{printf "%-8s %-6s %-6s %s\n", $1, $3, $4, $11}' \
  | tee -a "$OUTPUT_FILE"

###############################################################################
# SENTINELONE RESOURCE FLAG (if >10% CPU or MEM)
###############################################################################
echo -e "\nSENTINELONE RESOURCE FLAG (if >10% CPU or MEM)\n" | tee -a "$OUTPUT_FILE"
ps aux | grep -i '[s]entinel' | \
  awk '$3 > 10 || $4 > 10 {print "High usage detected: CPU="$3"% MEM="$4"% CMD="$11}' \
  | tee -a "$OUTPUT_FILE"

# Done
echo -e "\nReport saved to: $OUTPUT_FILE"