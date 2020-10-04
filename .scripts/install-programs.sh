#!/bin/bash
#
# installs the important programs that I user

if command -v pacman &> /dev/null
then
   sudo pacman -S pacaur 
   pacaur -S emacs rofi vimix-icon-theme community/code inkscape

   # flutter and dart sdk
   git clone https://github.com/flutter/flutter.git ~/tools/flutter
   flutter doctor
   flutter channel beta
   flutter upgrade
   flutter config --enable-web
   
   # installs doom emacs
   ~/.emacs.d/bin/doom install
   ~/.emacs.d/bin/doom doctor
   
   # sets up the emacs daemon
   systemctl --user enable emacs
   systemctl --user start emacs
fi
