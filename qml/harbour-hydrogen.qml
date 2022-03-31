import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0

ApplicationWindow {
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    initialPage: WebViewPage {
        Component.onCompleted: {
            WebEngineSettings.setPreference(
                        "security.fileuri.strict_origin_policy", false,
                        WebEngineSettings.BoolPref)
        }
        WebView {
            id: webview
            anchors.fill: parent
            url: Qt.resolvedUrl("../hydrogen/index.html")

            onViewInitialized: {
                console.log("loading framescript")
                webview.loadFrameScript(Qt.resolvedUrl("framescript.js"))
                webview.addMessageListener("webview:log")
            }
            onRecvAsyncMessage: {
                switch (message) {
                case "webview:log":
                    console.log("webapp-log: " + JSON.stringify(data))
                    break
                default:
                    console.log("Message: " + JSON.stringify(
                                    message) + " data: " + JSON.stringify(data))
                }
            }
        }
    }
}
