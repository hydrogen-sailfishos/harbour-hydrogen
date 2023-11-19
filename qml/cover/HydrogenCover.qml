import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    property int notificationCount: 0

    readonly property color hyColor:               "#0dbd8b"
    readonly property color hylightColor:          Theme.highlightFromColor("", Theme.ColorScheme)
    readonly property color secondaryHylightColor: Theme.secondaryHighlightFromColor("", Theme.ColorScheme)
    readonly property color dimmerHylightColor:    Theme.highlightDimmerFromColor("", Theme.ColorScheme)
    readonly property color logoColor:             Theme.rgba(hyColor, Theme.OpacityFaint)
    Icon {
        z: -1
        source: Qt.resolvedUrl("./hydrogen.svg" + "?" + logoColor)
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.bottom
        height: visible ? parent.height : 0
        fillMode: Image.PreserveAspectFit
        opacity: visible ? 0.2 : 0.0
        Behavior on opacity { FadeAnimator { duration: 1200 } }
        //Behavior on height  { PropertyAnimation { duration: 1200 ; easing.type: Easing.InBounce } }
    }
    Label {
        id: label
        text: qsTr("Hydrogen")
        x: (parent.width  - (width +  Theme.paddingLarge))
        y: (parent.height - (height + Theme.paddingMedium))
        //rotation: -90
        font.pixelSize: Theme.fontSizeMedium
        color:   visible ? hyColor : logoColor
        opacity: visible ? 1.0 : 0.2
        Behavior on opacity { FadeAnimator { duration: 2400; easing.type: Easing.OutBounce  } }
        Behavior on color { ColorAnimation { duration: 2400 } }
    }
    Label { id: titleLabel
        visible: app.coverTitle.length > 0
        text: app.coverTitle
        width: parent.width - Theme.horizontalPageMargin
        x: Theme.horizontalPageMargin
        y: Theme.paddingMedium
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor
        wrapMode: Text.Wrap
    }
    ColumnView { id: messageView
        width: parent.width - Theme.horizontalPageMargin
        x: Theme.horizontalPageMargin
        height: parent.height - coverAction.height
        anchors.top: titleLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: app.coverMessages.length > 0
        opacity: visible ? 1.0 : 0.4
        Behavior on opacity { FadeAnimator { } }

        itemHeight: Theme.itemSizeSmall/2
        model: app.coverMessages ? app.coverMessages : null
        delegate: Label {
            text: modelData
            font.pixelSize: Theme.fontSizeTiny*0.8
            wrapMode: Text.NoWrap
            truncationMode: TruncationMode.Fade
            width: messageView.width
        }
    }

    CoverActionList {
        id: coverAction
    }
}
