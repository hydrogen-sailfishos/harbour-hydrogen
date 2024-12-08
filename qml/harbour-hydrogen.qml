// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
//
// SPDX-FileCopyrightText: 2024 Mirian Margiani
//
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0
import io.thp.pyotherside 1.5
import "cover"

ApplicationWindow {
    id: app
    cover: Component { HydrogenCover {} }

    allowedOrientations: Orientation.All
    property var openingArgument
    property bool isSettingsAvailable: true

    property int notificationCount: 0
    property int oldUnreadCount: 0
    onNotificationCountChanged: {
        if (oldUnreadCount < notificationCount && appConfig.showNotifications) {
            var tryToBeSilent = Qt.application.state == Qt.ApplicationActive;
            var message = notificationComponent.createObject(null, {
                'previewSummary': tryToBeSilent ? null: qsTr("New hydrogen message."),
                'isTransient': !appConfig.stickyNotifications,
                'urgency': tryToBeSilent ? Notification.Low : Notification.Normal,
                'itemCount': notificationCount,
                'replacesId': appConfig.lastNotificationId
            })
            message.publish()
            appConfig.lastNotificationId = message.replacesId
        }
        oldUnreadCount = notificationCount
    }

    /* Array of objects: {name: "Name", count: 5}

       These messages will be shown on the cover with an optional
       title. Note that push() and pop() will not update the cover.
       You must reassign the property to trigger coverMessagesChanged signals.

       This does the trick:
         coverMessages.push(message)
         coverMessages = coverMessages

       Note: the title should stay empty if the messages are self-explanatory.
    */
    property var coverMessages: []
    property string coverTitle: "" // e.g. qsTr("New Messages")

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'))
            importModule('server', function () {})

            setHandler('finished', function (serverPort) {
                console.debug("webserver ready")
                var rand = Math.floor(Math.random() * (1<<20))
                webviewPage.hydrogenwebview.webView.url = Qt.resolvedUrl(
                            "http://localhost:" + serverPort + "/index.html?rand=" + rand)
            })
            setHandler('log', function (newvalue) {
                console.debug(newvalue)
            })
            startDownload()
        }
        function startDownload() {
            call('server.downloader.serve', function () {})
            console.debug("called")
        }
    }

    function cleanInvitation(link) {
        if (link) {
            var invit_raw = link.toString().split('#/')[1]
            return invit_raw.split('?')[0]
        }
    }

    function getSessionURL(url) {
        var urlParts = url.toString().split('session/')
        if (urlParts[1]) {
            return urlParts[0] + 'session/' + urlParts[1].split('/')[0]
        }
    }

    function handleUrlChange(url, link) {
        var pageName = url.toString().split('/')[6]
        var invit = cleanInvitation(link)
        var sessionURL = getSessionURL(url)
        if (sessionURL) {
            app.isSettingsAvailable = true
            if (invit) {
                var invitURL = sessionURL + '/room/' + invit
                if (webviewPage.hydrogenwebview.webView.url != invitURL) {
                    webviewPage.hydrogenwebview.webView.url = invitURL
                    app.openingArgument = null
                }
            }
            if (pageName === null || pageName === 'settings') {
                app.isSettingsAvailable = false
            }
        } else {
            app.isSettingsAvailable = false
        }
    }

    initialPage:
       HydrogenWebViewPage{
          id: webviewPage
    }

    DBusAdaptor {
        id: dbuslistener

        bus: DBus.SessionBus
        service: 'org.github.hydrogen-sailfishos.harbour-hydrogen.hydrogen'
        path: '/hydrogen/ui'
        // NB: DBus does not allow hyphens in interface names:
        iface: 'org.github.HydrogenSailfishOS.Hydrogen.ui'
        xml: [
            '<interface name="org.github.HydrogenSailfishOS.Hydrogen.ui">',
               '<method name="activate">',
                 '<annotation name="org.freedesktop.DBus.Method.NoReply" value="true" />',
                 '<annotation name="org.gtk.GDBus.DocString.Short" value="Brings the application forward" />',
               '</method>',
               '<method name="openUrl">',
                 '<arg name="url" type="s" direction="in" />',
                 '<annotation name="org.freedesktop.DBus.Method.NoReply" value="true" />',
                 '<annotation name="org.gtk.GDBus.DocString.Short" value="Loads the url given as argument into the application web view" />',
               '</method>',
             '</interface>'
        ].join('\n')

        function openUrl(u) {
            console.debug("openUrl called via DBus: %1".arg(u))
            app.openingArgument = u
            app.handleUrlChange(webviewPage.hydrogenwebview.webView.url, app.openingArgument)
            app.activate()
        }
        /* internal function: called on Notification click in Event View */
        function fromNotification(uid, mid) {
            console.debug("fromNotification called via DBus: %1".arg([uid, mid].join()))
        }
        /* internal function: called on Notification group click in Event View
         *
         * NB: By the FDO spec, we should be handling an action called "Open" or "Activate".
         * Due to QML function names only supporting lower-case names though, we can't.
         *
         * See https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#dbus
         * https://docs.sailfishos.org/Reference/Core_Areas_and_APIs/Apps_and_MW/Lipstick/Launchers/#d-bus-activation
         */
        function activate() {
            console.debug("activate called via DBus.")
            app.activate()
        }
        Component.onCompleted: {
            console.info("Registered D-Bus service %1".arg(service) )
            console.info("Registered D-Bus interface %1".arg(iface) )
        }
        Component.onDestruction: {
            console.info("Unregistering D-Bus service %1".arg(service) )
        }
    }

    Component {
        id: notificationComponent;
        Notification {
            appName: "Hydrogen"
            appIcon: "image://theme/harbour-hydrogen"
            summary: qsTr("New messages")
            category: "im.received"
            remoteActions: [
                {
                     // invoked when the user clicks the notification item
                     "name":     "default",
                     "displayName": qsTr("Open Conversation"),
                     "icon":     "icon-lock-chat",
                     "service":  dbuslistener.service,
                     "path":     dbuslistener.path,
                     "iface":    dbuslistener.iface,
                     "method":   "fromNotification"
                 },
                 {
                     // invoked when the user clicks the app notification group
                     "name": "app",
                     "service":  dbuslistener.service,
                     "path":     dbuslistener.path,
                     "iface":    dbuslistener.iface,
                     "method":   "activate",
                 }]
        }
    }

    // application settings:
    property alias appConfig: appConfig
    property alias wvConfig:  wvConfig
    ConfigurationGroup  {
        id: localSettings
        path: "/org/github/hydrogen-sailfishos"
    }
    ConfigurationGroup  {
        id: appConfig
        scope: localSettings
        path:  "app"
        property bool showNotifications: true
        property bool stickyNotifications: false
        property bool showFunFacts: true
        property int lastNotificationId: 42
    }
    ConfigurationGroup  {
        id: wvConfig
        scope: localSettings
        path:  "webview"
        property double zoom: 2.0
        property int ambienceMode: 2 //WebEngineSettings.FollowsAmbience
        property int memCache: 11 // automatic
    }
}

// vim: filetype=javascript expandtab ts=4 sw=4 st=4
