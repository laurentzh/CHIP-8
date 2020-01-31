# CHIP-8 Interpreter

This project was done for the EPITA Ada courses and the Make With Ada contest.
<https://www.makewithada.org>

CHIP-8 ROMS were found here:

<https://github.com/JamesGriffin/CHIP-8-Emulator/tree/master/roms>

## Requirements

* You need to have GNAT installed (host and target):

<https://www.adacore.com/download>

* You will also need stlink:

<https://github.com/texane/stlink>

## Hardware

STM32F429 Discovery

## Install

First clone the `Ada_Drivers_Library` repository:
```bash
git clone --recursive https://github.com/AdaCore/Ada_Drivers_Library.git
source env.sh
python2 Ada_Drivers_Library/scripts/install_dependencies.py
```

## Compile and flash project

```bash
source env.sh        #if not already done
gprbuild --target=arm-eabi -d -P chip8.gpr -XLCH=led -XRTS_Profile=ravenscar-sfp -XLOADER=ROM -XADL_BUILD_CHECKS=Disabled src/main.adb -largs -Wl,-Map=map.txt
arm-eabi-objcopy -O binary objrelease/main objrelease/main.bin
st-flash --reset write objrelease/main.bin 0x8000000
```

## Choose ROM

We encountered a few memory problems with the implementation of the menu. So,
in order to choose the ROM, you need to change the argument of the call to
`Load_Rom` in the `main.adb` file.

## Videos

<https://youtu.be/SudZGat54XU>

<https://youtu.be/OLU-3eOG690>

## Authors

* Damien GRISONNET       <damien.grisonnet@epita.fr>
* Laurent ZHU            <laurent.zhu@epita.fr>

EPITA GISTRE 2020
