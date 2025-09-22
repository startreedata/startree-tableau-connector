/*
 * Copyright 2022 StarTree Inc.
 *
 * Licensed under the StarTree Community License (the "License"); you may not use
 * this file except in compliance with the License.  You may obtain a copy of the
 * License at http://www.startree.ai/startree-community-license
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OF ANY KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations under the License.
 */
(function dsbuilder(attr) {
    if (!attr) {
        throw new Error("Attributes object is null or undefined");
    }

    const server = attr[connectionHelper.attributeServer];
    const port = attr[connectionHelper.attributePort];
    let multistage = attr["v-multistage"];

    if (!server) {
        throw new Error("Server attribute is missing or null");
    }
    if (!port) {
        throw new Error("Port attribute is missing or null");
    }

    // Apply default instead of throwing error
    if (multistage === undefined || multistage === null || multistage === "") {
        multistage = false; // default to false (or true, based on requirement)
    }


    const urlBuilder =
        "jdbc:pinot://" +
        server + ":" + port +
        "?enableNullHandling=true" +
        "&useMultiStageEngine=" + multistage;

    return [urlBuilder];
})
