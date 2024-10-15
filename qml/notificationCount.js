// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
//
// SPDX-FileCopyrightText: 2024 Mirian Margiani
//
// SPDX-License-Identifier: Apache-2.0

function getCurrentSession() {
    var matches = window.location.hash.match(/session\/(\d+)/);
    if (matches && matches.length > 1) {
        return matches[1];
    }
}

function refreshSession() {
    var currentSession = getCurrentSession();
    if (!currentSession) {
        return;
    }

    var result = indexedDB.open("hydrogen_session_" + currentSession);
    result.onerror = function(error) { console.error("open", error); }

    result.onsuccess = function(event) {
        var db = event.target.result;

        var transaction = db.transaction("roomSummary", "readonly", "relaxed");
        var storeNames = Array.from(transaction.objectStoreNames);
        if (storeNames.indexOf("roomSummary") === -1) return;

        var objectStore = transaction.objectStore("roomSummary");

        var request = objectStore.getAll();
        request.onerror = function(event) {
          console.error(event);
        };
        request.onsuccess = function(event) {
          var notificationCount = request.result.reduce((sum, item) => sum + item.notificationCount, 0);

          // Most recent bunch of discussions with unread
          let mostRecentCount = 20;
          let coverPreview = request.result.filter(item => !!item.notificationCount)
                .sort((x,y) => x.lastMessageTimestamp - y.lastMessageTimestamp)
                .slice(-mostRecentCount).map(item => ({
                    name: item.name || item.heroes[0],
                    count: item.notificationCount,
                })).reverse();

          var customEvent = new CustomEvent("framescript:notificationCount", {
              detail: {
                  count: notificationCount,
                  coverPreview: coverPreview,
              }
          });
          document.dispatchEvent(customEvent);
        };
    }
}

setInterval(refreshSession, 5000);

