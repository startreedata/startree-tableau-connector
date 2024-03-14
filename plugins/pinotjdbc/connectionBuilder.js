/*
 * Copyright 2021 StarTree Inc. All rights reserved. Confidential and Proprietary Information of StarTree Inc.
 */

(function dsbuilder(attr) {
    const urlBuilder = "jdbc:pinot://" + attr[connectionHelper.attributeServer] + ":" + attr[connectionHelper.attributePort] + "?enableNullHandling=true";

    return [urlBuilder];
})
