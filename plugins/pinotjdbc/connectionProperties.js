/*
 * Copyright 2021 StarTree Inc. All rights reserved. Confidential and Proprietary Information of StarTree Inc.
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
