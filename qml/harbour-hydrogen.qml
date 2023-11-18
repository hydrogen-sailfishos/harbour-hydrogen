import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import io.thp.pyotherside 1.5

ApplicationWindow {
    id: app
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    property string hydrogenUrl
    property var openingArgument: Qt.application.arguments

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'))
            importModule('server', function () {})

            setHandler('finished', function (serverPort) {
                console.debug("webserver ready")
                var rand = Math.floor(Math.random() * (1<<20))
                app.hydrogenUrl = Qt.resolvedUrl(
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

    function cleanInvitation() {
        if (openingArgument[2]) {
            var invit_raw = openingArgument[2].split('#/')[1]
            return encodeURIComponent(invit_raw.split('?')[0])
        }
    }

    function getSessionURL(url) {
        var urlParts = url.toString().split('session/')
        if (urlParts[1]) {
            return urlParts[0] + 'session/' + urlParts[1].split('/')[0]
        }
    }

    function handleUrlChange(url) {
        var invit = cleanInvitation()
        var session = getSessionURL(url)
        if (invit && session) {
            var invitURL = session + '/room/' + invit
            if (app.hydrogenUrl != invitURL) {
                app.hydrogenUrl = invitURL
                openingArgument[2] = null
            }
        }
    }

    initialPage:
       HydrogenWebViewPage{
          id: webviewPage
    }
}
