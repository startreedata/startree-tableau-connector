#!/usr/bin/env bash
#
# Copyright 2021 StarTree Inc. All rights reserved. Confidential and Proprietary Information of StarTree Inc.
#


$PINOT_PATH/bin/pinot-admin.sh StopProcess -controller -broker -server
sleep 10
# trying to use StopProcess with zookeeper fails, so instead we do this...
source $SERVER_LOGS_PATH/pinot-zookeeper.pid && kill $ZKPID
