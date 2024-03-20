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


DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"

mkdir -p $SERVER_LOGS_PATH
$PINOT_PATH/bin/pinot-admin.sh StartZookeeper -zkPort 2191 > $SERVER_LOGS_PATH/pinot-zookeeper.log 2>&1 &
echo ZKPID=$! > $SERVER_LOGS_PATH/pinot-zookeeper.pid
sleep 5
export JAVA_OPTS="-Xms4G -Xmx8G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Xlog:gc:$SERVER_LOGS_PATH/gc-pinot-controller.log" && $PINOT_PATH/bin/pinot-admin.sh StartController -zkAddress localhost:2191 -controllerPort 9000 > $SERVER_LOGS_PATH/pinot-controller.log 2>&1 &
sleep 5
export JAVA_OPTS="-Xms4G -Xmx4G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Xlog:gc:$SERVER_LOGS_PATH/gc-pinot-broker.log" && $PINOT_PATH/bin/pinot-admin.sh StartBroker -zkAddress localhost:2191 > $SERVER_LOGS_PATH/pinot-broker.log 2>&1 &
sleep 5
export JAVA_OPTS="-Xms4G -Xmx16G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Xlog:gc:$SERVER_LOGS_PATH/gc-pinot-server.log" && $PINOT_PATH/bin/pinot-admin.sh StartServer -config $PWD/pinot-server.conf > $SERVER_LOGS_PATH/pinot-server.log 2>&1 &
sleep 5
#$PINOT_PATH/bin/pinot-admin.sh StartKafka -zkAddress=localhost:2191/kafka -port 19092 > $SERVER_LOGS_PATH/pinot-kafka.log 2>&1 &
