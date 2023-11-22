// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
//
// SPDX-License-Identifier: Apache-2.0

addEventListener("DOMContentLoaded", function (aEvent) {
    aEvent.originalTarget.addEventListener("framescript:log",
                                           function (aEvent) {
                                               sendAsyncMessage("webview:log",
                                                                aEvent.detail)
                                           })
    aEvent.originalTarget.addEventListener("framescript:notificationCount",
                                           function (aEvent) {
                                               sendAsyncMessage("webview:notificationCount",
                                                                aEvent.detail)
                                           })
})

