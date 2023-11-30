// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
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
    BusyLabel {
        running: !hydrogenwebview.webView.loaded
        // break binding after first load:
        onRunningChanged: { if (hydrogenwebview.webView.loaded) running = false }
        Component.onCompleted: text = Fact.get()
    }
}
