#!/bin/bash

is_process_running()
{

if pgrep -x "$1" >/dev/null; then
        return 0
else
        return 1
fi
}

restart_process()
{

        local process_name="$1"
        echo "Process $process_name is not running.Attempting to restart."

        if sudo systemctl restart "$process_name";then
                echo "Process $process_name restarted successfully."
        else
                echo "Failed to restart $process_name."
        fi

}

if [ $# -eq 0 ]; then
        echo "Usage: $0 <process_name>"
        exit 1
fi

process_name="$1"
max_attempts=3
attempt=1

while [ $attempt -le $max_attempts ];do
        if is_process_running "$process_name"; then
                echo "Process $process_name is running"
        else
                restart_process "$process_name"
        fi

        attempt=$((attempt+1))
        sleep 5
done

echo "Maximun restart attempts reached. PLease check the process manually"
