#!/bin/bash

git clone --bare https://github.com/AnurupDey/dotfiles.git "$HOME/.dotfiles"

dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $@
}

mkdir -p .dotfiles.bkp
dotfiles checkout
if [ $? = 0 ]; then
    echo "Checked out dotfiles";
else
    echo "Backing up pre-existing dotfiles";
    dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -d $'\n' sh -c 'for arg do mkdir -p `dirname .dotfiles.bkp/"$arg"`; mv "$arg" .dotfiles.bkp/"$arg"; done' _
fi;
dotfiles checkout

dotfiles config status.showUntrackedFiles no
