# Proxmark III develoment environment for Windows
ProxSpace is a collection of tools that are required to compile the firmware and client of the Proxmark III. At its core ProxSpace uses msys2. MSYS2 is a software distro and building platform for Windows, it provides a bash shell, Autotools, revision control systems and the like for building native Windows applications using MinGW-w64 toolchains. ProxSpace uses the GNU Arm Embedded Toolchain for compiling the Proxmark III firmware.

## Files
ProxSpace comes with 3 different executables .bat files. 

 - `runme.bat` will start ProxSpace in x86 mode.
 - `runme64.bat`will start ProxSpace in x64 mode.
 - `autobuild.bat` runs a script (msys2/autobuild.sh) in x86 mode as well as in x64 mode at startup. The script will update all git repositories in the pm3 folder and then compile them and move a zip file with the just compiled firmware and client into the build folder. It is not designed for development, just for compiling.

## What's installed
ProxSpace comes with already installed tools, but most of the required tools will be automatically downloaded. All tools will be contained within the ProxSpace folder which means ProxSpace can be moved into a different directory or even a different Windows machine without the need to reinstall anything.
Following tools are already installed with the current ProxSpace version:
 - msys2
 - GNU Arm Embedded Toolchain 7-2018-q2
 
 Following tools will be automatically download:
 - gcc
 - Qt5
 - readline
 - git
 - perl
 - pkg-config

## Package management system
MSYS2 features a package management system to provide easy installation of packages, Pacman. It brings many powerful features such as dependency resolution and simple complete system upgrades (excluding the GNU Arm Embedded Toolchain), as well as straight-forward package building. All installed packages can be updated with `pacman -Syuu`

## Usage
 1. Extract 'ProxSpace' to a location on drive without spaces. For example `C:\Proxspace` or `D:\projects\public\proxmark\proxspace` are ok whereas `C:\My Documents\My Projects\proxspace` is not.
 2. Run `runme.bat` or `runme64.bat` depending on your Windows architecture.
 3. Get the Proxmark III repository you wish to compile. This can be done with git. For example `git clone https://github.com/Proxmark/proxmark3.git`.
 4. Go into the root directory of the repository you wish to compile. For example `cd proxmark3`.
 5. To build the project type `make clean && make all`. 
 6. In most cases the Proxmark III needs to be flashed with the just compiled firmware for details see **Firmware upgrading the Proxmark III**.
 7. To run the Proxmark III client type `./client/proxmark3.exe COM1` where COM1 is the USB port of the Proxmark III.
 8. Check your firmware revision on the Proxmark III with `hw ver`
 9. For basic help type `help`. Or for help on a set of sub commands type the command followed by help. For example `hf mf help`.
 
## Firmware upgrading the Proxmark III
Please note that more detail is available on the wiki: https://github.com/Proxmark/proxmark3/wiki
 1. Attach the Proxmark III to a USB port on your computer.
 2. Flash the bootrom and fullimage with `./client/flasher COM1 -b ./bootrom/obj/bootrom.elf ./armsrc/obj/fullimage.elf`where COM1 is the USB port of the Proxmark III.
 3. Wait for the process to complete.