run#!/bin/bash

# === Default Configuration ===
THRESHOLD=80                         # Alert if RAM usage exceeds this %
LOGFILE="$HOME/ram_monitor.log"     # Set to a writable path
TOP_N=5                              # Number of top processes to display
ALERT_METHOD="echo"                 # echo | notify | mail
EMAIL="you@example.com"             # Used only if ALERT_METHOD is 'mail'

# === ANSI Color Codes ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# === Usage Message ===
usage() {
  cat <<EOF
Usage: $0 [options]
Options:
  -t, --threshold <percent>   RAM usage percent to trigger alert (default: 80)
  -l, --logfile <file>        Log file path (default: $HOME/ram_monitor.log)
  -n, --top <N>               Number of top processes to display (default: 5)
  -a, --alert <method>        Alert method: echo | notify | mail (default: echo)
  -e, --email <address>       Email address for 'mail' alert method
  -h, --help                  Show help message
EOF
}

# === Parse Arguments ===
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--threshold)
      THRESHOLD="$2"; shift 2;;
    -l|--logfile)
      LOGFILE="$2"; shift 2;;
    -n|--top)
      TOP_N="$2"; shift 2;;
    -a|--alert)
      ALERT_METHOD="$2"; shift 2;;
    -e|--email)
      EMAIL="$2"; shift 2;;
    -h|--help)
      usage; exit 0;;
    *)
      echo "Unknown option: $1" >&2; usage; exit 1;;
  esac
 done

# === Alert Function ===
send_alert() {
  local message="$1"
  # Always display in terminal
  if [ -t 1 ]; then
    echo -e "${RED}$message${NC}"
  else
    echo "$message"
  fi
  case "$ALERT_METHOD" in
    echo)
      ;;  # Already displayed above
    notify)
      command -v notify-send >/dev/null && notify-send "RAM Alert" "$message"
      ;;
    mail)
      if command -v mail >/dev/null; then
        echo "$message" | mail -s "[RAM ALERT]" "$EMAIL"
      fi
      ;;
  esac
}

# === Get Memory Stats ===
read total used <<< $(free -m | awk '/^Mem:/ {print $2, $3}')
usage_percent=$(( (used * 100) / total ))
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# === Get Top Memory-Hungry Processes ===
top_procs=$(ps -eo pid,comm,%mem --sort=-%mem | head -n $((TOP_N + 1)))

# === Build Log Message and Output ===
if [ "$usage_percent" -ge "$THRESHOLD" ]; then
  msg="$timestamp - ALERT: RAM usage is ${usage_percent}% (Used: ${used}MB / Total: ${total}MB)\nTop $TOP_N processes by memory:\n$top_procs"
  # Color alert message in terminal only
  if [ -t 1 ]; then
    echo -e "${RED}$msg${NC}"
  else
    echo "$msg"
  fi
  send_alert "$msg"
else
  msg="$timestamp - OK: RAM usage is ${usage_percent}%\nTop $TOP_N processes by memory:\n$top_procs"
  # Color OK message in terminal only
  if [ -t 1 ]; then
    echo -e "${GREEN}$msg${NC}"
  else
    echo "$msg"
  fi
fi

# === Write to Log (no color codes) ===
echo -e "$msg" >> "$LOGFILE"
