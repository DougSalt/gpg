#!/bin/sh
#unzip -u gpg.zip
if [ $(uname) = "CYGWIN_NT-10.0" ]
then
    cd /cygdrive/c/Program\ Files/NetLogo\ 6.2.0/
    ./NetLogo "\\users\\ds42723\\git\\gpg\\test\\demo.nlogo"
else
    ~/.netlogo/NetLogo\ 6.2.0/NetLogo $(pwd)/test/demo.nlogo
fi
