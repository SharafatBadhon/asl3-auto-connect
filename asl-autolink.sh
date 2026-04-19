STEP-1
Open 'Terminal' & Run the command

sudo nano /usr/local/bin/asl-autolink.sh

(It will open Command Line Text Editor)

STEP-2
Paste this:
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

STEP-3 (Save the file)
Press in order:
1. CTRL + X
2. Press Y
3. Press ENTER

🔄 STEP-4 (Restart service)

sudo systemctl restart asl-autolink.service

📌 STEP-5 - Check logs (IMPORTANT)

journalctl -u asl-autolink.service -b --no-pager

🔁 STEP-6 (Reboot test)
sudo reboot
