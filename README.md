# Dotfiles

This repository contains my personal dotfiles and scripts to replicate the setup on any machine.

## Installation

If migrating to a new machine, use the following to automatically clone all the dotfiles and setup the shell environment correctly.

Make sure you have logged out of the `XFCE` session and execute the following inside a `tty`

```sh
curl -Lks https://bit.ly/37xKDZ3 | /bin/bash
```

Restart the machine and log back in. Don't log in without restarting.
#+BEGIN_SRC sh
shutdown -r now
#+END_SRC

To install the vital software packages:

```sh
bash ~/.scripts/install-programs.sh
```

Private configuration and files like `ssh` keys and `gpg` encrypted files are synced using `google drive` and `rclone`.

The remote drive can then be set up using

```sh
drivesync down
```

If the above does not work, it is most commonly due to the passwords being wrongly mangled by the script. Use `rclone config` and edit the remote `remote-drive-encrypt` with the correct passwords and try the above command again. This issue seemed to be solved as of now.

## Usage

### `dotfiles` command
This is an alias for `git`
- Use `dotfiles status` to check what dotfiles have changed
- Use `dotfiles add <filename>` to add changes made to any file into the repository from anywhere
- Use `dotfiles commit -m "message"= and =dotfiles push` to push changes to git remote from anywhere

### `drivesync` command
- use `drivesync down` to copy the private files to machine and make symlinks in the proper places
- use `drivesync up` to make the local changes be reflected in remote drive
- use `drivesync backup` to update a backup of the `Drive` folder
- use `drivesync restore` to restore from the last backup of the `Drive` folder

The files are encrypted on the local machine before sending to the remote drive, so google does not snoop on my secrets.

## Directory Structure

### `~/Private`
- Private files that need to be synced to Google Drive but need to be encrypted should be kept in `~/Private`.
- Keep files that need to be symlinked to other locations in `~/Private/home`. Files in `~/Private` but not in `~/Private/home` will be synced with encryption but will not be symlinked automatically.

### `~/Drive`
- Normal files that need to be backed up to Google Drive should be kept in `~/Drive`. These will not be encrypted.
