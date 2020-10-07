#!/bin/bash
#
# installs the important programs that I user

if command -v pacman &> /dev/null
then
   sudo pacman -S pacaur emacs 
   pacaur -S rofi vimix-icon-theme community/code inkscape pscircle

   # flutter and dart sdk
   git clone https://github.com/flutter/flutter.git ~/tools/flutter
   flutter doctor
   flutter channel beta
   flutter upgrade
   flutter config --enable-web

   systemctl --user daemon-reload
   # pscircle
   systemctl --user enable pscircle.service
   systemctl --user start pscircle.service
   
   # installs doom emacs
   doom install
   doom doctor
   
   # sets up the emacs daemon
   systemctl --user enable emacs
   systemctl --user start emacs
fi
