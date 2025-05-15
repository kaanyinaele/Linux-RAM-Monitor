# RAM Monitor Pro

A powerful Linux RAM monitoring tool that helps you keep track of your system's memory usage and identify memory-hungry processes.

## Features

- Real-time RAM usage monitoring
- Configurable alert thresholds
- Top process monitoring
- Desktop notifications support
- Detailed logging
- Easy configuration

## Installation

1. Clone this repository
2. Make the script executable:

chmod +x ramMonitorPro.sh

## Usage

Run the script directly:

bash./ramMonitorPro.sh

The script will:

Display current RAM usage in the terminal
Show the top 5 memory-consuming processes
Log all activity to ~/ram_monitor.log
Send notifications if RAM usage exceeds the threshold

## Example Output

2025-05-15 21:24:35 - OK: RAM usage is 71%
Top 5 processes by memory:
PID COMMAND %MEM
32304 language_server 5.2
2781 Isolated Web Co 5.1
17906 Isolated Web Co 4.7
2560 firefox-bin 4.7
3791 Isolated Web Co 4.7

## System Requirements

Linux operating system
free command (usually pre-installed)
ps command (usually pre-installed)
notify-send for desktop notifications (part of libnotify)

## Running as a Service

To run RAM Monitor Pro continuously, you can add it to your cron jobs. Edit your crontab:

bash

crontab -e
Add this line to run every 5 minutes:

_/5 _ \* \* \* /path/to/ramMonitorPro.sh

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Fork the repository

Create your feature branch

Commit your changes

Push to the branch

Create a new Pull Request

Support
For support, please open an issue in the repository.
