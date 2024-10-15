// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
//
// SPDX-FileCopyrightText: 2024 Mirian Margiani
//
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    readonly property color hyColor: "#0dbd8b"
    readonly property color hyHighlightColor: Theme.highlightFromColor(hyColor, Theme.colorScheme)

    Connections {
        target: app
        onCoverMessagesChanged: messageView.model = app.coverMessages
    }

    HighlightImage {
        id: background
        z: -1
        source: Qt.resolvedUrl("./hydrogen.svg")
        anchors {
            horizontalCenter: parent.left
            verticalCenter: parent.bottom
        }
        height: parent.height
        fillMode: Image.PreserveAspectFit
        opacity: 0.15
        color: hyHighlightColor
    }

    Label {
        id: nameLabel
        text: "Hydrogen" // app name is not translated
        x: parent.width  - (width +  Theme.paddingLarge)
        y: parent.height - (height + Theme.paddingSmall*3)
        font.pixelSize: Theme.fontSizeLarge
        color: hyHighlightColor
    }

    Label {
        id: titleLabel
        visible: app.coverTitle.length > 0
        text: app.coverTitle
        width: parent.width - Theme.horizontalPageMargin
        x: Theme.horizontalPageMargin
        //y: Theme.paddingMedium
        anchors.top: label.bottom
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor
        wrapMode: Text.Wrap
    }
    ColumnView { id: messageView
        x: Theme.horizontalPageMargin
        width: parent.width - Theme.horizontalPageMargin
        height: parent.height - coverAction.height
        anchors.top: titleLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: app.coverMessages.length > 0
        opacity: visible ? 1.0 : 0.4
        Behavior on opacity { FadeAnimator { } }

        itemHeight: Theme.itemSizeSmall/2
        delegate: Label {
            text: modelData
            font.pixelSize: Theme.fontSizeTiny*0.8
            wrapMode: Text.NoWrap
            truncationMode: TruncationMode.Fade
            width: messageView.width
        }
    }
}
