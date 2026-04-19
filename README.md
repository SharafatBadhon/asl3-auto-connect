# AllStarLink Node Auto-Connect Script

This project provides a robust bash script and systemd service to automatically connect your AllStarLink (ASL3) node to a specific target upon system boot or disconnection from internet. It has been tested and verified on a Raspberry Pi.

## Features
- **Wait for Asterisk:** Ensures the Asterisk socket is ready before attempting to link.
- **Network Stability:** Includes a delay to allow the network to stabilize.
- **Retry Logic:** Attempts to link up to 10 times with a 10-second interval between retries to ensure a successful connection.

## Installation Guide

### Step 1: Create the Script
Run the following command to create the script file:
```bash
sudo nano /usr/local/bin/asl-autolink.sh
##STEP 2: Paste the Script
Copy and paste the following code into the editor. Make sure to change the Node and Target numbers.

Bash
#!/bin/bash

NODE=(Your Node Number)
TARGET=(Target Node Number)

# Wait for Asterisk socket
while ! asterisk -rx "core show uptime" >/dev/null 2>&1
do
    sleep 5
done

# Wait for node network stability
sleep 20

# Retry link until success (VERY IMPORTANT)
for i in {1..10}
do
    RESULT=$(asterisk -rx "rpt cmd $NODE ilink 3 $TARGET" 2>&1)

    echo "$RESULT"

    # Check if it worked
    asterisk -rx "rpt lstats $NODE" | grep "$TARGET" >/dev/null

    if [ $? -eq 0 ]; then
        echo "LINK SUCCESSFUL"
        exit 0
    fi

    sleep 10
done

echo "LINK FAILED AFTER RETRIES"
exit 1

STEP 3: Save the File
To save and exit the nano editor, press:

CTRL + X
then
Press Y
then
Press ENTER

##STEP 4: Make the Script Executable
You need to give the system permission to run this script:

Bash
sudo chmod +x /usr/local/bin/asl-autolink.sh

STEP 5: Restart the Service
To apply the changes, restart the service:

Bash
sudo systemctl restart asl-autolink.service
STEP 6: Check Logs (IMPORTANT)

Verify if the connection was successful by checking the logs:

Bash
journalctl -u asl-autolink.service -b --no-pager

STEP 7: Reboot Test
Finally, reboot your system to test the auto-connect feature:

Bash
sudo reboot

73! de S21BAD
