import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import io.thp.pyotherside 1.5
import "cover"

ApplicationWindow {
    id: app
    cover: HydrogenCover{
        notificationCount: app.notificationCount
    }

    allowedOrientations: Orientation.All
    property var openingArgument: Qt.application.arguments
    property int notificationCount: 0
    onNotificationCountChanged: {
        console.log("Updated notification count")
    }


    /* array of string.
       Use it something like below.
       Note that you can't usefully push() and pop() QML var type arrays.

            addMessage(message) {
                var msgs = coverMessages
                msgs.splice (message)
                coverMessage = msgs
            }
    */
    property var coverMessages: [] 
    property string coverTitle: "" // e.g. qsTr("New Messages")

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'))
            importModule('server', function () {})

            setHandler('finished', function (serverPort) {
                console.debug("webserver ready")
                var rand = Math.floor(Math.random() * (1<<20))
                webviewPage.url = Qt.resolvedUrl(
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
            if (webviewPage.url != invitURL) {
                webviewPage.url = invitURL
                openingArgument[2] = null
            }
        }
    }

    initialPage:
       HydrogenWebViewPage{
          id: webviewPage
    }
}
