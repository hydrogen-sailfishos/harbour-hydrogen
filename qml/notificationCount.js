
function getCurrentSession() {
    var matches = window.location.hash.match(/session\/(\d+)/);
    if (matches && matches.length > 1) {
        return matches[1];
    } else {
        var sessions = JSON.parse(localStorage.getItem("hydrogen_sessions_v1"));
        var recent = sessions.sort((x, y) => x.lastUsed - y.lastUsed).pop();
        if (recent) {
            return recent.id;
        }
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

        var transaction = db.transaction(["roomSummary"]);
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

setInterval(refreshSession, 3000);

