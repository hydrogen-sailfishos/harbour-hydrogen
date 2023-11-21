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
                text: qsTr('App Settings')
                onClicked: pageStack.push(Qt.resolvedUrl("pages/AppSettingsPage.qml"))
            }
            MenuItem{
                text: qsTr('Hydrogen Settings')
                onClicked: hydrogenwebview.enterSettingsView()
            }
        }

    }
}
