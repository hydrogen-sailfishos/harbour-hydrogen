// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
//
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0

WebViewPage {
    property string url
    property alias hydrogenwebview: hydrogenwebview
    allowedOrientations: Orientation.All

    HydrogenWebView {
        id: hydrogenwebview
        anchors.fill: parent

        PullDownMenu {
            MenuItem{
                text: qsTr('Settings')
                onClicked: hydrogenwebview.enterSettingsView()
            }
        }

    }
}
