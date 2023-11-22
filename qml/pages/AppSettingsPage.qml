// This file is part of harbour-hydrogen
// Copyright (c) 2023 Peter G. (nephros)
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    SilicaFlickable{
        anchors.fill: parent
        contentHeight: col.height
        Column {
            id: col
            spacing: Theme.paddingLarge
            bottomPadding: Theme.itemSizeLarge
            width: parent.width - Theme.horizontalPageMargin
            PageHeader{ title:  Qt.application.name + " " + qsTr("Settings", "page title") }
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Notifications")
            }
            TextSwitch{ id: notifysw
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: appConfig.showNotifications
                automaticCheck: true
                text: qsTr("Show Notifications")
                //description: qsTr("If enabled, ... .")
                onClicked: appConfig.showNotifications = checked
            }
            TextSwitch{
                enabled: notifysw.checked
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: appConfig.stickyNotifications
                automaticCheck: true
                text: qsTr("Sticky Notifications")
                description: qsTr("If enabled, the app will update a single notification (as opposed to sending a new one each time).")
                onClicked: appConfig.stickyNotifications = checked
            }
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Web View")
            }
            Label {
                width: parent.width - Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                //color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                text: qsTr("Restart the App to apply changes to any of the values below.")
            }
            ComboBox{
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Theme Mode")
                description: qsTr("Whether we will follow the Ambience style, or used fixed Light or Dark mode.")
                menu: ContextMenu {
                    MenuItem { text: qsTr("Light Mode"); }
                    MenuItem { text: qsTr("Dark Mode"); }
                    MenuItem { text: qsTr("Follow Ambience"); }
                }
                property bool ready: false
                onCurrentIndexChanged: {
                    if (!ready) return
                    if( currentIndex >=0 ) {
                        wvConfig.ambienceMode = currentIndex
                    }
                }
                Component.onCompleted: {
                    if (wvConfig.ambienceMode) currentIndex = wvConfig.ambienceMode
                    ready = true
                }

            }
            Label {
                anchors {
                    // align to slider left
                    left: zoomSlider.left
                    leftMargin: zoomSlider.leftMargin //+ Theme.paddingLarge
                    right: zoomSlider.right
                    rightMargin: zoomSlider.rightMargin //+ Theme.paddingLarge
                    topMargin: Theme.paddingMedium
                }
                text: qsTr("Scale user interface")
                width: parent.width
                color: Theme.secondaryHighlightColor
                wrapMode: Text.Wrap
            }
            Slider {
                id: zoomSlider
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Page Zoom factor")
                minimumValue: 0.8
                maximumValue: 4.3
                stepSize: 0.2
                value: wvConfig.zoom
                valueText: "x" + value
                onReleased:  { wvConfig.zoom = sliderValue }
            }
            Label {
                anchors {
                    // align to slider left
                    left: zoomSlider.left
                    leftMargin: zoomSlider.leftMargin //+ Theme.paddingLarge
                    right: zoomSlider.right
                    rightMargin: zoomSlider.rightMargin //+ Theme.paddingLarge
                    topMargin: Theme.paddingMedium
                }
                text: qsTr("Browser Memory")
                width: parent.width
                color: Theme.secondaryHighlightColor
                wrapMode: Text.Wrap
            }
            Slider {
                id: memSlider
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Memory Cache")
                minimumValue: 0
                maximumValue: 11
                stepSize: 0.5
                value: wvConfig.memCache ? wvConfig.memCache: -1
                valueText: {
                    if (sliderValue === 11) {
                        return qsTr("automatic")
                    } else if (sliderValue === 0) {
                        return qsTr("disabled")
                    } else {
                        Math.round(sliderValue * 12.8) + qsTr("MB");
                    }
                }
                onReleased: wvConfig.memCache = Math.round(sliderValue)
            }
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
