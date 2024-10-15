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
        anchors {
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
            bottom: coverActionArea.bottom
            bottomMargin: Theme.paddingMedium
        }
        font.pixelSize: Theme.fontSizeLarge
        color: hyHighlightColor
    }

    Label {
        id: titleLabel
        visible: !!text
        text: app.coverTitle
        color: Theme.highlightColor
        wrapMode: Text.Wrap
        height: visible ? implicitHeight : 0

        width: parent.width - 2*Theme.horizontalPageMargin
        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium
            horizontalCenter: parent.horizontalCenter
        }
    }

    ColumnView {
        id: messageView
        width: parent.width - 2*Theme.horizontalPageMargin
        anchors {
            top: titleLabel.bottom
            topMargin: Theme.paddingMedium
            bottom: nameLabel.top
            bottomMargin: Theme.paddingMedium
            horizontalCenter: parent.horizontalCenter
        }

        visible: opacity > 0.0
        opacity: app.coverMessages.length > 0 ? 1.0 : 0.0
        Behavior on opacity { FadeAnimator {} }
        itemHeight: Theme.fontSizeSmall * 2

        delegate: Item {
            width: parent.width
            height: Theme.fontSizeSmall * 2

            Label {
                id: countLabel
                text: modelData.count
                height: Theme.fontSizeSmall * 1.5
                verticalAlignment: Text.AlignBottom
                font.pixelSize: Theme.fontSizeSmall * 1.5
                truncationMode: TruncationMode.Fade
                color: Theme.secondaryHighlightColor
                width: implicitWidth

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                text: modelData.name
                font.pixelSize: Theme.fontSizeSmall
                truncationMode: TruncationMode.Fade
                color: Theme.secondaryHighlightColor

                anchors {
                    left: countLabel.right
                    leftMargin: Theme.paddingSmall
                    right: parent.right
                    baseline: countLabel.baseline
                }
            }
        }
    }

    OpacityRampEffect {
        direction: OpacityRamp.TopToBottom
        sourceItem: messageView
        offset: 0.6
        slope: 1.5
    }
}
