# CHIP-8 Interpreter

This project was done for the EPITA Ada courses and the Make With Ada contest.
<https://www.makewithada.org>

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
gprbuild -P chip8.gpr
arm-eabi-objcopy -O binary objrelease/main objrelease/main.bin
st-flash --reset write objrelease/main.bin 0x8000000
```

## Authors

* Damien GRISONNET       <damien.grisonnet@epita.fr>
* Laurent ZHU            <laurent.zhu@epita.fr>

EPITA GISTRE 2020
