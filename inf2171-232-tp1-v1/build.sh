#!/bin/bash

java -jar rars1_6.jar nc p a ae1 main.s && echo "PASS: ASM" || { echo "FAIL: ASM"; exit 1; }
java -jar rars1_6.jar nc p main.s && echo "PASS: EXE" || { echo "FAIL: EXE"; exit 1; }

