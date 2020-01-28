#!/usr/bin/env python

import sys
import os

out = open(sys.argv[2], 'w+')

out.write("with Types; use Types;\n\n")
out.write("package Roms is\n\n")

roms = os.listdir(sys.argv[1])
for rom in roms:
    out.write(f"   {rom} : constant ROM := (")
    with open(os.path.join(sys.argv[1], rom), 'rb') as f:
        while 1:
            byte = f.read(1)
            if not byte:
                break
            out.write(f"16#{byte.hex()}#, ")
        out.write("others => 0);\n\n")

out.write("end Roms;")

out.close()
