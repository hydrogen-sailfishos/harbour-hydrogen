import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import Nemo.DBus 2.0
import io.thp.pyotherside 1.5
import "cover"

ApplicationWindow {
    id: app
    cover: HydrogenCover{}

    allowedOrientations: Orientation.All
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
                webviewPage.hydrogenwebview.webView.url = Qt.resolvedUrl(
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

    function cleanInvitation(link) {
        if (link) {
            var invit_raw = link.toString().split('#/')[1]
            return encodeURIComponent(invit_raw.split('?')[0])
        }
    }

    function getSessionURL(url) {
        var urlParts = url.toString().split('session/')
        if (urlParts[1]) {
            return urlParts[0] + 'session/' + urlParts[1].split('/')[0]
        }
    }

    function handleUrlChange(url, link) {
        var invit = cleanInvitation(link)
        var sessionURL = getSessionURL(url)
        if (invit && sessionURL) {
            var invitURL = sessionURL + '/room/' + invit
            if (webviewPage.hydrogenwebview.webView.url != invitURL) {
                webviewPage.hydrogenwebview.webView.url = invitURL
                openingArgument = null
            }
        }
    }

    initialPage:
       HydrogenWebViewPage{
          id: webviewPage
    }

    DBusAdaptor {
        id: dbuslistener

        bus: DBus.SessionBus
        service: 'org.github.hydrogen-sailfishos.harbour-hydrogen.hydrogen'
        path: '/hydrogen/ui'
        // NB: DBus does not allow hyphens in interface names:
        iface: 'org.github.HydrogenSailfishOS.Hydrogen.ui'
        xml: '<interface name="org.github.HydrogenSailfishOS.Hydrogen.ui">
               <method name="openUrl">
                 <arg name="url" type="s" direction="in"/>
               </method>
             </interface>'

        function openUrl(u) {
            console.debug("openUrl called via DBus: %1".arg(u))
            openingArgument = u
            app.handleUrlChange(webviewPage.hydrogenwebview.webView.url, app.openingArgument)
            app.activate()
        }
        Component.onCompleted: {
            console.info("Registered D-Bus service %1".arg(service) )
            console.info("Registered D-Bus interface %1".arg(iface) )
        }
        Component.onDestruction: {
            console.info("Unregistering D-Bus service %1".arg(service) )
        }
    }
}
