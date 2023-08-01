#!/bin/bash

# Function to perform backup
perform_backup() {
    local src_dir=$1
    local backup_dir="${src_dir}_backups"

    # Create backup folder if it doesn't exist
    mkdir -p "$backup_dir"

    # Create timestamp
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    
    # Create a new backup folder with the timestamp
    local new_backup_dir="${backup_dir}/${timestamp}"
    mkdir "$new_backup_dir"

    # Copy files from source directory to the backup folder
    cp -r "$src_dir"/* "$new_backup_dir"

    # Remove old backups if there are more than 3
    local num_backups=$(ls -1 "$backup_dir" | wc -l)
    if [ "$num_backups" -gt 3 ]; then
        # Sort the backup directories by modification time and remove the oldest ones
        ls -t "$backup_dir" | tail -n +4 | xargs -I {} rm -rf "$backup_dir"/{}
    fi
}

# Check if a directory path is provided as a command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

directory_path=$1

# Check if the provided path is a directory
if [ ! -d "$directory_path" ]; then
    echo "Error: The specified path is not a directory."
    exit 1
fi

# Perform the backup
perform_backup "$directory_path"

echo "Backup of '$directory_path' completed successfully!"

