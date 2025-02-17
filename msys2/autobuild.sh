#!/bin/bash 
pm3Dir=/pm3
copyDir=/builds
buildDir=/tmp

export PATH=/gcc-arm-none-eabi/bin:$PATH

pacman -Q zip 1> /dev/null
if [[ $? != 0 ]]; then
  pacman --noconfirm -S zip
fi

if [ "$MSYSTEM" == "MINGW32" ]; then
  mingwDir=/mingw32
  arch=32
fi

if [ "$MSYSTEM" == "MINGW64" ]; then
  mingwDir=/mingw64
  arch=64
fi

cd $pm3Dir
for i in $( ls ); do
  echo Processing: $i-$arch
  cd $pm3Dir/$i
  git fetch
  git pull
  hash=$(git rev-parse HEAD)
  date=$(date +%Y%m%d)
 if ! ls $copyDir/$i-$arch/*-$hash.zip 1> /dev/null 2>&1; then
    make clean
	make all
	if [ $? -eq 0 ]; then
	  rm -rf $buildDir/$i/*
	  mkdir -p $copyDir/$i-$arch/
	  mkdir -p $buildDir/$i/win$arch/platforms
	  mkdir -p $buildDir/$i/firmware_win/bootrom
	  mkdir -p "$buildDir/$i/firmware_win/JTAG Only"
	  mkdir -p "$buildDir/$i/Windows Driver"
	  #you have to thank QT5 for all that dlls
	  cp $mingwDir/bin/{libbz2-1.dll,libfreetype-6.dll,libgcc_s_dw2-1.dll,libglib-2.0-0.dll,libgraphite2.dll,libharfbuzz-0.dll,libiconv-2.dll,libicudt61.dll,libicuin61.dll,libicuuc61.dll,libintl-8.dll,libpcre-1.dll,libpcre2-16-0.dll,libpng16-16.dll,libreadline6.dll,libstdc++-6.dll,libtermcap-0.dll,libwinpthread-1.dll,Qt5Core.dll,Qt5Gui.dll,Qt5Widgets.dll,zlib1.dll,libgcc_s_seh-1.dll,libjansson-4.dll} $buildDir/$i/win$arch
	  cp -r /autobuild/* $buildDir/$i/win$arch
	  cp -r $pm3Dir/$i/client/{proxmark3.exe,flasher.exe,*.dic,lualibs,scripts,hardnested} $buildDir/$i/win$arch
	  cp $mingwDir/share/qt5/plugins/platforms/qwindows.dll $buildDir/$i/win$arch/platforms
	  cp $pm3Dir/$i/armsrc/obj/{fullimage.elf,fullimage.s19} $buildDir/$i/firmware_win
	  cp $pm3Dir/$i/bootrom/obj/{bootrom.elf,bootrom.s19} $buildDir/$i/firmware_win/bootrom
	  cp $pm3Dir/$i/recovery/{bootrom.bin,fullimage.bin,proxmark3_recovery.bin} "$buildDir/$i/firmware_win/JTAG Only"
	  cp $pm3Dir/$i/driver/proxmark3.inf "$buildDir/$i/Windows Driver"
	  rm $buildDir/$i/win$arch/hardnested/{*.h,*.c}
	  cd $buildDir/$i
	  zip -r $copyDir/$i-$arch/$i-$arch-$date-$hash.zip ./*
	  echo done
	fi
  fi
done