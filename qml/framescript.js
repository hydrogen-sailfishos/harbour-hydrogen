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

