import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import "hydrogenfacts.js" as Facts

WebViewPage {
    property string url
    property alias hydrogenwebview: hydrogenwebview
    allowedOrientations: Orientation.All

    HydrogenWebView {
        id: hydrogenwebview
        anchors.fill: parent
    }
    BusyLabel {
        running: !hydrogenwebview.webView.loaded
        //text: qsTr("Loading Application")
        // break binding after first load:
        onRunningChanged: { if (hydrogenwebview.webView.loaded) running = false }
        Component.onCompleted: text = Facts.get()
    }
}
