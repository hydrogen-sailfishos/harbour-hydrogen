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
            spacing: Theme.paddingMedium
            bottomPadding: Theme.itemSizeLarge
            width: parent.width - Theme.horizontalPageMargin
            PageHeader{ title:  Qt.application.name + " " + qsTr("Settings", "page title") }
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Application")
            }
            /*
            TextSwitch{
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: app.hideui
                automaticCheck: true
                text: qsTr("Hide UI in landscape mode")
                description: qsTr("If enabled, the top and bottom bars are hidden in landscape mode.")
                onClicked: app.hideui = checked
            }
            */
            SectionHeader {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Web View")
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
                        app.ambienceMode = currentIndex
                    }
                }
                Component.onCompleted: {
                    if (app.ambienceMode) currentIndex = app.ambienceMode
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
            Slider{
                id: zoomSlider
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Page Zoom factor")
                minimumValue: 0.8
                maximumValue: 4.3
                stepSize: 0.2
                value: app.zoom
                valueText: "x" + value
                onReleased:  { app.zoom = sliderValue }
            }
            /*
            Slider{
                id: memSlider
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Cache Memory")
                minimumValue: 0
                maximumValue: 10
                stepSize: 0.5
                value: app.memCache ? app.memCache: -1
                valueText: {
                    if (sliderValue === 0) {
                        return qsTr("automatic");
                    } else {
                        return Math.round(sliderValue * 12.8) + qsTr("MB");
                    }
                }
                onReleased: app.memCache = Math.round(sliderValue)
            }
            Label{
                anchors {
                    // align to slider left
                    left: memSlider.left
                    leftMargin: memSlider.leftMargin //+ Theme.paddingLarge
                    right: memSlider.right
                    rightMargin: memSlider.rightMargin //+ Theme.paddingLarge
                    topMargin: Theme.paddingMedium
                }
                width: parent.width // - Theme.paddingLarge
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
                text: qsTr("Restart the App to apply changes to zoom factor or mem cache.")
            }
            */
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
