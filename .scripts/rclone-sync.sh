#!/bin/bash

# Utils for syncing with remote drives.
#
# source into .bashrc to use from anywhere

drivesync() {
    # check if the prerequisites are installed,
    # Install them if not already installed
    if ! command -v rclone &> /dev/null
    then
        echo "rclone prerequisite not installed. Installing and configuring..."
        if command -v pacman &> /dev/null
        then
            sudo pacman -S --noconfirm rclone
        fi # add to install via other package manager like apt-get

        echo "Enter rclone gdrive client ID (see https://rclone.org/drive/#making-your-own-client-id): "
        read -r VAR_RCLONE_DRIVE_CLIENT_ID
        echo "Enter rclone gdrive client secret: "
        read  -r VAR_RCLONE_DRIVE_CLIENT_SECRET
        rclone config create remote-drive drive scope drive client_id "$VAR_RCLONE_DRIVE_CLIENT_ID" client_secret "$VAR_RCLONE_DRIVE_CLIENT_SECRET" 

        echo "Enter encryption password: "
        read -r VAR_ENCRYPTION_PASSWORD
        VAR_ENCRYPTION_PASSWORD_OBSCURED=$(echo "$VAR_ENCRYPTION_PASSWORD" | rclone obscure -) 
        echo "Enter salting password: "
        read -r VAR_SALTING_PASSWORD
        VAR_SALTING_PASSWORD_OBSCURED=$(echo "$VAR_SALTING_PASSWORD" | rclone obscure -)
        rclone config create remote-drive-encrypt crypt remote remote-drive:Private directory_name_encryption false password "$VAR_ENCRYPTION_PASSWORD_OBSCURED" password2 "$VAR_SALTING_PASSWORD_OBSCURED"

    fi
    if ! command -v stow &> /dev/null
    then
        echo "GNU stow prerequisite not installed. Installing..."
        if command -v pacman &> /dev/null
        then
            sudo pacman -S --noconfirm stow
        fi # add to install via other package managers like apt-get.
    fi
    case "$1" in
        up)
            rclone sync -PL "$HOME/Private" remote-drive-encrypt:
            ;;
        down)
            rclone sync -PL remote-drive-encrypt: "$HOME/Private"
            CURDIR=$PWD # save current directory so we can return after sync
            cd "$HOME/Private" || return
            stow .
            cd "$CURDIR" || return
            ;;
        *)
            echo "UNRECOGNIZED COMMAND"
            ;;
    esac
}
