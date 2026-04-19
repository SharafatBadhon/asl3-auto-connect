#!/bin/bash

NODE=67028
TARGET=67163

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
