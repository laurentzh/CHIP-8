# CHIP-8 Interpreter

## Requirements

You need to have GNAT for your host and GNAT for arm installed:

https://www.adacore.com/download

## Install

First clone the `Ada_Drivers_Library` repository:
```
git clone --recursive https://github.com/AdaCore/Ada_Drivers_Library.git
source env.sh
python2 Ada_Drivers_Library/scripts/install_dependencies.py
```

## Compile project

```
source env.sh        #if not already done
gprbuild -P ada_project.gpr
```
