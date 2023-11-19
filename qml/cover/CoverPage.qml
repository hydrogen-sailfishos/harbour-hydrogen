import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    property int notificationCount: 0
    Image {
               source: "/usr/share/icons/hicolor/172x172/apps/harbour-hydrogen.png"
               anchors {
                   left: parent.left
                   leftMargin: parent.width / 10
                   rightMargin: parent.width / 10
                   top: parent.top

                   right: parent.right
                   bottom: parent.bottom
               }
               fillMode: Image.PreserveAspectFit
               opacity: 0.2
           }

        Column {
            anchors.centerIn: parent
            anchors.top: parent.top
            anchors.topMargin: parent.height / 4


            Label {
                font.pixelSize: Theme.fontSizeLarge
                text: "Hydrogen"
            }

            Row {
                Label {
                    font.pixelSize: Theme.fontSizeMedium
                    text: notificationCount
                }

                Label {
                    font.pixelSize: Theme.fontSizeMedium
                    text: qsTr(" notifications")
                    anchors.bottom: parent.bottom
                }
            }
        }


    CoverActionList {
        id: coverAction
    }
}
