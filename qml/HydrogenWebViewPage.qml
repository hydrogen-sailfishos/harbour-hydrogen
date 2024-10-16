// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
//
// SPDX-FileCopyrightText: 2024 Mirian Margiani
//
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import "hydrogenfacts.js" as Fact

WebViewPage {
    property string url
    property alias hydrogenwebview: hydrogenwebview
    allowedOrientations: Orientation.All

    HydrogenWebView {
        id: hydrogenwebview
        anchors.fill: parent
    }

    Rectangle {
        id: loadingBackground
        anchors.fill: parent
        color: Theme.highlightDimmerColor
        visible: opacity > 0.0
        Behavior on opacity { FadeAnimator{} }
        opacity: hydrogenwebview.webView.loaded ? 0.0 : 1.0
    }

    BusyLabel {
        running: !hydrogenwebview.webView.loaded
        onRunningChanged: {
            // break binding after first load
            if (hydrogenwebview.webView.loaded) running = false
        }

        Component.onCompleted: {
            if (appConfig.showFunFacts) {
                // the property must be set here, otherwise
                // we lose the default text
                text = Fact.get()
            }
        }
    }
}
