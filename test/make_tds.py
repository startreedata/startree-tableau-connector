#!/usr/bin/env python3
#
# Copyright 2022 StarTree Inc.
#
# Licensed under the StarTree Community License (the "License"); you may not use
# this file except in compliance with the License.  You may obtain a copy of the
# License at http://www.startree.ai/startree-community-license
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
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
