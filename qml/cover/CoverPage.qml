import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Icon {
        z: -1
        source: Qt.resolvedUrl("./hydrogen.svg")
        anchors.horizontalCenter: parent.left
        anchors.bottom: parent.bottom
        height: parent.height
        fillMode: Image.PreserveAspectFit
        color: Theme.secondaryColor
        opacity: visible ? 0.2 : 0.0
        Behavior on opacity{ FadeAnimation { duration: 1200 } }
    }
    Label {
        id: label
        anchors.centerIn: parent
        anchors.fill: parent
        //width: parent.width
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr("Hydrogen")
        font.pixelSize: Theme.fontSizeHuge
        font.capitalization: Font.SmallCaps
        //rotation: 90
        color: Theme.secondaryColor
        opacity: visible ? 1.0 : 0.2
        Behavior on opacity{ FadeAnimation { duration: 1200 } }
    }
    Label {
        visible: app.coverMessage.length > 0
        text: app.coverMessage
        anchors.bottom:
        coverAction.top
    }

    CoverActionList {
        id: coverAction
    }
}
