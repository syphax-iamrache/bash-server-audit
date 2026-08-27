# Bash Server Audit

A Bash script designed to perform a basic system audit of a Linux server.

The script collects information about disk usage, running services, listening ports, connected users, CPU load and RAM usage, then generates a timestamped audit report.

## Features

- Disk usage monitoring
- Disk usage threshold alerts
- Running services detection
- Listening ports detection
- Connected users detection
- Login history
- CPU load monitoring
- RAM usage monitoring
- Automatic report generation
- Cron scheduling

## Technologies

- Bash
- Linux
- systemd
- cron
- df
- uptime
- free
- ss
- awk
- grep

## Project Structure

bash-server-audit/
├── audit_serveur.sh
├── README.md
└── .gitignore

## Installation

Clone the repository:

git clone https://github.com/YOUR_USERNAME/bash-server-audit.git
cd bash-server-audit

Make the script executable:

chmod +x audit_serveur.sh

## Usage

Run the audit script:

./audit_serveur.sh

A timestamped report will be generated:

rapport_audit_YYYY-MM-DD_HH-MM-SS.txt

## Cron Automation

The script can be automatically executed using cron.

Edit the user's crontab:

crontab -e

Example: run the audit every day at 08:00:

0 8 * * * /path/to/audit_serveur.sh

For testing purposes, the script can be scheduled every 5 minutes:

*/5 * * * * /path/to/audit_serveur.sh

## Audit Information

The generated report contains:

- Disk usage and disk alerts
- Running systemd services
- Listening TCP/UDP ports
- Currently connected users
- Recent login history
- CPU load
- RAM usage

## Future Improvements

- Email notifications
- More detailed CPU and RAM threshold alerts
- Log rotation
- Configuration file for customizable thresholds
- Docker containerization
- CI/CD integration with GitHub Actions
- Monitoring integration with Prometheus and Grafana

## Learning Objectives

This project was created as a hands-on project to practice:

- Bash scripting
- Linux system administration
- Process and service monitoring
- Network inspection
- Cron automation
- Git and GitHub
- DevOps fundamentals.