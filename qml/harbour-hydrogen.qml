import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import io.thp.pyotherside 1.5

ApplicationWindow {
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'))
            importModule('server', function () {})

            setHandler('finished', function (serverPort) {
                console.debug("webserver ready")
                var rand = Math.floor(Math.random() * (1<<20))
                webview.url = Qt.resolvedUrl(
                            "http://localhost:" + serverPort + "/index.html?rand=" + rand)
            })
            setHandler('log', function (newvalue) {
                console.debug(newvalue)
            })
            startDownload()
        }
        function startDownload() {
            call('server.downloader.serve', function () {})
            console.debug("called")
        }
    }

    initialPage: HydrogenWebView {
        id: webview
    }
}
