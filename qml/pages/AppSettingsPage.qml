// This file is part of harbour-hydrogen
// Copyright (c) 2023 Peter G. (nephros)
//
// SPDX-FileCopyrightText: 2024 Mirian Margiani
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: root
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: col.height

        Column {
            id: col
            spacing: Theme.paddingLarge
            bottomPadding: Theme.itemSizeLarge
            width: parent.width

            PageHeader {
                title: qsTr("Settings", "page title")

                // The version number must be updated manually when a new version is released!
                description: qsTr("Version %1", "app version").arg("0.4.2")
            }

            SectionHeader {
                text: qsTr("Notifications")
            }

            TextSwitch {
                id: notifysw
                checked: appConfig.showNotifications
                text: qsTr("Show notifications")
                onClicked: appConfig.showNotifications =
                           !appConfig.showNotifications
            }

            TextSwitch {
                enabled: notifysw.checked
                checked: appConfig.stickyNotifications
                text: qsTr("Sticky notifications")
                description: qsTr("If enabled, when the app has a notification " +
                                  "it will also be present in the events view. " +
                                  "Otherwise it is transient.")
                onClicked: appConfig.stickyNotifications =
                           !appConfig.stickyNotifications
            }

            TextSwitch {
                checked: appConfig.showFunFacts
                text: qsTr("Show fun facts while loading")
                description: qsTr("If enabled, the app will show " +
                                  "fun science facts about Hydrogen " +
                                  "during startup.")
                onClicked: appConfig.showFunFacts =
                           !appConfig.showFunFacts
            }

            SectionHeader {
                text: qsTr("Web View")
            }

            Label {
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                text: qsTr("Restart the App to apply changes to any of " +
                           "the values below.")
            }

            ComboBox {
                label: qsTr("Color theme")
                description: qsTr("This setting defines whether the app will " +
                                  "follow the current ambience style, or always " +
                                  "use either dark or light mode.")
                menu: ContextMenu {
                    MenuItem { text: qsTr("Light mode"); }
                    MenuItem { text: qsTr("Dark mode"); }
                    MenuItem { text: qsTr("Follow ambience"); }
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

            Slider {
                id: zoomSlider
                width: parent.width

                label: qsTr("User interface scale factor")
                minimumValue: 0.8
                maximumValue: 4.3
                stepSize: 0.2
                value: wvConfig.zoom
                valueText: value.toLocaleString(Qt.locale(), 'f', 2)
                onReleased: {
                    wvConfig.zoom = sliderValue
                }
            }

            Slider {
                id: memSlider
                width: parent.width

                label: qsTr("Memory cache size")
                minimumValue: 0
                maximumValue: 11
                stepSize: 0.5
                value: wvConfig.memCache ? wvConfig.memCache : -1
                valueText: {
                    if (sliderValue === 11) {
                        return qsTr("automatic")
                    } else if (sliderValue === 0) {
                        return qsTr("disabled")
                    } else {
                        return qsTr("%1 MB", "memory size, as in “10 megabytes”")
                               .arg(Math.round(sliderValue * 12.8))
                    }
                }
                onReleased: {
                    wvConfig.memCache = Math.round(sliderValue)
                }
            }
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
