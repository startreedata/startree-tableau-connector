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
(function propertiesbuilder(attr) {
    var props = {};

    const USER_KEY = "user";
    const PASSWORD_KEY = "password";
    const SCHEME_KEY = "scheme";
    const TENANT_KEY = "tenant";
    const BROKER_TLS_KEY = "brokerTlsV10Enabled";
    const CONTROLLER_TLS_KEY = "controllerTlsV10Enabled";

    props[TENANT_KEY] = attr["v-tenant"];
    props[SCHEME_KEY] = attr["v-scheme"];
    props[BROKER_TLS_KEY] = attr["v-broker-tls"];
    props[CONTROLLER_TLS_KEY] = attr["v-controller-tls"];

    if (attr[connectionHelper.attributeAuthentication] === "auth-user-pass") {
        props[USER_KEY] = attr[connectionHelper.attributeUsername];
        props[PASSWORD_KEY] = attr[connectionHelper.attributePassword];
    }

    // Parse additional properties passed through additional properties attribute
    if (attr["v-additional-properties"]) {
        const additionalProperties = attr["v-additional-properties"].split(/\r?\n/)
        for (const property of additionalProperties) {
            let [key, ...value] = property.trim().split("=");
            value = value.join('=').trim();
            props[key.trim()] = value;
        }
    }

    return props;
})
