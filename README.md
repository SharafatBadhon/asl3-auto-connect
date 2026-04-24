# AllStarLink Node Auto-Connect Script (ASL3)

This project provides a robust bash script and systemd service to automatically connect your AllStarLink (ASL3) node to a specific target upon system boot or network reconnection. Tested and verified on Raspberry Pi 3B+.

# 🌟 Features

Wait for Asterisk: Ensures the Asterisk socket is active before executing commands.

Network Stability: Includes a 20-second delay for full network stabilization.

Retry Logic: Intelligent up to 10-time retry mechanism with link verification.

Automated: Runs silently in the background as a system service.

## 🛠 Installation Guide

## STEP 1: Create the Script File

Open your terminal and create the script file using the following command:

sudo nano /usr/local/bin/asl-autolink.sh


## STEP 2: Paste the Script

Copy and paste the code below into the editor. Update the NODE and TARGET variables with your node numbers.

` #!/bin/bash

# Configuration
NODE=67028
TARGET=67163

# Wait for Asterisk socket to be ready
while ! asterisk -rx "core show uptime" >/dev/null 2>&1
do
    echo "Waiting for Asterisk..."
    sleep 5
done

# Wait for network stability
echo "Waiting for network stability..."
sleep 20

# Retry link until success
for i in {1..10}
do
    echo "Attempt $i: Linking $NODE to $TARGET"
    RESULT=$(asterisk -rx "rpt cmd $NODE ilink 3 $TARGET" 2>&1)

    # Check link status
    asterisk -rx "rpt lstats $NODE" | grep "$TARGET" >/dev/null

    if [ $? -eq 0 ]; then
        echo "LINK SUCCESSFUL"
        exit 0
    fi

    sleep 10
done

echo "LINK FAILED AFTER 10 RETRIES"
exit 1 `


STEP 3: Save and Exit

To save the changes in the nano editor:

Press CTRL + X

Press Y

Press ENTER

STEP 4: Set Executable Permissions

Run this command to allow the system to execute the script:

sudo chmod +x /usr/local/bin/asl-autolink.sh


STEP 5: Create Systemd Service

Create a service file so the script runs automatically on boot:

sudo nano /etc/systemd/system/asl-autolink.service


Paste the following configuration:

[Unit]
Description=AllStarLink Auto-Connect Service
After=asterisk.service

[Service]
Type=simple
ExecStart=/usr/local/bin/asl-autolink.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target


Save and Exit as shown in Step 3.

STEP 6: Activate the Service

sudo systemctl daemon-reload
sudo systemctl enable asl-autolink.service
sudo systemctl restart asl-autolink.service


📊 Monitoring & Testing

Check Logs

To see the real-time status of the connection:

journalctl -u asl-autolink.service -b --no-pager


Reboot Test

Perform a full test by rebooting your Pi:

sudo reboot


73! de S21BAD
