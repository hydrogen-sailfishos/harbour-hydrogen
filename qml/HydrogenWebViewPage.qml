import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0

WebViewPage {
    property string url
    property alias hydrogenwebview: hydrogenwebview
    allowedOrientations: Orientation.All

    HydrogenWebView {
        id: hydrogenwebview
        anchors.fill: parent

        PullDownMenu {
            MenuItem{
                text: qsTr('Settings')
                onClicked: hydrogenwebview.enterSettingsView()
            }
        }

    }
}
