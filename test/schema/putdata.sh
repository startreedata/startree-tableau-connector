#!/usr/bin/env bash
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


rm -rf /tmp/calcs
rm -rf /tmp/staples

mkdir -p /tmp/calcs/rawdata
mkdir -p /tmp/staples/rawdata

# Calcs
cp calcs-table-config.json /tmp/calcs
cp calcs-schema.json /tmp/calcs
cp calcs-ingestion-spec.yml /tmp/calcs
cp Calcs.csv /tmp/calcs/rawdata
$PINOT_PATH/bin/pinot-admin.sh AddTable -tableConfigFile /tmp/calcs/calcs-table-config.json -schemaFile /tmp/calcs/calcs-schema.json -exec
$PINOT_PATH/bin/pinot-admin.sh LaunchDataIngestionJob -jobSpecFile /tmp/calcs/calcs-ingestion-spec.yml

# Staples
cp staples-table-config.json /tmp/staples
cp staples-schema.json /tmp/staples
cp staples-ingestion-spec.yml /tmp/staples
cp Staples_utf8.csv /tmp/staples/rawdata
$PINOT_PATH/bin/pinot-admin.sh AddTable -tableConfigFile /tmp/staples/staples-table-config.json -schemaFile /tmp/staples/staples-schema.json -exec
$PINOT_PATH/bin/pinot-admin.sh LaunchDataIngestionJob -jobSpecFile /tmp/staples/staples-ingestion-spec.yml
