import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0

WebViewPage {
    property string url
    allowedOrientations: Orientation.All

    HydrogenWebView {
        id: hydrogenwebview
        anchors.fill: parent
        urlFromParent: url

        PullDownMenu {
            MenuItem{
                text: qsTr('Settings')
                onClicked: hydrogenwebview.enterSettingsView()
            }
            MenuItem{
                text: qsTr('Back')

            }
        }

    }
}
