import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0 as Private
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import io.thp.pyotherside 1.5

WebViewFlickable {
    id: webviewFlickable
    property string urlFromParent
    function runJavaScript(script) {
        webView.runJavaScript(script)
    }
    function enterSettingsView() {
        var urlParts = webView.url.toString().split('session')
        var settingsURL = urlParts[0] + 'session/'+ urlParts[1].split('/')[1] + '/settings'
        webView.url = settingsURL
    }

    Private.VirtualKeyboardObserver {
        id: virtualKeyboardObserver

        active: webview.enabled
        //transpose: window._transpose
        //orientation: browserPage.orientation

        //onWindowChanged: webview.chromeWindow = window

        // Update content height only after virtual keyboard fully opened.
        states: State {
            name: "boundHeightControl"
            when: virtualKeyboardObserver.opened && webview.enabled
            PropertyChanges {
                target: webview
                //TODO: make this work for Landscape mode as well
                viewportHeight: Screen.height - virtualKeyboardObserver.imSize
            }
        }
    }

    webView {
        id: webview
        anchors.fill: parent
        url: urlFromParent
        //active: false
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


