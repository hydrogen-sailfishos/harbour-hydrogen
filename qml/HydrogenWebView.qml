import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import io.thp.pyotherside 1.5

WebViewPage {

    allowedOrientations: Orientation.All

    Component.onCompleted: {
        WebEngineSettings.setPreference(
                    "security.fileuri.strict_origin_policy", false,
                    WebEngineSettings.BoolPref)
    }
    WebView {
        id: webview
        url: app.hydrogenUrl
        anchors.fill: parent

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
            case "embed:linkclicked":
                var url = '/^http:\/\/localhost/'
                if (!data.uri.match('http://localhost'))
                    Qt.openUrlExternally(data['uri'])
                break
            default:
                console.log("Message: " + JSON.stringify(
                                message) + " data: " + JSON.stringify(data))
            }
        }
    }
}
