#!/bin/bash

# === Configuration ===
THRESHOLD=80                         # Alert if RAM usage exceeds this %
LOGFILE="$HOME/ram_monitor.log"     # Set to a writable path
TOP_N=5                              # Number of top processes to display
ALERT_METHOD="echo"                 # echo | notify | mail
EMAIL="you@example.com"             # Used only if ALERT_METHOD is 'mail'

# === Alert Function ===
send_alert() {
  local message=$1
  echo "$message"  # Always display in terminal
  case "$ALERT_METHOD" in
    echo)
      ;;  # Already displayed above
    notify)
      notify-send "RAM Alert" "$message"
      ;;
  esac
}

# === Get Memory Stats ===
read total used <<< $(free -m | awk '/^Mem:/ {print $2, $3}')
usage_percent=$(( (used * 100) / total ))
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# === Get Top Memory-Hungry Processes ===
top_procs=$(ps -eo pid,comm,%mem --sort=-%mem | head -n $((TOP_N + 1)))

# === Build Log Message ===
if [ "$usage_percent" -ge "$THRESHOLD" ]; then
  msg="$timestamp - ALERT: RAM usage is ${usage_percent}% (Used: ${used}MB / Total: ${total}MB)\nTop $TOP_N processes by memory:\n$top_procs"
  echo "$msg"  # Display in terminal
  send_alert "$msg"
else
  msg="$timestamp - OK: RAM usage is ${usage_percent}%\nTop $TOP_N processes by memory:\n$top_procs"
  echo "$msg"  # Display in terminal
fi

# === Write to Log ===
echo -e "$msg" >> "$LOGFILE"
