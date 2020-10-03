#!/bin/bash
#
# installs the important programs that I user

if command -v pacman &> /dev/null
then
   sudo pacman -S pacaur 
   sudo pacaur -S emacs rofi vimix-icon-theme code-oss inkscape

   # gtk theme
   git clone https://github.com/Zortax/Vimix-Midnight ~/.themes/Vimix-Midnight

   # flutter and dart sdk
   git clone https://github.com/flutter/flutter.git
   flutter doctor
   flutter channel beta
   flutter upgrade
   flutter config --enable-web
   
   # installs doom emacs
   git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
   ~/.emacs.d/bin/doom install
   ~/.emacs.d/bin/doom doctor
   
   # sets up the emacs daemon
   systemctl --user enable emacs
   systemctl --user start emacs
fi
