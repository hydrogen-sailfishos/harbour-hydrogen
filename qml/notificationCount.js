// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
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
          // Most recent 10 discussions with unread:
          let top5 = request.result.filter(item => !!item.notificationCount)
                .sort((x,y) => x.lastMessageTimestamp - y.lastMessageTimestamp)
                .slice(-10).map(item => item.name || item.heroes[0])
                .reverse();

          var customEvent = new CustomEvent("framescript:notificationCount",
                           { detail: { count: notificationCount, top5 }});
          document.dispatchEvent(customEvent);
        };
    }
}

setInterval(refreshSession, 5000);

