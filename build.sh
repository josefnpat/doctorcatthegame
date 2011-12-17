#!/bin/bash
#Configure this, and also ensure you have the dev/build_data/osx.patch ready.
NAME="doctorcat"

# *.love
cd $NAME
zip -r ../$NAME.love *
cd ..

# Temp Space
mkdir tmp

# LINUX
# Need to have love installed.
cat /usr/bin/love $NAME.love > tmp/${NAME}_linux
chmod a+x tmp/${NAME}_linux
cd tmp
zip -r ../${NAME}_linux.zip ${NAME}_linux
cd ..
rm tmp/* -rf #tmp cleanup
# WINDOWS
cat dev/build_data/love-0.7.2-win-x86/love.exe $NAME.love > tmp/$NAME.exe
cp dev/build_data/love-0.7.2-win-x86/*.dll tmp/
cd tmp
zip -r ../${NAME}_win.zip *
cd ..
rm tmp/* -rf #tmp cleanup

# OS X
cp dev/build_data/love.app tmp/$NAME.app -Rv
cp $NAME.love tmp/$NAME.app/Contents/Resources/
patch tmp/$NAME.app/Contents/Info.plist -i dev/build_data/osx.patch
cd tmp
zip -r ../${NAME}_osx.zip $NAME.app
cd ..
rm tmp/* -rf #tmp cleanup

# Cleanup
rm tmp -rf
