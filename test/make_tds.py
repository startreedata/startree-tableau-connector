#!/usr/bin/env python3
#
# Copyright 2021 StarTree Inc. All rights reserved. Confidential and Proprietary Information of StarTree Inc.
#


import sys

HOST_NAME_ID = "{{hostname}}"

input_file_name = sys.argv[1]
host_name = sys.argv[2]

with open(input_file_name, 'r', encoding='utf8') as input_file:
    for line in input_file:
        if HOST_NAME_ID in line:
            line = line.replace(HOST_NAME_ID, host_name)
        
        print(line, end='')
