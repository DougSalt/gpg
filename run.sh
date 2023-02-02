#!/bin/sh
#unzip -u gpg.zip
if [ $(uname) = "CYGWIN_NT-10.0" ]
then
    cd /cygdrive/c/Program\ Files/NetLogo\ 6.3.0/
    ./NetLogo $(cygpath -H)"\\git\\gpg\\test\\gpg.nlogo"
elif  [ $(uname) = "Darwin" ]
then
    ~/Applications/netlogo/NetLogo\ 6.3.0/netlogo-gui.sh $(pwd)/test/gpg.nlogo
else
    ~/.netlogo/NetLogo\ 6.3.0/NetLogo $(pwd)/test/gpg.nlogo
fi
