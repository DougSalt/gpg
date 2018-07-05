#!/bin/sh
cd bin
/cygdrive/c/program\ files/java/jdk1.8.0_77/bin/jar -cvmf ../manifest.txt gpg.jar *class
mv gpg.jar ../examples/gpg
