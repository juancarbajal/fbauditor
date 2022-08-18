#!/bin/sh
cd src
fpc ./fbauditor.pp
rm *.o
cd ..
mv ./src/fbauditor ./fbauditor
echo 'COMPRIMIENDO... (No Necesario)'
upx ./fbauditor

