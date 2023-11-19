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
        webview.runJavaScript(script)
    }
    function enterSettingsView() {
        var settingsURL = app.getSessionURL(webview.url) + '/settings'
        webview.url = settingsURL
    }

    Private.VirtualKeyboardObserver {
        id: virtualKeyboardObserver
        active: webview.enabled

        // Update content height only after virtual keyboard fully opened.
        states: State {
            name: "boundHeightControl"
            when: virtualKeyboardObserver.opened && webview.enabled
            PropertyChanges {
                target: webview
                viewportHeight: isPortait ? Screen.height - virtualKeyboardObserver.imSize : Screen.width - Qt.inputMethod.keyboardRectangle.width
            }
        }
    }

    webView {
        id: webview
        anchors.fill: parent
        url: urlFromParent
        onViewInitialized: {
            console.log("loading framescript")
            webview.loadFrameScript(Qt.resolvedUrl("framescript.js"))
            webview.addMessageListener("webview:log")
        }
        onUrlChanged: {
            app.handleUrlChange(webview.url)
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
        onLoadedChanged: {
            if (webview.loaded) {
                console.log("loaded is true");
            webview.runJavaScript('
function refreshSession() {
    var session0 = JSON.parse(localStorage.getItem("hydrogen_sessions_v1"))[0].id;
    var result = indexedDB.open("hydrogen_session_"+session0);
    result.onerror = function(error) { console.error("open", error); }


    result.onsuccess = function(event) {
        var db = event.target.result;

        var transaction = db.transaction(["roomSummary"]);
        var objectStore = transaction.objectStore("roomSummary");

        var request = objectStore.getAll();
        request.onerror = function(event) {
          console.error(event);
        };
        request.onsuccess = function(event) {
          console.log(`Result is`,request.result);
          var notificationCount = request.result.reduce((sum, item) => sum + item.notificationCount, 0);
          var customEvent = new CustomEvent("framescript:log",
                           { detail: { count: notificationCount }});
          document.dispatchEvent(customEvent);
        };
    }
}

setInterval(refreshSession, 500);

');
                }
        }
    }
}


