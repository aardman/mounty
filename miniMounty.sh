#!/bin/bash

# Set up logging
LOG_FILE="/tmp/custom_mount_debug.log"
echo "=== Custom Mount Dialog Started: $(date) ===" >> "$LOG_FILE"
echo "Script running from: $(pwd)" >> "$LOG_FILE"
echo "User: $(whoami)" >> "$LOG_FILE"
echo "PATH: $PATH" >> "$LOG_FILE"

# Function to convert Windows UNC path to macOS SMB URL
convert_unc_to_smb() {
    local path="$1"
    echo "Input path: $path" >> "$LOG_FILE"
    
    # Trim whitespace
    path=$(echo "$path" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    # If it starts with \\, convert to smb://
    if [[ "$path" == \\\\* ]]; then
        path="${path#\\\\}"  # Remove leading \\
        path="smb://${path//\\//}"  # Replace remaining \ with /
    # If it starts with //, convert to smb://
    elif [[ "$path" == //* ]]; then
        path="smb:/${path}"
    # If it doesn't start with smb://, assume it needs it
    elif [[ "$path" != smb://* ]]; then
        path="${path#/}"  # Remove leading slashes
        path="smb://$path"
    fi
    
    echo "Converted to: $path" >> "$LOG_FILE"
    echo "$path"
}

# Show dialog and get user input
echo "Attempting to show dialog..." >> "$LOG_FILE"

user_input=$(osascript 2>> "$LOG_FILE" <<EOF
display dialog "Enter network path (Windows or Mac format):

Examples:
  \\\\\\\\server\\\\share\\\\path
  smb://server/share/path" default answer "" buttons {"Cancel", "Mount"} default button 2 with title "Mount Network Share"
text returned of result
EOF
)

dialog_result=$?
echo "Dialog exit code: $dialog_result" >> "$LOG_FILE"
echo "Dialog result: $user_input" >> "$LOG_FILE"

# Check if dialog was successful
if [ $dialog_result -ne 0 ]; then
    echo "User cancelled or dialog failed" >> "$LOG_FILE"
    exit 0
fi

# Check if input is empty
if [ -z "$user_input" ]; then
    echo "Empty input received" >> "$LOG_FILE"
    exit 0
fi

# Convert path
smb_url=$(convert_unc_to_smb "$user_input")
echo "Final SMB URL: $smb_url" >> "$LOG_FILE"

# Mount the share
echo "Attempting to mount: $smb_url" >> "$LOG_FILE"
open "$smb_url" 2>> "$LOG_FILE"
mount_result=$?
echo "Mount command exit code: $mount_result" >> "$LOG_FILE"
echo "=== Custom Mount Dialog Ended: $(date) ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

