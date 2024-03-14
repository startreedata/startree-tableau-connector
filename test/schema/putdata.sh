#!/usr/bin/env bash
#
# Copyright 2021 StarTree Inc. All rights reserved. Confidential and Proprietary Information of StarTree Inc.
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
