#!/bin/sh
#unzip -u gpg.zip
if [ $(uname) = "CYGWIN_NT-10.0" ]
then
    cd /cygdrive/c/Program\ Files/NetLogo\ 6.2.2/
    ./NetLogo "\\users\\ds42723\\git\\gpg\\test\\gpg.nlogo"
elif  [ $(uname) = "Darwin" ]
then
    ~/netlogo/NetLogo\ 6.2.2/netlogo-gui.sh $(pwd)/test/gpg.nlogo
else
    ~/.netlogo/NetLogo\ 6.2.2/NetLogo $(pwd)/test/gpg.nlogo
fi
